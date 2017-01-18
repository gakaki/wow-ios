
import UIKit
import SnapKit
import VTMagic
import RxSwift


class VCCategory:VCBaseVCCategoryFound,CollectionViewWaterfallLayoutDelegate,UICollectionViewDataSource
{
    
    var vo_categories                           = [WOWFoundCategoryModel]()
    var vo_category_top                         = WOWFoundCategoryModel()

    var top_category_image_view:UIImageView!    = UIImageView()
    var v_bottom : VCVTMagic!

    var ob_cid                                  = Variable(10)
    var ob_tab_index                            = Variable(UInt(0))
    var index                                   = 0
    
    var vc : VCCategoryProducts?
    var topIsHidden = false
    
    func get_category_index() -> Int {
        let indexes     = vo_categories.flatMap { $0.categoryID! }
        if let res      = indexes.index(of: ob_cid.value){
            return res
        }
        return 0
    }

    override func request(){
        let cid = self.ob_cid.value
        
        
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_Category_path_category(categoryId:cid), successClosure: {[weak self] (result, code) in
            
            if let strongSelf = self{
                
                let r                           =  JSON(result)
                let category_paths              =  Mapper<WOWFoundCategoryModel>().mapArray(JSONObject: r["path"].arrayObject ) ?? [WOWFoundCategoryModel]()
                strongSelf.vo_category_top      =  category_paths[0]
                
                let top_category_cid            =  strongSelf.vo_category_top.categoryID ?? 0
                strongSelf.title                =  strongSelf.vo_category_top.categoryName ?? ""
                
                
                WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_Category(categoryId:top_category_cid), successClosure: {[weak self] (result, code) in
                    
                    if let strongSelf = self{
                        
                        let r                             =  JSON(result)
                        strongSelf.vo_categories          =  Mapper<WOWFoundCategoryModel>().mapArray(JSONObject: r["categoryList"].arrayObject ) ?? [WOWFoundCategoryModel]()
                        strongSelf.cv.reloadData()
                        
                        if let image_url = r["bgImg"].string {
                            strongSelf.top_category_image_view.set_webimage_url(image_url) //设置顶部分类背景图
                        }
                        
                        strongSelf.cv.selectItem(at: NSIndexPath(item: strongSelf.get_category_index(), section: 0) as IndexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.right)
                    }
                    
                }){ (errorMsg) in
                    DLog(errorMsg)
                }
            
            }
            
        }){ (errorMsg) in
            DLog(errorMsg)
        }

        
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        self.mj_footer.isHidden = true
        self.cv.allowsMultipleSelection = false

        
        
        
        request()
 
//        _ = Observable.combineLatest( ob_cid.asObservable() , ob_tab_index.asObservable() ) {
//            ($0,$1)
//        }
//            .throttle(0.1, scheduler: MainScheduler.instance)
//        .subscribe(onNext: {[weak self]cid,tab_index in
//            if let strongSelf = self {
//                strongSelf.refreshSubView(tab_index)
//
//            }
//        })
        

    }

    @IBOutlet weak var cv: UICollectionView!
    @IBOutlet weak var cvTop: NSLayoutConstraint!
    
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
        
        screenView.screenAction = {[unowned self] (dic) in
            print(dic)
            let dicResult = dic as! [String:AnyObject]
            if dicResult["colorList"] != nil{
                self.screenColorArr  = dicResult["colorList"] as? [String]
            }else{
                self.screenColorArr?.removeAll()
            }
            if dicResult["priceObj"] != nil {
                self.screenPriceArr  = dicResult["priceObj"] as! Dictionary
                self.screenMinPrice = self.screenPriceArr["minPrice"]
                self.screenMaxPrice = self.screenPriceArr["maxPrice"]
            }else{
                self.screenMinPrice = nil
                self.screenMaxPrice = nil
            }
            
            if dicResult["styleList"] != nil{
                self.screenStyleArr  = dicResult["styleList"] as? [String]
            }else{
                self.screenStyleArr?.removeAll()
            }
            
            self.refreshSubView(self.ob_tab_index.value)
        }


    }
    
    func addTopView(){
        cv.delegate = self
        cv.dataSource = self
        //not add this where add cell in uicollectionview
        //self.cv.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "reuse_id")
        
        self.cv.backgroundView = top_category_image_view
        self.cv.showsHorizontalScrollIndicator = false
        self.cv.decelerationRate = UIScrollViewDecelerationRateFast;
        
        let layout                          = UICollectionViewFlowLayout()
        layout.scrollDirection              = .horizontal
        layout.sectionInset                 = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        layout.minimumLineSpacing           = 15.0
        cv!.collectionViewLayout            = layout
    }
    
    func addBottomProductView(){
        
        v_bottom = VCVTMagic()

        v_bottom.magicView.dataSource           = self
        v_bottom.magicView.delegate             = self
        
        v_bottom.magicView.backgroundColor = UIColor.blue
//        v_bottom.magicView.isMenuScrollEnabled    = true
//        v_bottom.magicView.isSwitchAnimated       = true
//        v_bottom.magicView.isScrollEnabled        = true

        
//        self.addChildViewController(v_bottom)
//        self.view.addSubview(v_bottom.magicView)
         self.view.insertSubview(v_bottom.magicView, belowSubview: screenBtnimg)
        v_bottom.magicView.snp.makeConstraints { [weak self](make) -> Void in
            if let strongSelf = self {
                make.width.equalTo(strongSelf.view)
                make.top.equalTo(strongSelf.cv.snp.bottom)
                make.bottom.equalTo(strongSelf.view.snp.bottom)
            }
            
        }
    
        v_bottom.magicView.reloadData(toPage: 0)
        
        refreshSubView(ob_tab_index.value)
    }
    
    
    func showBrand() {
        topIsHidden = false
        view.layoutIfNeeded()
        cvTop.constant = 0
      
        UIView.animate(withDuration: 0.5) {[weak self] in
            if let strongSelf = self {
                strongSelf.view.layoutIfNeeded()
            }
        }
    }
    
    func hiddenBrand() {
        topIsHidden = true
        view.layoutIfNeeded()
        cvTop.constant = -110
        
        UIView.animate(withDuration: 0.5) {[weak self] in
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
        return vo_categories.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let row  =  vo_categories[(indexPath as NSIndexPath).row]
        var cell =  UICollectionViewCell()
        
        if ( (indexPath as NSIndexPath).row == 0) {
            
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: cell_reuse_id, for: indexPath)
            if let iv = cell.viewWithTag(2) as? UIImageView ,
                let img = row.categoryIconSmall {
                iv.set_webimage_url(img)
            }
            
        }else{
            
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: cell_reuse_id_label, for: indexPath)
            if let lv = cell.viewWithTag(1) as? UILabel {
                lv.font = UIFont.systemFont(ofSize: 13)
                lv.text =  row.categoryName ?? ""
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
            let row = vo_categories[(indexPath as NSIndexPath).row]
            cell.isSelected  = true;
            if ( row.categoryID != nil ){
                self.ob_cid.value = row.categoryID!
                refreshSubView(ob_tab_index.value)
            }
        }
    }
    
}


extension VCCategory:VTMagicViewDataSource{
    
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
            let vc_me       = VCCategoryProducts()
            addChildViewController(vc_me)
            return vc_me
        }
        return vc!;
    }
    func touchClick(_ btn:UIButton){
        DLog(btn.state)
    }
}



extension VCCategory:VTMagicViewDelegate, VCCategoryProductsDelegate{
    
    func refreshSubView( _ tab_index:UInt )
    {
        DLog("cid \(ob_cid.value) tab_index \(tab_index)")
        
        if let b    = self.v_bottom.magicView.menuItem(at: tab_index) as! TooglePriceBtn?,
            let vc  = self.v_bottom.magicView.viewController(atPage: tab_index) as? VCCategoryProducts
            
        {
            let query_sortBy       = Int(tab_index) + 1 //从0开始呀这个 viewmagic的 tab_index
            let query_cid          = ob_cid.value
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
            
            vc.query_sortBy        = query_sortBy
            vc.query_asc           = query_asc
            vc.query_categoryId    = query_cid

            
            vc.screenMinPrice     = self.screenMinPrice
            vc.screenMaxPrice     = self.screenMaxPrice
            vc.screenColorArr     = self.screenColorArr
            vc.screenStyleArr     = self.screenStyleArr
        
            vc.pageIndex           = 1 //每次点击都初始化咯
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

    func cvTopView(isHidden: Bool) {
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
