
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

    
    func get_category_index() -> Int {
        let indexes     = vo_categories.flatMap { $0.categoryID! }
        if let res      = indexes.index(of: ob_cid.value){
            return res
        }
        return 0
    }

    override func request(){
        let cid = self.ob_cid.value
        
        
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_Category_path_category(categoryId:cid), successClosure: {[weak self] (result) in
            
            if let strongSelf = self{
                
                let r                           =  JSON(result)
                let category_paths              =  Mapper<WOWFoundCategoryModel>().mapArray(JSONObject: r["path"].arrayObject ) ?? [WOWFoundCategoryModel]()
                strongSelf.vo_category_top      =  category_paths[0]
                
                let top_category_cid            =  strongSelf.vo_category_top.categoryID!
                strongSelf.title                =  strongSelf.vo_category_top.categoryName!
                
                
                WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_Category(categoryId:top_category_cid), successClosure: {[weak self] (result) in
                    
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
        
        request()
 
        _ = Observable.combineLatest( ob_cid.asObservable() , ob_tab_index.asObservable() ) {
            ($0,$1)
        }
            .throttle(0.1, scheduler: MainScheduler.instance)
        .subscribe(onNext: {[weak self]cid,tab_index in
            
            self!.refreshSubView(tab_index)
        })
        

    }

    @IBOutlet weak var cv: UICollectionView!
    
    override func setUI()
    {
        super.setUI()
        
        //为了在autolayout的视图里获得真的宽度
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        self.edgesForExtendedLayout = UIRectEdge()
        
        addTopView()
        addBottomProductView()

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
        
        
//        v_bottom.magicView.isMenuScrollEnabled    = true
//        v_bottom.magicView.isSwitchAnimated       = true
//        v_bottom.magicView.isScrollEnabled        = true

        
        self.addChildViewController(v_bottom)
        self.view.addSubview(v_bottom.magicView)
        
        v_bottom.magicView.snp.makeConstraints { [weak self](make) -> Void in
            make.width.equalTo(self!.view)
            make.top.equalTo(self!.cv.snp.bottom)
            make.bottom.equalTo(self!.view.snp.bottomMargin)
        }
        
        v_bottom.magicView.reloadData()
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



extension VCCategory:VTMagicViewDelegate{
    
    func refreshSubView( _ tab_index:UInt )
    {
        DLog("cid \(ob_cid.value) tab_index \(tab_index)")
        
        if let b    = self.v_bottom.magicView.menuItem(at: tab_index) as! TooglePriceBtn? ,
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
            vc.pageIndex           = 1 //每次点击都初始化咯
            vc.request()
        }
    }
    
    func magicView(_ magicView: VTMagicView, viewDidAppear viewController: UIViewController, atPage pageIndex: UInt){
        self.ob_tab_index.value = pageIndex
    }
    
    func magicView(_ magicView: VTMagicView, didSelectItemAt itemIndex: UInt){
        self.ob_tab_index.value = itemIndex
    }
    
}


//MARK: old UICollectionViewDataSource

//
////    MARK:选项卡
//    func addChooseCard(){
//        //内部子标签
//        let btn_titles      = ["上新","销量","价格"]
//
//        for index in 0..<count {
//
//            var button      = UIButton()
//
//            if ( index <= 1) {
//                button.h        = height
//                button.w        = width
//                button.x        = CGFloat(index) * width
//
//            }else{
//
//                let frame       = CGRectMake(
//                    CGFloat(index) * width,
//                    0,
//                    width,
//                    height
//                )
//                button          = TooglePriceBtn(frame: frame) { [weak self] (status) in
//                    if let strongSelf = self {
//                        strongSelf.query_asc = status.rawValue
//                        DLog("you clicket status is \(strongSelf.query_asc)")
//                    }
//
//
//                }
//
//            }
//
//
//            button.tag      = index + 1 // 1 2 3
//
//            button.titleLabel!.font = UIFont.systemFontOfSize(14)
//            button.setTitle(btn_titles[index], forState: .Normal)
//
//            button.setTitleColor(UIColor.grayColor(), forState: .Highlighted)
//            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
//            button.setTitleColor(UIColor.blackColor(), forState: .Selected)
//
//            button.addTarget(self, action: #selector(titlesClick(_:)), forControlEvents: .TouchUpInside)
//
//            btn_choose_view.addSubview(button)
//
//            button.selected     = false
//            button.highlighted  = true
//
//
//            if index == 0 {//默认点击了第一个按钮
//                button.sendActionsForControlEvents(.TouchUpInside)
//            }
//
////
////            if index == 0 {
////                button.selected     = true
////                selectedButton = button
////                //让按钮内部的Label根据文字来计算内容
////                button.titleLabel?.sizeToFit()
////                 self.indicatorView.w         = self.view.w / 3
////                self.indicatorView.centerX   = button.centerX
////
////            }
//        }
//
//        btn_choose_view.addSubview(self.indicatorView)
//
//        //底部的下划线
//        let c  = UIColor(hue:0.00, saturation:0.00, brightness:0.92, alpha:1.00)
//        btn_choose_view.addBottomBorderWithColor(c,width: 0.5)
//
//
//    }
