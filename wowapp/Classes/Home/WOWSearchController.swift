//
//  WOWSearchController.swift
//  Wow
//
//  Created by dcpSsss on 16/4/3.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWSearchController: WOWBaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var keyWords = [String]()
    var searchArray = [String]()
//MARK:Life
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
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
        searchView.removeFromSuperview()
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
    
    lazy var resultView : SearchResultView = {
        let v = SearchResultView()
        v.delegate = self
        v.frame = CGRectMake(0, MGScreenHeight,MGScreenWidth,MGScreenHeight - 64)
        return v
    }()
    
    lazy var searchTagView: WOWSearchTagView = {
         let view = NSBundle.mainBundle().loadNibNamed(String(WOWSearchTagView), owner: self, options: nil).last as! WOWSearchTagView
        view.deleteButton.addTarget(self, action: #selector(deleteClick), forControlEvents: UIControlEvents.TouchUpInside)
        return view
    }()
    
   

    
//MARK:Private Method
    override func setUI() {
        navigationController?.navigationBar.addSubview(searchView)
        
        defaultData()
        keyWords = ["本周特价","新年福袋","天天","分享甘甜的难得时光","上帝在细节中","Umbr","充满爱的设计"]
        
        defaultSetup()
       
        searchTagView.frame = CGRectMake(0, 0, MGScreenWidth, MGScreenHeight - 64)
        tableView.tableHeaderView = searchTagView
   
    }
    
    func defaultSetup() {
        searchTagView.hotTagListView.delegate = self
        for key in keyWords {
            searchTagView.hotTagListView.addTag(key)
        }
        searchTagView.hotTagListView.alignment = .Left
        
        searchTagView.historyTagListView.delegate = self
        for key in searchArray {
            searchTagView.historyTagListView.addTag(key)
        }
        searchTagView.historyTagListView.alignment = .Left
       
    }
    
    func defaultData() {
        let sql = "SELECT * FROM t_searchModel order by id desc;"
        
        let resultSet = WOWSearchManager.shareInstance.db.executeQuery(sql, withArgumentsInArray: nil)
        
        while resultSet.next() {
        
            let searchStr = resultSet.stringForColumn("searchStr")
    
            searchArray.append(searchStr)
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


//MARK:Delegate

extension WOWSearchController: TagListViewDelegate {
    func tagPressed(title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
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
//        showResult()
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
//        hideResult()
        
        return true
    }
    
    func showResult() {
        view.addSubview(resultView)
        resultView.hidden = false
        
        UIView.animateWithDuration(0.3) { 
            self.resultView.y = 0
        }
    }
    
    func hideResult()  {
        UIView.animateWithDuration(0.3, animations: { 
            self.resultView.y = MGScreenHeight + 20
        }) { (ret) in
            self.resultView.removeFromSuperview()
        }
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
        self.addSubview(collectionView)
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

















