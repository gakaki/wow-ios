
import UIKit
import SnapKit


let kAnimationDuration = 0.25
let kIndicatorViewH: CGFloat = 3     // 首页顶部标签指示条的高度
let kTitlesViewH: CGFloat = 25          // 顶部标题的高度
let kIndicatorViewwRatio:CGFloat = 1.9  // 首页顶部标签指示条的宽度倍



class VCCategory:VCBaseVCCategoryFound,CollectionViewWaterfallLayoutDelegate,UICollectionViewDataSource
{
    var vo_categories           = [WOWFoundCategoryModel]()
    var top_category_image_view:UIImageView! = UIImageView()
    
    var cid:String              = "10" {
        didSet {
//            self.reset_fetch_params()
            refresh_view()
        }
    }
//
//    var query_asc:Int           = 1 {
//        didSet {
//            self.reset_fetch_params()
//            refresh_view()
//        }
//    }
//    
//    var query_sortBy:Int        = 1 {
//        didSet {
//            self.reset_fetch_params()
//            refresh_view()
//        }
//    }
//       var query_showCount:Int     = 10
    
    
    @IBOutlet weak var cv: UICollectionView!
    
    override func setUI()
    {
        super.setUI()
        
        //为了在autolayout的视图里获得真的宽度
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        self.edgesForExtendedLayout = .None
        
        cv.delegate = self
        cv.dataSource = self
        
        //not add this where add cell in uicollectionview
        //self.cv.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "reuse_id")
        
        self.cv.backgroundView = top_category_image_view
        self.cv.showsHorizontalScrollIndicator = false
        self.cv.decelerationRate = UIScrollViewDecelerationRateFast;
        
        let layout                          = UICollectionViewFlowLayout()
        layout.scrollDirection              = .Horizontal
        layout.sectionInset                 = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        layout.minimumLineSpacing           = 15.0
        cv!.collectionViewLayout            = layout

        self.addProductPageAndTabBar()
    }
    
    func addProductPageAndTabBar(){
        
        
        
        
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

    let cell_reuse_id        = "reuse_id"
    let cell_reuse_id_label  = "reuse_id_label"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
    {
        return CGSizeMake(80.w,80.w)
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vo_categories.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
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
                lv.font = UIFont.systemFontOfSize(13)
                lv.text =  row.categoryName!
            }
        }
        self.updateCellStatus(cell, is_selected: false)
        
        if ( cell.selected == true){
            self.updateCellStatus(cell, is_selected: true)
        }
        return cell
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
    
    
    //选中时的操作
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if  let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            self.cv.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .None)
            self.updateCellStatus(cell, is_selected: true)
            let row = vo_categories[indexPath.row]
            cell.selected  = true;
            if ( row.categoryID != nil ){
                self.cid = "\(row.categoryID!)"
            }
        }
    }
    

}


