//
//  WOWGoodsController.swift
//  Wow
//
//  Created by 小黑 on 16/4/8.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

enum GoodsCellStyle {
    case Big,Small
}


class WOWGoodsController: WOWBaseViewController {
    private var cellBigId   = String(WOWGoodsBigCell)
    private var cellSmallId = String(WOWGoodsSmallCell)
    var categoryIndex       : Int = 0
    var categoryTitles      = ["",""]
    var categoryArr         = [WOWCategoryModel]()
    var dataArr             = [WOWProductModel]()
    var menuView            : BTNavigationDropdownMenu!
    var productTypeArr      = [WOWProductStyleModel]()
    private var cellShowStyle:GoodsCellStyle = .Big
    
    //请求参数
    var categoryID          = "5"
    private var style       = "3"
    private var sort        = "new"
    
//MARK:Life
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
         menuView.hideMenu()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
//MARK:Lazy
    lazy var styleButton:UIButton = {
        let b = UIButton(type:.System)
        b.setImage(UIImage(named: "store_style_small")?.imageWithRenderingMode(.AlwaysOriginal), forState:.Normal)
        b.setImage(UIImage(named: "store_style_big")?.imageWithRenderingMode(.AlwaysOriginal), forState:.Selected)
        b.addTarget(self, action:#selector(WOWGoodsController.showStyleChange(_:)), forControlEvents:.TouchUpInside)
        b.tintColor = UIColor.whiteColor()
        b.contentHorizontalAlignment = .Right
        return b
    }()
    
    lazy var layout:CollectionViewWaterfallLayout = {
        let l = CollectionViewWaterfallLayout()
        l.columnCount = 1
        l.sectionInset = UIEdgeInsetsMake(1, 0, 1, 0)
        l.minimumColumnSpacing = 1
        l.minimumInteritemSpacing = 1
        return l
    }()
    
    private lazy var collectionView:UICollectionView = {
        let collectionView = UICollectionView.init(frame:CGRectMake(0, 45,self.view.width,self.view.height - 65), collectionViewLayout:self.layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
//MARK:Private Method
    
    override func setUI() {
        super.setUI()
        view.addSubview(collectionView)
        collectionView.registerNib(UINib.nibName(String(WOWGoodsBigCell)), forCellWithReuseIdentifier: cellBigId)
        collectionView.registerNib(UINib.nibName(String(WOWGoodsSmallCell)), forCellWithReuseIdentifier: cellSmallId)
        collectionView.mj_header            = self.mj_header
        collectionView.mj_footer            = self.mj_footer
        collectionView.emptyDataSetSource   = self
        collectionView.emptyDataSetDelegate = self
        //FIXME:下拉箭头再找下更适合的吧
        configNavigation()
        configMenuView()
    }
    
    private func configProductType(){
        let ret = WOWRealm.objects(WOWProductStyleModel)
        for model in ret {
            productTypeArr.append(model)
        }
    }
    
    private func configMenuView(){
        configProductType()
        let typeTitleArr = productTypeArr.map { (model) -> String in
            return model.styleName ?? ""
        }
        
        WOWDropMenuSetting.columnTitles = ["新品","所有风格"]
        //FIXME:测试数据
        WOWDropMenuSetting.rowTitles =  [
                                            ["新品","销量","价格"],
                                            typeTitleArr
                                        ]
        WOWDropMenuSetting.maxShowCellNumber = 5
        WOWDropMenuSetting.cellTextLabelSelectColoror = GrayColorlevel2
        WOWDropMenuSetting.showDuration = 0.2
        let menuView = WOWDropMenuView(frame:CGRectMake(0,0,MGScreenWidth,44))
        menuView.delegate = self
        menuView.addSubview(styleButton)
        styleButton.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(menuView).offset(0)
            make.width.equalTo(50)
            make.right.equalTo(menuView).offset(-15)
        }
        
        view.addSubview(menuView)
    }
    
    private func configNavigation(){
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: categoryTitles[categoryIndex], items: categoryTitles,defaultSelectIndex: categoryIndex)
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = UIColor.whiteColor()
        menuView.cellSelectionColor = ThemeColor
        menuView.cellTextLabelColor = UIColor.blackColor()
        menuView.cellTextLabelFont = Fontlevel001
        menuView.cellTextLabelAlignment = .Left
        menuView.arrowPadding = 8
        menuView.animationDuration = 0.3
        menuView.maskBackgroundColor = UIColor.blackColor()
        menuView.maskBackgroundOpacity = 0.3
        menuView.cellSeparatorColor = BorderColor
        menuView.checkMarkImage = UIImage(named: "duihao")
        menuView.arrowImage = UIImage(named:"nav_arrow")
        menuView.didSelectItemAtIndexHandler = {[weak self](indexPath: Int) -> () in
            if let strongSelf = self{
                strongSelf.categoryID = strongSelf.categoryArr[indexPath].categoryID
                strongSelf.request()
            }
        }
        self.navigationItem.titleView = menuView
    }
    
    

    
//MARK:Actions
    func showStyleChange(btn:UIButton) {
        btn.selected = !btn.selected
        cellShowStyle = btn.selected ? .Small : .Big
        layout.columnCount = btn.selected ? 2 : 1
        collectionView.reloadData()
    }
    
    
//MARK:Private Network
    override func request() {
        WOWNetManager.sharedManager.requestWithTarget(.Api_ProductList(pageindex: String(pageIndex),categoryID: categoryID,style: style,sort: sort), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                let totalPage = JSON(result)["total_page"].intValue
                if totalPage == strongSelf.pageIndex{
                    strongSelf.collectionView.mj_footer.endRefreshingWithNoMoreData()
                }
                
                let goodsArr  = JSON(result)["rows"].arrayObject
                if let arr  = goodsArr{
                    if strongSelf.pageIndex == 0{
                        strongSelf.dataArr = []
                    }
                    for item in arr{
                        let model = Mapper<WOWProductModel>().map(item)
                        if let m = model{
                            m.calCellHeight()
                            strongSelf.dataArr.append(m)
                        }
                    }
                    strongSelf.collectionView.reloadData()
                }
            }
            
        }) {[weak self](errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }
    }
}




//MARK:Delegate
extension WOWGoodsController:DropMenuViewDelegate{
    func dropMenuClick(column: Int, row: Int) {
        let sorts = ["new","sale","price"]
        switch (column,row) {
            case let (0,x):
                sort = sorts[x]
                break
            case let (1,x):
                let typeModel = productTypeArr[x]
                style = typeModel.styleValue
                break
            default:
                break
        }
        request()
    }
}

extension WOWGoodsController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        switch cellShowStyle {
        case .Big:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellBigId, forIndexPath: indexPath) as! WOWGoodsBigCell
            cell.showData(dataArr[indexPath.item])
            cell.delegate = self
            return cell
            
        case .Small:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellSmallId, forIndexPath: indexPath) as! WOWGoodsSmallCell
            cell.showData(dataArr[indexPath.item])
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWGoodsDetailController)) as! WOWGoodsDetailController
        vc.hideNavigationBar = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WOWGoodsController:CollectionViewWaterfallLayoutDelegate{
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        switch cellShowStyle {
        case .Big:
            return CGSizeMake(MGScreenWidth, MGScreenWidth)
        case .Small:
            return CGSizeMake(WOWGoodsSmallCell.itemWidth,dataArr[indexPath.item].cellHeight)
        }
    }
}


extension WOWGoodsController{
    override  func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "暂无此分类商品"
        let attri = NSAttributedString(string: text, attributes:[NSForegroundColorAttributeName:MGRgb(170, g: 170, b: 170),NSFontAttributeName:UIFont.mediumScaleFontSize(17)])
        return attri
    }
    
    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return -40
    }
    
}


extension WOWGoodsController:ProductCellDelegate{
    func productCellAction(tag: Int, model: WOWProductModel) {
        switch tag {
        case WOWItemActionType.Like.rawValue:
            DLog("喜欢")
        case WOWItemActionType.Share.rawValue:
            DLog("分享")
        case WOWItemActionType.Brand.rawValue:
            let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandHomeController)) as! WOWBrandHomeController
            vc.hideNavigationBar = true
            navigationController?.pushViewController(vc, animated: true)
        default:
            DLog(" ")
        }
    }
}


