//
//  WOWSearchController.swift
//  Wow
//
//  Created by dcpSsss on 16/4/3.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWSearchController: WOWBaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    let identifier = "WOWTagCollectionViewCell"
    var keyWords = [String]()

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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        searchView.hidden = false
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
        view.frame = CGRectMake(15, 8, MGScreenWidth - 30,30)
//        view.layer.shadowColor = UIColor(white: 0, alpha: 0.5).CGColor
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
    
    lazy var layout: WOWSearchFlowLayout = {
      let layout = WOWSearchFlowLayout()
        layout.estimatedItemSize = CGSizeMake(100, 35)
        layout.sectionInset                 = UIEdgeInsetsMake(15, 15, 0, 15)
        layout.headerReferenceSize = CGSizeMake(MGScreenWidth, 40)
        return layout
    }()

    
//MARK:Private Method
    override func setUI() {
        super.setUI()
        navigationController?.navigationBar.addSubview(searchView)
        navigationItem.leftBarButtonItems = nil
        makeCustomerNavigationItem("", left: true, handler:nil)
        defaultSetup()
        keyWords = ["本周特价","新年福袋","天天","分享甘甜的难得时光","上帝在细节中","Umbr","充满爱的设计"]
    }
    
    func defaultSetup() {

        collectionView.registerNib(UINib.nibName(String(WOWSearchCell)), forCellWithReuseIdentifier:"WOWSearchCell")
        collectionView.collectionViewLayout = layout
        collectionView.registerClass(WOWReuseSectionView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier:"WOWCollectionHeaderCell")
        
    }
    
    
    
//MARK:Actions
    
    func cancel(){
        searchView.searchTextField.resignFirstResponder()
        navigationController?.popViewControllerAnimated(true)
    }
}


//MARK:Delegate
extension WOWSearchController: UICollectionViewDelegate, UICollectionViewDataSource {
    //MARK: - UICollectionView Delegate/Datasource Methods
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(WOWSearchCell), forIndexPath: indexPath) as! WOWSearchCell
        cell.titleLabel.text = keyWords[indexPath.row]
        return cell
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keyWords.count
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var returnView:UICollectionReusableView!
        switch indexPath.section {
        case 0:
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "WOWCollectionHeaderCell", forIndexPath: indexPath) as! WOWReuseSectionView
            view.titleLabel.text = "热门搜索"
            view.clearButton.hidden = true
            returnView = view
        case 1:
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "WOWCollectionHeaderCell", forIndexPath: indexPath) as! WOWReuseSectionView
            view.titleLabel.text = "历史搜索"
            view.clearButton.hidden = false
            view.delegate = self
            returnView = view
        default:
            return returnView
        }
       
        return returnView

    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        DLog(keyWords[indexPath.row])
    }


}

extension WOWSearchController: WOWReuseSectionViewDelegate {
    func clearHistoryClick() {
        DLog("清除历史搜索")
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
        textField.resignFirstResponder()
        showResult()
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        hideResult()
        
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

class  SearchResultView:UIView,DropMenuViewDelegate{
    
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
        WOWDropMenuSetting.columnTitles = ["综合排序","全部风格"]
        WOWDropMenuSetting.rowTitles =  [
            ["综合排序","销量","价格","信誉","性价比吧","口碑吧"],
            ["全部风格","现代简约","中式传统","清新田园","古朴禅意","自然清雅","经典怀旧","LOFT工业风","商务质感","玩味童趣","后现代"]
        ]
        WOWDropMenuSetting.maxShowCellNumber = 4
        WOWDropMenuSetting.cellTextLabelSelectColoror = GrayColorlevel2
        WOWDropMenuSetting.showDuration = 0.2
        let menuView = WOWDropMenuView(frame:CGRectMake(0,0,MGScreenWidth,44))
        menuView.delegate = self
        self.addSubview(menuView)
    }
    
//MARK:Delegate
    func dropMenuClick(column: Int, row: Int) {
        DLog("点击了\(column)列,\(row)行")
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

















