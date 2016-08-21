
import UIKit
import SnapKit
struct Pic {
    
    var id:String = ""
    var name:String = ""
    
}

let kAnimationDuration = 0.25
let kIndicatorViewH: CGFloat = 3     // 首页顶部标签指示条的高度
let kTitlesViewH: CGFloat = 25          // 顶部标题的高度
let kIndicatorViewwRatio:CGFloat = 1.9  // 首页顶部标签指示条的宽度倍


extension UIView {
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.CGColor
        border.frame = CGRectMake(0, 0, self.frame.size.width, width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.CGColor
        border.frame = CGRectMake(self.frame.size.width - width, 0, width, self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.CGColor
        border.frame = CGRectMake(0, self.frame.size.height - width, self.frame.size.width, width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.CGColor
        border.frame = CGRectMake(0, 0, width, self.frame.size.height)
        self.layer.addSublayer(border)
    }
}

class VCCategory:VCBaseVCCategoryFound, UICollectionViewDelegate,UICollectionViewDataSource,CollectionViewWaterfallLayoutDelegate{
    
    var cid:String              = "10" {
        didSet {
            self.reset_fetch_params()
            refresh_view()
        }
    }
    
    var query_asc:Int           = 1 {
        didSet {
            refresh_view()
        }
    }
    
    var query_sortBy:Int        = 1 {
        didSet {
            self.reset_fetch_params()
            refresh_view()
        }
    }
    func reset_fetch_params(){
        self.pageIndex = 1
        self.vo_products = []
//        self.cv_bottom.setContentOffset(CGPointZero, animated: true)
    }
    
    var query_showCount:Int     = 10
    var top_category_image_view:UIImageView = UIImageView()
    
    
    @IBOutlet weak var btn_choose_view: UIView!
    @IBOutlet weak var cv: UICollectionView!
    @IBOutlet weak var cv_bottom: UICollectionView!
    
    var vo_categories           = [WOWFoundCategoryModel]()
    var vo_products             = [WOWProductModel]()
    
    var layout:CollectionViewWaterfallLayout = {
        let l = CollectionViewWaterfallLayout()
        l.columnCount = 2
        l.minimumColumnSpacing = 0
        l.minimumInteritemSpacing = 0
        l.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        return l
    }()

    
    override func setUI()
    {
        super.setUI()
        
        configCollectionView()
        
        
        //为了在autolayout的视图里获得真的宽度
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        self.edgesForExtendedLayout = .None
        
        self.cv.delegate = self
        self.cv.dataSource = self
        //not add this
        //self.cv.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "reuse_id")
        self.cv.backgroundView = top_category_image_view
        self.cv.showsHorizontalScrollIndicator = false
        self.cv.decelerationRate = UIScrollViewDecelerationRateFast;
        
        let layout                          = UICollectionViewFlowLayout()
        layout.scrollDirection              = .Horizontal
        layout.sectionInset                 = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        layout.minimumLineSpacing           = 15.0
        cv!.collectionViewLayout            = layout

        request()
        
        self.addChooseCard()
        
        
    }
    
    
    private func configCollectionView(){
        cv_bottom.collectionViewLayout = self.layout
        cv_bottom.registerNib(UINib.nibName(String(WOWGoodsSmallCell)), forCellWithReuseIdentifier:String(WOWGoodsSmallCell))
        cv_bottom.backgroundColor = UIColor(patternImage: UIImage(named: "10")!)
        
        let bg_view              = UIView()
        bg_view.backgroundColor  = UIColor.whiteColor()
        cv_bottom.backgroundView = bg_view
            
            
        cv_bottom.delegate = self
        cv_bottom.dataSource = self
        cv_bottom.showsHorizontalScrollIndicator = false
        cv_bottom.showsVerticalScrollIndicator  = false

        cv_bottom.decelerationRate = UIScrollViewDecelerationRateFast
        cv_bottom.bounces = false
        
        cv_bottom.mj_footer = self.mj_footer
        self.mj_footer.setTitle("", forState: MJRefreshState.Idle)
//        self.mj_footer.setTitle("", forState: MJRefreshState.Idle)

//        [self.tableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];

    }
    
    override func request(){
        
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Category(categoryId:cid), successClosure: {[weak self] (result) in
            
            if let strongSelf = self{
//                MARK: 对付图片
                let r                             =  JSON(result)
                strongSelf.vo_categories          =  Mapper<WOWFoundCategoryModel>().mapArray( r["categoryList"].arrayObject ) ?? [WOWFoundCategoryModel]()
                strongSelf.cv.reloadData()
                
                if let image_url = r["bgImg"].string {
                    strongSelf.top_category_image_view.set_webimage_url(image_url) //设置顶部分类背景图
                }
                //导航默认选中第一个
                strongSelf.cv.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.Right)

                
            }
            
        }){ (errorMsg) in
            print(errorMsg)
        }

    }
    /// 当前选中的按钮
    weak var selectedButton = UIButton()
    //底部红色指示器
    var indicatorView:UIView = {
        //底部红色指示器
        let v               = UIView()
        v.backgroundColor   = UIColor.blackColor()
        v.h                 = kIndicatorViewH
        let offset          = CGFloat(9)
        v.y                 = kTitlesViewH + offset + kIndicatorViewH
        v.tag               = -1
        
        v.layer.borderWidth   = 0.1
        v.layer.borderColor   = UIColor.blackColor().CGColor
        v.layer.cornerRadius  = 0.1
        
        return v
    }()
    
    
    // 标签
    weak var titlesView = UIView()
    
  
    let cell_reuse_id        = "reuse_id"
    let cell_reuse_id_label  = "reuse_id_label"
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    
    /// 标签上的按钮点击
    func titlesClick(button: UIButton) {
        
        if ( selectedButton == button && button is TooglePriceBtn){
            //价格

            return
        }
        // 修改按钮状态
        selectedButton!.highlighted = true
        selectedButton!.selected = false

        button.highlighted = false
        button.selected = true
        selectedButton = button
        // 让标签执行动画
        UIView.animateWithDuration(kAnimationDuration) {
//            self.indicatorView.w = self.selectedButton!.titleLabel!.w * kIndicatorViewwRatio
            self.indicatorView.w   = self.view.w / 3
            self.indicatorView.centerX = self.selectedButton!.centerX
        }
        
        query_sortBy = button.tag
    }
//    MARK:选项卡
    func addChooseCard(){
        //内部子标签
        let btn_titles      = ["上新","销量","价格"]
        let count           = btn_titles.count
        let width           = btn_choose_view.w / CGFloat(count)
        let height          = btn_choose_view.h
        
        for index in 0..<count {
            
            var button      = UIButton()

            if ( index <= 1) {
                button.h        = height
                button.w        = width
                button.x        = CGFloat(index) * width
              
            }else{
                
                let frame       = CGRectMake(
                    CGFloat(index) * width,
                    0,
                    width,
                    height
                )
                button          = TooglePriceBtn(frame: frame) { (status) in
                    self.query_asc = status.rawValue
                    DLog("you clicket status is \(self.query_asc)")

                }

            }
            
            
            button.tag      = index + 1 // 1 2 3
            
            button.titleLabel!.font = UIFont.systemFontOfSize(14)
            button.setTitle(btn_titles[index], forState: .Normal)
            
            button.setTitleColor(UIColor.grayColor(), forState: .Highlighted)
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.setTitleColor(UIColor.blackColor(), forState: .Selected)
            
            
            button.addTarget(self, action: #selector(titlesClick(_:)), forControlEvents: .TouchUpInside)
            
            btn_choose_view.addSubview(button)
            
            
            
            
            //默认点击了第一个按钮
            if index == 0 {
                button.selected = true
                selectedButton = button
                //让按钮内部的Label根据文字来计算内容
                button.titleLabel?.sizeToFit()
//                self.indicatorView.w         = button.titleLabel!.w * kIndicatorViewwRatio
                self.indicatorView.w         = self.view.w / 3
                self.indicatorView.centerX   = button.centerX
                
            }
        }
        
        btn_choose_view.addSubview(self.indicatorView)

        //底部的下划线
        let c  = UIColor(hue:0.00, saturation:0.00, brightness:0.92, alpha:1.00)
        btn_choose_view.addBottomBorderWithColor(c,width: 0.5)


    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
    {
        if ( collectionView == self.cv_bottom){
            return CGSizeMake(WOWGoodsSmallCell.itemWidth,WOWGoodsSmallCell.itemWidth + 75)
        }else{
            let cellSize:CGSize = CGSizeMake(80,80 )
            return cellSize
        }
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if ( collectionView == cv){
            return vo_categories.count ?? 0
        }
        else{
            return vo_products.count ?? 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if ( collectionView == self.cv ){
            let row  =  vo_categories[indexPath.row]
            var cell =  UICollectionViewCell()
            
            if ( indexPath.row == 0) {
                
                cell = collectionView.dequeueReusableCellWithReuseIdentifier(cell_reuse_id, forIndexPath: indexPath)
                
                if let iv = cell.viewWithTag(2) as? UIImageView {
                    iv.set_webimage_url(row.categoryIconSmall!)
                }
                
                
            }else{
                
                cell = collectionView.dequeueReusableCellWithReuseIdentifier(cell_reuse_id_label, forIndexPath: indexPath)
                
                if let lv = cell.viewWithTag(1) as? UILabel {
                    lv.text =  row.categoryName!
                }
            }
            self.updateCellStatus(cell, is_selected: false)
            
            if ( cell.selected == true){
                self.updateCellStatus(cell, is_selected: true)
            }
            return cell
        }else{
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(WOWGoodsSmallCell), forIndexPath: indexPath) as! WOWGoodsSmallCell
            let model = vo_products[indexPath.row]
            cell.showData(model, indexPath: indexPath)
//            cell.set_sold_out_status()
            return cell

        }
        
    }
    
    // 改变cell的背景颜色
    func updateCellStatus(cell:UICollectionViewCell  , is_selected selected:Bool ){
        
        let color_20                    = UIColor.whiteColor().colorWithAlphaComponent(0.2)
        let color_100                   = UIColor.whiteColor().colorWithAlphaComponent(1.0)
        
        cell.layer.borderWidth          = 0.8
        cell.layer.cornerRadius         = 0.5
        
        if ( selected ){
            cell.backgroundColor        = color_20
            cell.layer.borderColor      = color_100.CGColor

        }else{
            cell.backgroundColor        = UIColor.clearColor()
            cell.layer.borderColor      = color_20.CGColor
        }
        
     
    }
    
    
    //取消选中操作
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        if  let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            self.updateCellStatus(cell, is_selected: false)
        }
        
    }
    
    
    // 1 上方collectionview 触发 , 2 中间选择 tab 触发 3 下方下拉查看触发
    override func refresh_view(){
        
        //                {"asc":1,"currentPage":1,"showCount":10,"sortBy":1,"categoryId":16}
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Product_By_Category(asc: self.query_asc, currentPage: self.pageIndex, showCount: self.query_showCount, sortBy: self.query_sortBy, categoryId: self.cid.toInt()! ), successClosure: {[weak self] (result) in
            
            self!.endRefresh()

            let res                   = JSON(result)
            let data                  = Mapper<WOWProductModel>().mapArray(res["productVoList"].arrayObject) ?? [WOWProductModel]()
            DLog(self!.vo_products.count)

            if ( data.count <= 0 || data.count < self?.query_showCount){
                self!.cv_bottom.mj_footer = nil
            }
            else{
                self!.cv_bottom.mj_footer = self?.mj_footer

            }
            
            self!.vo_products         = [self!.vo_products, data].flatMap { $0 }
            self!.cv_bottom.reloadData()
            
        }){ (errorMsg) in
            print(errorMsg)
            self.endRefresh()
        }

    }
    
    
    //选中时的操作
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //最上面的选择
        if ( collectionView == self.cv ){
            if  let cell = collectionView.cellForItemAtIndexPath(indexPath) {
                self.cv.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .None)
                self.updateCellStatus(cell, is_selected: true)
                let row = vo_categories[indexPath.row]
                cell.selected  = true;
                if ( row.categoryID != nil ){
                    self.cid = "\(row.categoryID!)"
                }
            }
        }else{
            //下方collectionview选择
            if  let cell = collectionView.cellForItemAtIndexPath(indexPath) {

                self.cv_bottom.deselectItemAtIndexPath(indexPath, animated: false)
                let row = vo_products[indexPath.row]
                cell.selected  = false;
                
                if ( row.productId != nil ){
                    toVCProduct(row.productId!)
                }
            }
        }
        
        
        
    }
    

}


