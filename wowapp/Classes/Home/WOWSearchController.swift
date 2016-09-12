//
//  WOWSearchController.swift
//  Wow
//
//  Created by dcpSsss on 16/4/3.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit
import VTMagic

class WOWSearchController: WOWBaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var dataArr = [WOWProductModel]()
    private var keyWords = [AnyObject](){
        didSet{
            /**
             *  如果热门搜索没有view就隐藏
             */
            if keyWords.isEmpty {
                searchTagView.hotSearchView.hidden = true
            }else{
                searchTagView.hotSearchView.hidden = false
            }
        }
    }
    
    private var searchArray = [String](){
        didSet{
            /**
             *  如果搜索历史没有view就隐藏
             */
            if searchArray.isEmpty {
                searchTagView.hisSearchView.hidden = true
            }else{
                searchTagView.hisSearchView.hidden = false
            }
        }
    }
    
//MARK:Life
    override func viewDidLoad() {
        super.viewDidLoad()
       requestHotKey()
       
    }
    
  
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        searchView.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItems = nil
        makeCustomerNavigationItem("", left: true, handler:nil)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        searchView.hidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit{
        searchTagView.hotTagListView.removeObserver(self, forKeyPath: "bounds")
        searchTagView.historyTagListView.removeObserver(self, forKeyPath: "bounds")
        searchView.removeFromSuperview()
        self.v_bottom.magicView.removeFromSuperview()
    }

    
//MARK:Lazy
    lazy var searchView:WOWSearchBarView = {
        let view = NSBundle.mainBundle().loadNibNamed(String(WOWSearchBarView), owner: self, options: nil).last as! WOWSearchBarView
        view.frame = CGRectMake(10, 8, MGScreenWidth - 30,30)
        view.searchTextField.delegate = self
        view.searchTextField.becomeFirstResponder()
        view.cancelButton.addTarget(self, action:#selector(cancel), forControlEvents:.TouchUpInside)
        return view
    }()
    
//    lazy var resultView : SearchResultView = {
//        let v = SearchResultView()
//        v.delegate = self
//        v.backgroundColor = UIColor.orangeColor()
//        v.frame = CGRectMake(0, MGScreenHeight,MGScreenWidth,MGScreenHeight - 64)
//       
//
//        return v
//    }()
    
    lazy var searchTagView: WOWSearchTagView = {
         let view = NSBundle.mainBundle().loadNibNamed(String(WOWSearchTagView), owner: self, options: nil).last as! WOWSearchTagView
        view.deleteButton.addTarget(self, action: #selector(deleteClick), forControlEvents: UIControlEvents.TouchUpInside)
        return view
    }()
    
    lazy var v_bottom: VCVTMagic = {
        let v = VCVTMagic()
        v.magicView.dataSource = self
        v.magicView.delegate = self
        v.magicView.backgroundColor = UIColor.whiteColor()
        self.addChildViewController(v)
        v.magicView.frame = CGRectMake(0, 0,MGScreenWidth,MGScreenHeight - 64)
        v.magicView.hidden = true
//        v.magicView.reloadData()

        return v
    }()
   
 


//MARK:Private Method
    override func setUI() {
        navigationController?.navigationBar.addSubview(searchView)
        
        defaultData()
        
        defaultSetup()
//        addBottomProductView()
        tableView.tableHeaderView = searchTagView
   
    }
    
    func defaultSetup() {
        searchTagView.hotTagListView.addObserver(self, forKeyPath: "bounds", options: .Old, context: nil)
        searchTagView.hotTagListView.delegate = self
        searchTagView.hotTagListView.alignment = .Left
        
        searchTagView.historyTagListView.addObserver(self, forKeyPath: "bounds", options: .Old, context: nil)
        searchTagView.historyTagListView.alignment = .Left
        searchTagView.historyTagListView.delegate = self
        
        
       
       
    }
    override func observeValueForKeyPath(keyPath: String?,
                                         ofObject object: AnyObject?,
                                                  change: [String : AnyObject]?,
                                                  context: UnsafeMutablePointer<Void>)
    {
        
        let height = searchTagView.hotTagListView.bounds.height + searchTagView.historyTagListView.bounds.height + 123
        searchTagView.frame = CGRectMake(0, 0, MGScreenWidth, height)
        tableView.beginUpdates()
        tableView.tableHeaderView = searchTagView
        tableView.endUpdates()
        print(height)
        print("高度发生变化")
        
    }
    func defaultData() {
        let sql = "SELECT * FROM t_searchModel order by id desc;"
        
        let resultSet = WOWSearchManager.shareInstance.db.executeQuery(sql, withArgumentsInArray: nil)
        
        searchArray = [String]()
        while resultSet.next() {
        
            let searchStr = resultSet.stringForColumn("searchStr")
    
            searchArray.append(searchStr)
        }
        
        for key in searchArray {
            searchTagView.historyTagListView.addTag(key)
        }
        
        
    }
    
    /**
     添加搜索历史，筛选出重复的字段
     
     - parameter searchStr: 
     */
    func searchHistory(searchStr: String) {
        if searchArray .contains(searchStr) {
            searchArray.removeObject(searchStr)
        }
        searchArray.insertAsFirst(searchStr)
        WOWSearchManager.shareInstance.insert(searchStr)
        searchTagView.historyTagListView.removeAllTags()
        for key in searchArray {
            searchTagView.historyTagListView.addTag(key)
        }
    }
    
    
//MARK:Actions
    
    func cancel(){
        searchView.searchTextField.resignFirstResponder()
        navigationController?.popViewControllerAnimated(true)
    }
    
    func deleteClick() {
        DLog("清除历史搜索")
        WOWSearchManager.shareInstance.delectAll("1")
        searchArray.removeAll()
        searchTagView.historyTagListView.removeAllTags()

    }
}

// MARK: - NET
extension WOWSearchController {
    func requestHotKey() {
        WOWNetManager.sharedManager.requestWithTarget(.Api_SearchHot, successClosure: {[weak self] (result) in
            if let strongSelf = self {
                let json = JSON(result)
                let array = json["keywords"].arrayObject
                if let keyWords = array {
                    strongSelf.keyWords = keyWords
                    for key in keyWords {
                        strongSelf.searchTagView.hotTagListView.addTag(key as! String)
                
                    }
                
                }
                
            }
            }) { (errorMsg) in
                
        }
    }
}
//MARK:Delegate

extension WOWSearchController: TagListViewDelegate {
    func tagPressed(title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        searchView.searchTextField.text = title
        searchView.searchTextField.resignFirstResponder()
        showResult()
        searchHistory(title)
    }
    
   

}

//搜索结果的item点击
extension WOWSearchController:SearchResultViewDelegate{
    func goodsItemClick(model: WOWGoodsModel) {
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWGoodsDetailController)) as! WOWGoodsDetailController
        vc.hideNavigationBar = true
        
        navigationController?.pushViewController(vc, animated: true)
    }
}



extension WOWSearchController:UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.text == "" {
            WOWHud.showMsg("请输入搜索关键字")
            return false
        }
        textField.resignFirstResponder()
        searchHistory(textField.text!)
        showResult()
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        hideResult()
        
        return true
    }
    

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        hideResult()
        return true
    }
    func showResult() {
//        view.addSubview(resultView)
        self.view.addSubview(v_bottom.magicView)
//        resultView.hidden = false
        self.navigationShadowImageView?.hidden = true
        v_bottom.magicView.hidden = false
        v_bottom.magicView.reloadDataToPage(0)
//        v_bottom.magicView.switchToPage(0, animated: false)
//        UIView.animateWithDuration(0.3) {
////            self.resultView.y = 40
//            self.v_bottom.magicView.y = 0
//        }
    }
    
    func hideResult()  {
        self.navigationShadowImageView?.hidden = false
        v_bottom.magicView.hidden = true
        v_bottom.magicView.clearMemoryCache()
        self.v_bottom.magicView.removeFromSuperview()

//        UIView.animateWithDuration(0.3, animations: {
////            self.resultView.y = MGScreenHeight + 20
//            self.v_bottom.magicView.y = MGScreenHeight + 20
//        }) { (ret) in
////            self.resultView.removeFromSuperview()
//            self.v_bottom.magicView.removeFromSuperview()
//        }
    }
}



/**********************搜索结果的searchView********************************/

protocol SearchResultViewDelegate:class{
    func goodsItemClick(model:WOWGoodsModel)
}

class  SearchResultView:UIView{
    
    var dataArr = [WOWProductModel](){
        didSet{
            collectionView.reloadData()
        }
    }

    weak var delegate:SearchResultViewDelegate?
    
//MARK:Lazy
    lazy var layout:CollectionViewWaterfallLayout = {
        let l = CollectionViewWaterfallLayout()
        l.columnCount = 2
        l.sectionInset = UIEdgeInsetsMake(1, 0, 1, 0)
        l.minimumColumnSpacing = 1
        l.minimumInteritemSpacing = 1
        return l
    }()
    
    private lazy var collectionView:UICollectionView = {
        let collectionView = UICollectionView.init(frame:CGRectMake(0, 45,MGScreenWidth,MGScreenHeight - 64 - 45), collectionViewLayout:self.layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerNib(UINib.nibName(String(WOWGoodsSmallCell)), forCellWithReuseIdentifier:"WOWGoodsSmallCell")
        return collectionView
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configSubview()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configSubview(){
        backgroundColor = UIColor.whiteColor()
        configMenuView()
//        self.addSubview(collectionView)
    }
    
    private func configMenuView(){
        
    }

}


extension SearchResultView:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WOWGoodsSmallCell", forIndexPath: indexPath) as! WOWGoodsSmallCell
            cell.showData(dataArr[indexPath.item],indexPath: indexPath)
            return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let _ = self.delegate {
           
        }
    }
}

extension SearchResultView:CollectionViewWaterfallLayoutDelegate{
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(WOWGoodsSmallCell.itemWidth,dataArr[indexPath.item].cellHeight)
    }
}


extension WOWSearchController:VTMagicViewDataSource{
    
    var identifier_magic_view_bar_item : String {
        get {
            return "identifier_magic_view_bar_item"
        }
    }
    var identifier_magic_view_page : String {
        get {
            return "identifier_magic_view_page"
        }
    }
    
    //获取所有菜单名，数组中存放字符串类型对象
    func menuTitlesForMagicView(magicView: VTMagicView) -> [String] {
        return ["上新","销量","价格"]
    }
    func magicView(magicView: VTMagicView, menuItemAtIndex itemIndex: UInt) -> UIButton{
        
        
        let button = magicView .dequeueReusableItemWithIdentifier(self.identifier_magic_view_bar_item)
        
        if ( button == nil) {
            
            let b = TooglePriceBtn(title:"价格\(itemIndex)",frame: CGRectMake(0, 0, self.view.frame.width / 3, 50)) { (asc) in
                print("you clicket status is "  , asc)
            }
            
            if ( itemIndex != 2) {
                b.image_is_show = false
            }else{
                b.image_is_show = true
            }
            return b
            
        }
        
        return button!
    }
    
    func magicView(magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController{
        
        var vc = magicView.dequeueReusablePageWithIdentifier(self.identifier_magic_view_page)
        
        if ((vc == nil)) {
            
            vc = UIStoryboard.initialViewController("Home", identifier:String(WOWSearchChildController)) as! WOWSearchChildController
        }
        
        return vc!;
    }
    func touchClick(btn:UIButton){
        print(btn.state)
    }
}

extension WOWSearchController:VTMagicViewDelegate{
    func magicView(magicView: VTMagicView, viewDidAppear viewController: UIViewController, atPage pageIndex: UInt){
        
        if let b = magicView.menuItemAtIndex(pageIndex) as! TooglePriceBtn? {
            print("  button asc is ", b.asc)
            
        }
        if pageIndex == 0 || pageIndex == 2{
            if let vc = viewController  as? WOWSearchChildController {
                vc.asc = 1
                vc.pageVc = pageIndex.toInt + 1
                vc.seoKey = searchView.searchTextField.text
                vc.dataArr = [WOWProductModel]()
                vc.request()
            }
        }
        
    }
    func magicView(magicView: VTMagicView, didSelectItemAtIndex itemIndex: UInt){
        if let b = magicView.menuItemAtIndex(itemIndex) as! TooglePriceBtn? {
            print("  button asc is ", b.asc)
            if let vc = v_bottom.magicView.viewControllerAtPage(itemIndex) as? WOWSearchChildController {
                if itemIndex == 2 {
                    vc.asc = b.asc
                    
                }else {
                    vc.asc = 1
                }
                vc.pageIndex = 1
                vc.pageVc = itemIndex.toInt + 1
                vc.seoKey = searchView.searchTextField.text
                vc.dataArr = [WOWProductModel]()
                vc.request()
            }

        }
        print("didSelectItemAtIndex:", itemIndex);
        
        
        
    }
    
}

extension WOWSearchChildController {

    
    }









