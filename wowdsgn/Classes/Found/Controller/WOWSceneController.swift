//
//  WOWSceneController.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/2.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
import VTMagic
import RxSwift

class WOWSceneController: VCBaseVCCategoryFound,CollectionViewWaterfallLayoutDelegate,UICollectionViewDataSource {
    var vo_categories                           = WOWNewCategoryModel()
    var categoryArr                             = [WOWSubCategoryModel]()
    var vo_category_top                         = WOWFoundCategoryModel()

    var top_category_image_view:UIImageView!    = UIImageView()
    var v_bottom : VCVTMagic!
    
    var ob_cid : Int                            = 1         //场景或者标签的id
    var category                                = 0         //分类id
    var ob_tab_index                            = Variable(UInt(0))
    var index                                   = 0
    var entrance        = CategoryEntrance.category{
        didSet{
            
            self.currentVCType = entrance
        
        }
        
    }        //页面入口
    var topIsHidden = false

    var selectedCell: WOWGoodsSmallCell!
    func get_category_index() -> Int {
        let indexes     = categoryArr.flatMap { $0.id }
        if let res      = indexes.index(of: ob_cid){
            return res + 1
        }
        return 0
    }
    
    @IBOutlet weak var cv: UICollectionView!
    @IBOutlet weak var cvTop: NSLayoutConstraint!
    @IBOutlet weak var cvHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        self.mj_footer.isHidden = true
        self.cv.allowsMultipleSelection = false
        
        request()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switch entrance {
        case .category:
            MobClick.e(.CategoryDetail)
        case .scene:
            MobClick.e(.Space_Detail_Page)
        case .tag:
            MobClick.e(.Product_Tag_Detail_Page)
        default:
            break
        }
    }
    
    override func setUI()
    {
        super.setUI()
        
        
        //为了在autolayout的视图里获得真的宽度
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        self.view.backgroundColor = UIColor.red
        self.edgesForExtendedLayout = UIRectEdge()
        
        addTopView()
        addBottomProductView()
        // 筛选回调
        screenView.screenAction = {[unowned self] (dic) in
            
            print(dic)
            
            self.getScreenConditions(dicResult: dic as! [String:AnyObject])
            
            self.refreshSubView(self.ob_tab_index.value)
            
        }
        
        
    }
    
    override func request(){
        super.request()
        //区分入口。分类，场景，标签同样页面布局
        switch entrance {
        case .category:
            requestCategory()
        case .scene:
            requestScene()
        case .tag:
            requestTag()
        default:
            break
        }
        
    }
    
    //请求分类数据
    func requestCategory() {
        let cid = self.ob_cid
        
        
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_Category_path_category(categoryId:cid), successClosure: {[weak self] (result, code) in
            
            if let strongSelf = self{
                
                let r                           =  JSON(result)
                let category_paths              =  Mapper<WOWFoundCategoryModel>().mapArray(JSONObject: r["path"].arrayObject ) ?? [WOWFoundCategoryModel]()
                strongSelf.vo_category_top      =  category_paths[0]
                
                let top_category_cid            =  strongSelf.vo_category_top.categoryID ?? 0
                
                var params              = [String: Any]()
                let prats               = ["category"]
                
                params = ["id": top_category_cid, "parts": prats]
                
                WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_ProductCategory(params: params as [String : AnyObject]), successClosure: {[weak self] (result, code) in
                    
                    if let strongSelf = self{
                        
                        let model = Mapper<WOWNewCategoryModel>().map(JSONObject:result)
                        if let model = model {
                            strongSelf.vo_categories = model
                            strongSelf.categoryArr = model.categories ?? [WOWSubCategoryModel]()
                            strongSelf.title                =  model.name
                            if strongSelf.categoryArr.count > 0 {
                                
                                strongSelf.cvHeight.constant = 110
                                strongSelf.view.layoutIfNeeded()
                                strongSelf.top_category_image_view.set_webimage_url(model.background) //设置顶部分类背景图
                                strongSelf.cv.reloadData()
                                strongSelf.cv.selectItem(at: NSIndexPath(item: strongSelf.get_category_index(), section: 0) as IndexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
                             
                            }else {
                                strongSelf.cvHeight.constant = 0
                                strongSelf.view.layoutIfNeeded()
                                strongSelf.cv.reloadData()

                            }
                            
                        }
                        
                        
                    }
                    
                }){ (errorMsg) in
                    WOWHud.showMsgNoNetWrok(message: errorMsg)
                }

                
            }
            
        }){ (errorMsg) in
            WOWHud.showMsgNoNetWrok(message: errorMsg)
        }
        
    }
    
    //请求场景数据
    func requestScene() {
        var params              = [String: Any]()
        let prats               = ["category"]
        
        params = ["id": ob_cid, "parts": prats]
        
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_ProductScene(params: params as [String : AnyObject]), successClosure: {[weak self] (result, code) in
            
            if let strongSelf = self{
                
                let model = Mapper<WOWNewCategoryModel>().map(JSONObject:result)
                if let model = model {
                    strongSelf.vo_categories = model
                    strongSelf.categoryArr = model.categories ?? [WOWSubCategoryModel]()
                    strongSelf.title                =  model.name
                    if strongSelf.categoryArr.count > 0 {
                        strongSelf.cvHeight.constant = 110
                        strongSelf.view.layoutIfNeeded()
                        strongSelf.top_category_image_view.set_webimage_url(model.background) //设置顶部分类背景图
                        strongSelf.cv.reloadData()
                        strongSelf.cv.selectItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.right)
                    }else {
                        strongSelf.cvHeight.constant = 0
                        strongSelf.view.layoutIfNeeded()
                        strongSelf.cv.reloadData()

                    }
                    
                }
                
                
            }
            
        }){ (errorMsg) in
            WOWHud.showMsgNoNetWrok(message: errorMsg)
        }

    }
    
    //请求标签数据
    func requestTag() {
        var params              = [String: Any]()
        let prats               = ["category"]
        
        params = ["id": ob_cid, "parts": prats]
        
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_ProductTag(params: params as [String : AnyObject]), successClosure: {[weak self] (result, code) in
            
            if let strongSelf = self{
                
                let model = Mapper<WOWNewCategoryModel>().map(JSONObject:result)
                if let model = model {
                    strongSelf.vo_categories = model
                    strongSelf.categoryArr = model.categories ?? [WOWSubCategoryModel]()
                    strongSelf.title                =  model.name
                    if strongSelf.categoryArr.count > 0 {
                        strongSelf.cvHeight.constant = 110
                        strongSelf.view.layoutIfNeeded()

                        strongSelf.top_category_image_view.set_webimage_url(model.background) //设置顶部分类背景图
                        strongSelf.cv.reloadData()
                        strongSelf.cv.selectItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.right)
                    }else {
                        strongSelf.cvHeight.constant = 0
                        strongSelf.view.layoutIfNeeded()

                        strongSelf.cv.reloadData()
                    }

                }
                
                
            }
            
        }){ (errorMsg) in
            WOWHud.showMsgNoNetWrok(message: errorMsg)
        }

    }
    

    //顶部view
    func addTopView(){
        cv.delegate     = self
        cv.dataSource   = self
        //not add this where add cell in uicollectionview
        //self.cv.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "reuse_id")
        
        self.cv.backgroundView                      = top_category_image_view
        self.cv.showsHorizontalScrollIndicator      = false
        self.cv.decelerationRate                    = UIScrollViewDecelerationRateFast;
        
        let layout                          = UICollectionViewFlowLayout()
        layout.scrollDirection              = .horizontal
        layout.sectionInset                 = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        layout.minimumLineSpacing           = 15.0
        cv!.collectionViewLayout            = layout
    }
    
    //底部产品模块
    func addBottomProductView(){
        
        v_bottom = VCVTMagic()
        
        v_bottom.magicView.dataSource           = self
        v_bottom.magicView.delegate             = self
        
        v_bottom.magicView.backgroundColor = UIColor.blue
        self.view.insertSubview(v_bottom.magicView, belowSubview: screenBtnimg)
        v_bottom.magicView.snp.makeConstraints { [weak self](make) -> Void in
            if let strongSelf = self {
                make.width.equalTo(strongSelf.view)
                make.top.equalTo(strongSelf.cv.snp.bottom)
                make.bottom.equalTo(strongSelf.view).offset(0)
            }
            
        }
        
        v_bottom.magicView.reloadData(toPage: 0)
        
        refreshSubView(ob_tab_index.value)
    }
    
    //显示顶部视图
    func showBrand() {
        topIsHidden = false
        view.layoutIfNeeded()
        cvTop.constant = 0
        
        UIView.animate(withDuration: 0.3) {[weak self] in
            if let strongSelf = self {
                strongSelf.view.layoutIfNeeded()
            }
        }
    }
    
    //隐藏顶部视图
    func hiddenBrand() {
        topIsHidden = true
        view.layoutIfNeeded()
        cvTop.constant = -110
        
        UIView.animate(withDuration: 0.3) {[weak self] in
            if let strongSelf = self {
                strongSelf.view.layoutIfNeeded()
            }
        }
    }
    
    
    let cell_reuse_id        = "reuse_id"
    let cell_reuse_id_label  = "reuse_id_label"
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func collectionView(_ collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:IndexPath) -> CGSize
    {
        return CGSize(width: 80.w,height: 80.w)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArr.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
        var cell =  UICollectionViewCell()
        
        if ( (indexPath as NSIndexPath).row == 0) {
            
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: cell_reuse_id, for: indexPath)
            if let iv = cell.viewWithTag(2) as? UIImageView ,
                let img = vo_categories.icon {
                iv.set_webimage_url(img)
            }
            
        }else{
            if categoryArr.count > 0 {
                let row  =  categoryArr[(indexPath as NSIndexPath).row - 1]
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: cell_reuse_id_label, for: indexPath)
                if let lv = cell.viewWithTag(1) as? UILabel {
                    lv.font = UIFont.systemFont(ofSize: 13)
                    lv.text =  row.categoryName 
                }
            }
            
        }
        self.updateCellStatus(cell, is_selected: false)
        
        if ( cell.isSelected == true){
            self.updateCellStatus(cell, is_selected: true)
        }
        return cell
    }
    
    // 改变cell的背景颜色
    func updateCellStatus(_ cell:UICollectionViewCell  , is_selected selected:Bool ){
        
        let color_20                    = UIColor.white.withAlphaComponent(0.2)
        let color_100                   = UIColor.white.withAlphaComponent(1.0)
        
        cell.layer.borderWidth          = 0.8
        cell.layer.cornerRadius         = 0.5
        
        if ( selected ){
            cell.backgroundColor        = color_20
            cell.layer.borderColor      = color_100.cgColor
            
        }else{
            cell.backgroundColor        = UIColor.clear
            cell.layer.borderColor      = color_20.cgColor
        }
    }
    
    //取消选中操作
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if  let cell = collectionView.cellForItem(at: indexPath) {
            self.updateCellStatus(cell, is_selected: false)
        }
        
    }
    
    
    //选中时的操作
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if  let cell = collectionView.cellForItem(at: indexPath) {
            self.cv.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
            self.updateCellStatus(cell, is_selected: true)
            cell.isSelected  = true

            if indexPath.row == 0 {
                switch entrance {
                case .category:
                    category = vo_categories.id ?? 0
                    break
                default:
                    category = 0
                    break
                }
                
            }else {
                let row = categoryArr[(indexPath as NSIndexPath).row - 1]
                category = row.id
            }

            refreshSubView(ob_tab_index.value)
            
        }
    }
    
}


extension WOWSceneController:VTMagicViewDataSource{
    
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
    func menuTitles(for magicView: VTMagicView) -> [String] {
        return ["上新","销量","价格"]
    }
    func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton{
        
        let button = magicView .dequeueReusableItem(withIdentifier: self.identifier_magic_view_bar_item)
        
        if ( button == nil) {
            
            let b = TooglePriceBtn(title:"价格\(itemIndex)",frame: CGRect(x: 0, y: 0, width: self.view.frame.width / 3, height: 50)) { (asc) in
                
            }
            b.btnIndex = itemIndex
            
            if ( itemIndex <= 1) {
                b.image_is_show = false
            }else{
                b.image_is_show = true
            }
            return b
        }
        return button!
    }
    
    func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController{
        let vc = magicView.dequeueReusablePage(withIdentifier: self.identifier_magic_view_page)
        if (vc == nil) {
            let vc_me = UIStoryboard.initialViewController("Found", identifier:String(describing: VCCategoryProducts.self)) as! VCCategoryProducts
            return vc_me
        }
        return vc!;
    }
    func touchClick(_ btn:UIButton){
        DLog(btn.state)
    }
}



extension WOWSceneController:VTMagicViewDelegate, WOWBaseProductsControllerDelegate{
    
    func refreshSubView( _ tab_index:UInt )
    {
        DLog("cid \(ob_cid) tab_index \(tab_index)")
        
        if let b    = self.v_bottom.magicView.menuItem(at: tab_index) as! TooglePriceBtn?,
            let vc  = self.v_bottom.magicView.viewController(atPage: tab_index) as? VCCategoryProducts
            
        {
            let query_sortBy       = Int(tab_index) + 1 //从0开始呀这个 viewmagic的 tab_index
            let query_cid          = ob_cid
            let categoryId          = category
            var query_asc          = 0
            if ( tab_index == 2){ //价格的话用他的排序 其他 正常升序
                
                if b.asc {
                    query_asc = 1
                }else {
                    query_asc = 0
                }
                
            }else{
                query_asc          = 0
            }
            
            vc.pageVc        = query_sortBy
            vc.asc           = query_asc
            vc.query_categoryId    = categoryId
            vc.sceneId = query_cid
            vc.entrance = entrance
            
            vc.screenMinPrice     = self.screenMinPrice
            vc.screenMaxPrice     = self.screenMaxPrice
            vc.screenColorArr     = self.screenColorArr
            vc.screenStyleArr     = self.screenStyleArr
            vc.screenScreenArr    = self.screenScreenArr
            vc.pageIndex          = 1 //每次点击都初始化咯
            vc.delegate = self
            vc.request()
            
        }
    }
    
    func magicView(_ magicView: VTMagicView, viewDidAppear viewController: UIViewController, atPage pageIndex: UInt){
        self.ob_tab_index.value = pageIndex
        if abs(index) > 1 {
            refreshSubView(pageIndex)
        }
        
    }
    
    func magicView(_ magicView: VTMagicView, didSelectItemAt itemIndex: UInt){
        index = Int(ob_tab_index.value) - Int(itemIndex)
        self.ob_tab_index.value = itemIndex
        refreshSubView(itemIndex)
    }
    
    func topView(isHidden: Bool) {
        if categoryArr.count > 0 {
            if isHidden {
                if !topIsHidden {
                    hiddenBrand()
                }
                
            }else {
                if topIsHidden {
                    showBrand()
                }
            }
        }
        
    }
}
