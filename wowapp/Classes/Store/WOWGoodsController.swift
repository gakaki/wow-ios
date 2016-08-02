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
    var carButton           : MIBadgeButton!
//    private var showCatIndex :Int = 0
    private var cellShowStyle:GoodsCellStyle = .Small
    
    
    //请求参数 //5是全部
    var categoryID          = "5"
    private var style       = "0"
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        addObserver()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
         menuView.hideMenu()
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
//MARK:Lazy
    lazy var layout:CollectionViewWaterfallLayout = {
        let l = CollectionViewWaterfallLayout()
        l.columnCount = 2
        l.minimumColumnSpacing = 0.5
        l.headerInset = UIEdgeInsetsMake(2, 0, 0, 0)
        l.minimumInteritemSpacing = 0.5
        return l
    }()
    
    private lazy var collectionView:UICollectionView = {
        let collectionView = UICollectionView.init(frame:CGRectMake(0, 44,self.view.w,self.view.h - 55 - 44), collectionViewLayout:self.layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = DefaultBackColor
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
//MARK:Private Method
    
    private func addObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(loginSuccess), name: WOWLoginSuccessNotificationKey, object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateBadge), name: WOWUpdateCarBadgeNotificationKey, object: nil)
    }
    
    func updateBadge(){
        carButton.badgeString = WOWBuyCarMananger.calCarCount()
        
    }
    
     func loginSuccess() {
        request()
    }
    
    override func setUI() {
        super.setUI()
        view.addSubview(collectionView)
        collectionView.registerNib(UINib.nibName(String(WOWGoodsSmallCell)), forCellWithReuseIdentifier: cellSmallId)
        collectionView.mj_header            = self.mj_header
        collectionView.emptyDataSetSource   = self
        collectionView.emptyDataSetDelegate = self

        configNavigation()
        configMenuView()
        configNav()
        updateBadge()
    }
    
    
    
    private func configNav(){
        carButton = MIBadgeButton(type: .System)
        carButton.setImage(UIImage(named: "store_buyCar"), forState: .Normal)
        carButton.sizeToFit()
        carButton.addTarget(self, action:#selector(goCar), forControlEvents:.TouchUpInside)
        let item = UIBarButtonItem(customView: carButton)
        carButton.badgeString = WOWBuyCarMananger.calCarCount()
        navigationItem.rightBarButtonItem = item
    }

    
    lazy var dropMenuView : WOWDropMenuView! = {
        WOWDropMenuSetting.columnTitles = ["新品",""]
        WOWDropMenuSetting.rowTitles = [["新品","销量","价格"],[""]]
        WOWDropMenuSetting.maxShowCellNumber = 5
        WOWDropMenuSetting.cellTextLabelSelectColoror = GrayColorlevel2
        WOWDropMenuSetting.showDuration = 0.2
        WOWDropMenuSetting.cellHeight = 50
        WOWDropMenuSetting.cellSeparatorColor = SeprateColor
        WOWDropMenuSetting.cellSelectionColor = MGRgb(250, g: 250, b: 250)
        let v = WOWDropMenuView(frame:CGRectMake(0,0,self.view.w,44))
        v.delegate = self
        return v
    }()
    
    private func configMenuView(){
        view.addSubview(dropMenuView)
        let model = self.categoryArr[self.categoryIndex]
        let subcats = model.subCats ?? []
        if categoryID == "5" || subcats.isEmpty{ //全部 或子分类为空
            dropMenuView.columItemArr.last?.hidden = true
        }else{
            dropMenuView.columItemArr.last?.hidden = false
            let subTitles = subcats.map({ (subModel) -> String in
                return subModel.subCatName
            })
            dropMenuView.columItemArr.last?.titleButton.setTitle("全部", forState: .Normal)
            WOWDropMenuSetting.rowTitles = [["新品","销量","价格"],subTitles]
            dropMenuView.columnShowingDict[1] = "全部"
        }
        
    }
    
    private func configNavigation(){
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: categoryTitles[categoryIndex], items: categoryTitles,defaultSelectIndex: categoryIndex)
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = UIColor.whiteColor()
        menuView.cellSelectionColor = MGRgb(250, g: 250, b: 250)
        menuView.cellTextLabelColor = UIColor.blackColor()
        menuView.cellSeparatorColor = SeprateColor
        menuView.cellTextLabelFont = Fontlevel001
        menuView.cellTextLabelAlignment = .Left
        menuView.arrowPadding = 8
        menuView.animationDuration = 0.3
        menuView.maskBackgroundColor = UIColor.blackColor()
        menuView.maskBackgroundOpacity = 0.6
        menuView.checkMarkImage = UIImage(named: "duihao")
        menuView.arrowImage = UIImage(named:"nav_arrow")
        menuView.didSelectItemAtIndexHandler = {[weak self](indexPath: Int) -> () in
            if let strongSelf = self{
                strongSelf.dropMenuView.hide()
                strongSelf.categoryIndex = indexPath
                let model = strongSelf.categoryArr[indexPath]
                strongSelf.categoryID = model.categoryID ?? "5"
                let subcats = model.subCats ?? []
                if strongSelf.categoryID == "5" || subcats.isEmpty{
                    strongSelf.dropMenuView.columItemArr.last?.hidden = true
                }else{
                    strongSelf.dropMenuView.columItemArr.last?.hidden = false
                    strongSelf.dropMenuView.columItemArr.last?.titleButton.setTitle("全部", forState: .Normal)
                    strongSelf.dropMenuView.columnShowingDict[1] = "全部"
                }
                
                
                let subTitles = subcats.map({ (subModel) -> String in
                    return subModel.subCatName
                })
                WOWDropMenuSetting.rowTitles =  [
                    ["新品","销量","价格"],
                    subTitles
                ]
                strongSelf.pageIndex = 0
                strongSelf.request()
            }
        }
        self.navigationItem.titleView = menuView
    }
    
    
    
    

    
//MARK:Actions
    func goCar() {
        let nav = UIStoryboard.initialViewController("BuyCar")
        presentViewController(nav, animated: true, completion: nil)
    }

    
//MARK:Private Network
    override func request() {
        let uid = WOWUserManager.userID
        WOWNetManager.sharedManager.requestWithTarget(.Api_ProductList(pageindex: String(pageIndex),categoryID: categoryID,style: style,sort: sort,uid:uid,keyword:""), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                WOWHud.dismiss()
                let totalPage = JSON(result)["total_page"].intValue
                if strongSelf.pageIndex == totalPage - 1 || totalPage == 0{
                    strongSelf.collectionView.mj_footer = nil
                }else{
                    strongSelf.collectionView.mj_footer = strongSelf.mj_footer
                }
                let goodsArr  = JSON(result)["rows"].arrayObject
                if let arr  = goodsArr{
                    if strongSelf.pageIndex == 0{
                        strongSelf.dataArr = []
                    }
                    for item in arr{
                        let model = Mapper<WOWProductModel>().map(item)
                        if let m = model{
                            strongSelf.dataArr.append(m)
                        }
                    }
                    strongSelf.collectionView.reloadData()
                }
            }
            
        }) {[weak self](errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                WOWHud.dismiss()
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
                let model = categoryArr[categoryIndex]
                let subcats = model.subCats ?? []
                categoryID = subcats[x].subCatID
                break
            default:
                break
        }
        pageIndex = 0
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
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellSmallId, forIndexPath: indexPath) as! WOWGoodsSmallCell
            cell.showData(dataArr[indexPath.item],indexPath: indexPath)
            return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let item = dataArr[indexPath.item]
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWGoodsDetailController)) as! WOWGoodsDetailController
        vc.updateBadgeAction = {[weak self] in
            if let strongSelf = self{
                strongSelf.updateBadge()
            }
        }
        vc.hideNavigationBar = true
        vc.productId = item.productId
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WOWGoodsController:CollectionViewWaterfallLayoutDelegate{
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(WOWGoodsSmallCell.itemWidth,WOWGoodsSmallCell.itemWidth + 65)
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
    func productCellAction(tag: Int, model: WOWProductModel,cell:WOWGoodsBigCell) {
        switch tag {
        case WOWItemActionType.Like.rawValue:
            like(model, cell: cell)
        case WOWItemActionType.Share.rawValue:
            share(model,image: cell.bigPictureImageView.image)
        case WOWItemActionType.Brand.rawValue:
            let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandHomeController)) as! WOWBrandHomeController
            vc.hideNavigationBar = true
            vc.brandID = model.brandID
            navigationController?.pushViewController(vc, animated: true)
        default:
            DLog(" ")
        }
    }
    
    private func like(model:WOWProductModel,cell:WOWGoodsBigCell){
        guard WOWUserManager.loginStatus else { //未登录
            goLogin()
            return
        }
        let is_delete = cell.likeButton.selected ? "1":"0"
        let uid       = WOWUserManager.userID
        let thingid   = model.productId ?? ""
        let type      = "1"//1为商品 2为场景
//        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Favotite(product_id: thingid, uid: uid, type: type, is_delete: is_delete, scene_id: ""), successClosure: {[weak self] (result) in
//            if let _ = self{
//                cell.likeButton.selected = !cell.likeButton.selected
//            }
//        }) { (errorMsg) in
//                
//        }
    }
    
    private func share(model:WOWProductModel,image:UIImage?){
        let shareUrl = "http://www.wowdsgn.com/\(model.skuID ?? "").html"
        WOWShareManager.share((model.productName ?? "") + "-尖叫设计", shareText: model.productShortDes, url:shareUrl, shareImage:image ?? UIImage(named: "me_logo")!)
    }
    
    private func goLogin(){
        let vc = UIStoryboard.initialViewController("Login", identifier: "WOWLoginNavController")
        presentViewController(vc, animated: true, completion: nil)
    }
}


