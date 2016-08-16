
import UIKit

class VCTopic:WOWBaseViewController ,UICollectionViewDelegate,UICollectionViewDataSource,CollectionViewWaterfallLayoutDelegate{
    
    var vo_products             = [WOWProductModel]()
    let cell_reuse              = "cell_reuse"
    
    var cv:UICollectionView!
    
    override func setUI()
    {
        super.setUI()
        request()
    }
    
    override func request(){
//        
//        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Category(categoryId:cid), successClosure: {[weak self] (result) in
//            
//            if let strongSelf = self{
//                //                MARK: 对付图片
//                let r                             =  JSON(result)
//                strongSelf.vo_categories          =  Mapper<WOWFoundCategoryModel>().mapArray( r["categoryList"].arrayObject ) ?? [WOWFoundCategoryModel]()
//                strongSelf.cv.reloadData()
//                
//                if let image_url = r["bgImg"].string {
//                    strongSelf.top_category_image_view.set_webimage_url(image_url) //设置顶部分类背景图
//                }
//                //导航默认选中第一个
//                strongSelf.cv.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.Right)
//                
//                
//            }
//            
//        }){ (errorMsg) in
//            print(errorMsg)
//        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        request()
        
    }
    
    func config_collectionView(){
        
        let layout                          = CollectionViewWaterfallLayout()
        layout.columnCount                  = 2
        layout.minimumColumnSpacing         = 0
        layout.minimumInteritemSpacing      = 0
        layout.sectionInset                 = UIEdgeInsetsMake(0, 0, 0, 0)
        
        let cv                              = UICollectionView(frame: UIScreen.mainScreen().bounds, collectionViewLayout: layout)
        cv.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cell_reuse)
        cv.delegate                         = self
        cv.dataSource                       = self
        cv.backgroundColor                  = UIColor.whiteColor()
        
        cv.registerNib(UINib.nibName(String(WOWGoodsSmallCell)), forCellWithReuseIdentifier:String(WOWGoodsSmallCell))
        //        cv.backgroundColor = UIColor(patternImage: UIImage(named: "10")!)
        
        let bg_view                         = UIView()
        bg_view.backgroundColor             = UIColor.whiteColor()
        cv.backgroundView                   = bg_view
        
        cv.delegate                         = self
        cv.dataSource                       = self
        cv.showsHorizontalScrollIndicator   = false
        cv.showsVerticalScrollIndicator     = false
        
        cv.decelerationRate                 = UIScrollViewDecelerationRateFast
        cv.bounces                          = false
        
        self.cv                             = cv
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
    {
            return CGSizeMake(WOWGoodsSmallCell.itemWidth,WOWGoodsSmallCell.itemWidth + 75)

    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vo_products.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(WOWGoodsSmallCell), forIndexPath: indexPath) as! WOWGoodsSmallCell
        let model = vo_products[indexPath.row]
        cell.showData(model, indexPath: indexPath)
        return cell
        
    }
    
    //选中时的操作
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
            if  let cell = collectionView.cellForItemAtIndexPath(indexPath) {
                
                self.cv.deselectItemAtIndexPath(indexPath, animated: false)
                let row = vo_products[indexPath.row]
                cell.selected  = false;
                
                if ( row.productId != nil ){
//                    toVCProduct(row.productId!)
                }
            }

    }
    
//    MARK topbar
    func btnCartTouch(){
        toVCCart()
    }
    func btnBack(){
        self.navBack()
    }
}


