//
//  WOWSearchController.swift
//  Wow
//
//  Created by dcpSsss on 16/4/3.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit
import VTMagic
import RxSwift

class WOWSearchController: WOWBaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var isLoadPrice: Bool = false
    var dataArr = [WOWProductModel]()
    var ob_cid                                  = Variable(10)
    var ob_tab_index                            = Variable(UInt(0))
    
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
        _ = Observable.combineLatest( ob_cid.asObservable() , ob_tab_index.asObservable() ) {
            ($0,$1)
            }.throttle(0.1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { cid,tab_index in
                
                self.refreshSubView(tab_index)
            })

       
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
        view.frame = CGRectMake(9, 6, MGScreenWidth - 18,30)
        view.searchTextField.delegate = self
        view.searchTextField.becomeFirstResponder()
        view.cancelButton.addTarget(self, action:#selector(cancel), forControlEvents:.TouchUpInside)
        return view
    }()
    
    
    lazy var searchTagView: WOWSearchTagView = {
         let view = NSBundle.mainBundle().loadNibNamed(String(WOWSearchTagView), owner: self, options: nil).last as! WOWSearchTagView
        view.deleteButton.addTarget(self, action: #selector(deleteClick), forControlEvents: UIControlEvents.TouchUpInside)
        return view
    }()
    
    lazy var v_bottom: VCVTMagic = {
        let v = VCVTMagic()
        v.magicView.dataSource = self
        v.magicView.delegate = self
        v.magicView.menuScrollEnabled    = true
        v.magicView.switchAnimated       = true
        v.magicView.scrollEnabled        = true
        
        v.magicView.backgroundColor = UIColor.whiteColor()
        self.addChildViewController(v)
        v.magicView.frame = CGRectMake(0, 0,MGScreenWidth,MGScreenHeight - 64)
        v.magicView.hidden = true
        return v
    }()
   
    lazy var emptyView: UIView = {
        let view = NSBundle.mainBundle().loadNibNamed(String(WOWEmptySearchView), owner: self, options: nil).last as! WOWEmptySearchView
        view.frame = CGRectMake(0, 0, MGScreenWidth, MGScreenHeight)
        view.hidden = true
        return view

    }()


//MARK:Private Method
    override func setUI() {
        navigationController?.navigationBar.addSubview(searchView)
        
        defaultData()
        
        defaultSetup()
//        addBottomProductView()
        tableView.tableHeaderView = searchTagView
        self.view.addSubview(emptyView)
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
        
    }
    func defaultData() {
        let sql = "SELECT * FROM t_searchModel order by id desc;"
        WOWSearchManager.shareInstance.dbQueue.inDatabase {[weak self]  (db) in
            if let strongSelf = self {
                let resultSet = db.executeQuery(sql, withArgumentsInArray: nil)
                strongSelf.searchArray = [String]()
                while resultSet.next() {
                    
                    let searchStr = resultSet.stringForColumn("searchStr")
                    
                    strongSelf.searchArray.append(searchStr)
                }
                
                for key in strongSelf.searchArray {
                    strongSelf.searchTagView.historyTagListView.addTag(key)
                }

            }
            
          
        }
        
//        let resultSet = WOWSearchManager.shareInstance.dbQueue.executeQuery(sql, withArgumentsInArray: nil)
        
        
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
        searchTagView.historyTagListView.removeAllTags()
        for key in searchArray {
            searchTagView.historyTagListView.addTag(key)
        }
        WOWSearchManager.shareInstance.insert(searchStr)

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
    
    func requestResult()  {
        WOWNetManager.sharedManager.requestWithTarget(.Api_SearchResult(pageSize: 10, currentPage: pageIndex, sortBy: 1, asc: 1, seoKey: searchView.searchTextField.text ?? ""), successClosure: { [weak self](result) in
            let json = JSON(result)
            DLog(json)
            
            if let strongSelf = self {
                strongSelf.endRefresh()
                
                let arr = Mapper<WOWProductModel>().mapArray(JSON(result)["productVoList"].arrayObject)
                if let array = arr{
                    strongSelf.dataArr = []
                    strongSelf.dataArr = array
                    strongSelf.showResult()
                }else {
                    strongSelf.emptyView.hidden = false
                }
            }
            
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
//                strongSelf.emptyView.hidden = false
            }
            
        }

    }
}
//MARK:Delegate

extension WOWSearchController: TagListViewDelegate {
    func tagPressed(title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        searchView.searchTextField.text = title
        searchView.searchTextField.resignFirstResponder()
        requestResult()
        searchHistory(title)
    }
    
   

}


extension WOWSearchController:UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.text == "" {
            WOWHud.showMsg("请输入搜索关键字")
            return false
        }
        textField.resignFirstResponder()
        requestResult()

        searchHistory(textField.text!)
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
        
        self.view.addSubview(v_bottom.magicView)
        self.navigationShadowImageView?.hidden = true
        v_bottom.magicView.hidden = false
        v_bottom.magicView.reloadDataToPage(0)
    }
    
    func hideResult()  {
        emptyView.hidden = true
        self.navigationShadowImageView?.hidden = false
        v_bottom.magicView.hidden = true
        v_bottom.magicView.clearMemoryCache()
        self.v_bottom.magicView.removeFromSuperview()

    }
}



/**********************搜索结果的searchView********************************/


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
    override func vtm_prepareForReuse() {
        
    }
    //获取所有菜单名，数组中存放字符串类型对象
    func menuTitlesForMagicView(magicView: VTMagicView) -> [String] {
        return ["上新","销量","价格"]
    }
    func magicView(magicView: VTMagicView, menuItemAtIndex itemIndex: UInt) -> UIButton{
        
        
//        let button = magicView .dequeueReusableItemWithIdentifier(self.identifier_magic_view_bar_item)
        
////        if ( button == nil) {
//        
            let b = TooglePriceBtn(title:"价格\(itemIndex)",frame: CGRectMake(0, 0, self.view.frame.width / 3, 50)) { (asc) in
                print("you clicket status is "  , asc)
            }
            b.btnIndex = itemIndex
            if ( itemIndex <= 1) {
                b.image_is_show = false
            }else{
                b.image_is_show = true
            }
            return b
//
////        }
//        
////        return button!
//        let button = magicView .dequeueReusableItemWithIdentifier(self.identifier_magic_view_bar_item)
//        
//        if ( button == nil) {
//            
//            let b = TooglePriceBtn(title:"价格\(itemIndex)",frame: CGRectMake(0, 0, self.view.frame.width / 3, 50)) { (asc) in
//                
//            }
//            b.btnIndex = itemIndex
//            
//            if ( itemIndex <= 1) {
//                b.image_is_show = false
//            }else{
//                b.image_is_show = true
//            }
//            return b
//        }
//        return button!

    }
    
    func magicView(magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController{
        
        let vc = magicView.dequeueReusablePageWithIdentifier(self.identifier_magic_view_page)
        
        if ((vc == nil)) {
            
            let vc_me = UIStoryboard.initialViewController("Home", identifier:String(WOWSearchChildController)) as! WOWSearchChildController
            addChildViewController(vc_me)
            return vc_me
        }
        
        return vc!;
    }
    func touchClick(btn:UIButton){
        DLog(btn.state)
    }
}

extension WOWSearchController:VTMagicViewDelegate{
//    func magicView(magicView: VTMagicView, viewDidAppear viewController: UIViewController, atPage pageIndex: UInt){
//        
//        if let b = magicView.menuItemAtIndex(pageIndex) as! TooglePriceBtn? {
//            print("  button asc is ", b.asc)
//            
//        }
//        if pageIndex == 0 {
//            
//                if let vc = viewController  as? WOWSearchChildController {
//                    vc.dataArr = dataArr
//                    vc.asc = 1
//                    vc.pageVc = pageIndex.toInt + 1
//                    vc.seoKey = searchView.searchTextField.text
//                    vc.collectionView.reloadData()
//                }
//        }
//        
//        if pageIndex == 2{
//            guard isLoadPrice else {
//                if let vc = viewController  as? WOWSearchChildController {
//                    vc.asc = 1
//                    vc.pageVc = pageIndex.toInt + 1
//                    vc.seoKey = searchView.searchTextField.text
//                    vc.dataArr = [WOWProductModel]()
//                    vc.request()
//                }
//                return
//            }
//            
//        }
//        
//    }
//    func magicView(magicView: VTMagicView, didSelectItemAtIndex itemIndex: UInt){
//        if let b = magicView.menuItemAtIndex(itemIndex) as! TooglePriceBtn? ,
//            vc = magicView.viewControllerAtPage(itemIndex) as? WOWSearchChildController{
//            print("  button asc is ", b.asc)
//                if itemIndex == 2 {
//                    vc.asc = b.asc
//                    //价格第一次点击不知道为什么不会进这里
//                    isLoadPrice = true
//                }else {
//                    vc.asc = 1
//                }
//                vc.pageIndex = 1
//                vc.pageVc = itemIndex.toInt + 1
//                vc.seoKey = searchView.searchTextField.text
//                vc.dataArr = [WOWProductModel]()
//                vc.request()
//
//        }        
//        
//        
//    }
    func refreshSubView( tab_index:UInt )
    {
        DLog("cid \(ob_cid.value) tab_index \(tab_index)")
        
        if let b    = self.v_bottom.magicView.menuItemAtIndex(tab_index) as! TooglePriceBtn? ,
            vc  = self.v_bottom.magicView.viewControllerAtPage(tab_index) as? WOWSearchChildController
        {
            let query_sortBy       = Int(tab_index) + 1 //从0开始呀这个 viewmagic的 tab_index
//            let query_cid          = ob_cid.value
            var query_asc          = 1
            if ( tab_index == 2){ //价格的话用他的排序 其他 正常升序
                query_asc          = b.asc
            }else{
                query_asc          = 1
            }
            
            vc.pageVc        = query_sortBy
            vc.asc           = query_asc
            vc.seoKey       = searchView.searchTextField.text
            vc.pageIndex           = 1 //每次点击都初始化咯
            vc.request()
        }
    }
    
    func magicView(magicView: VTMagicView, viewDidAppear viewController: UIViewController, atPage pageIndex: UInt){
        self.ob_tab_index.value = pageIndex
    }
    
    func magicView(magicView: VTMagicView, didSelectItemAtIndex itemIndex: UInt){
        self.ob_tab_index.value = itemIndex
    }
}








