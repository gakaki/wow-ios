
import UIKit
import ObjectMapper
import SnapKit

class VCTopicHeaderView:UICollectionReusableView{
    
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.addSubview(imageView)
        
        imageView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(self)
            make.center.equalTo(self)
        }
        //        self.bringSubviewToFront(imageView)

    } 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class VCTopic:VCBaseNavCart ,UICollectionViewDelegate,UICollectionViewDataSource,CollectionViewWaterfallLayoutDelegate{
    
    var vo_products             = [WOWProductModel]()
    let cell_reuse              = "cell_reuse"
    let cell_header_reuse       = "cell_header_reuse"
    let header_height           = Float(280)

    var topic_id                = 1
    var vo_topic:WOWModelVoTopic?

    var cv:UICollectionView!
    
    override func setUI()
    {
        super.setUI()
        config_collectionView()
        
    }
    
    func btnBack(){
        self.navBack()
    }
    
    override func request(){
      
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Topics(topicId:topic_id), successClosure: {[weak self] (result) in
            
            if let strongSelf = self{
                
                let r                                     =  JSON(result)
                strongSelf.vo_topic                       =  Mapper<WOWModelVoTopic>().map( r.object )
                
                WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Topic_Products(topicId:strongSelf.topic_id), successClosure: {[weak self] (result) in
                    if let strongSelf = self{
                        
                        let r                             =  JSON(result)
                        strongSelf.vo_products            =  Mapper<WOWProductModel>().mapArray(r["productList"].arrayObject) ?? [WOWProductModel]()
                        
                        strongSelf.cv.reloadData()
                        strongSelf.endRefresh()
                        
                    }
                    
                }){ (errorMsg) in
                    print(errorMsg)
                    strongSelf.endRefresh()
                }

            }
            
        }){ (errorMsg) in
            print(errorMsg)
            self.endRefresh()
        }
        
        
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
        layout.headerHeight                 = header_height

        let cv                              = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        cv.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cell_reuse)
        cv.delegate                         = self
        cv.dataSource                       = self
        cv.backgroundColor                  = UIColor.whiteColor()
        
        cv.registerNib(UINib.nibName(String(WOWGoodsSmallCell)), forCellWithReuseIdentifier:String(WOWGoodsSmallCell))
        cv.registerClass(VCTopicHeaderView.self, forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionHeader, withReuseIdentifier: cell_header_reuse)
        
        let bg_view                         = UIView()
        bg_view.backgroundColor             = UIColor.whiteColor()
        cv.backgroundView                   = bg_view
        
        cv.delegate                         = self
        cv.dataSource                       = self
        cv.showsHorizontalScrollIndicator   = false
        cv.showsVerticalScrollIndicator     = false
        
        cv.decelerationRate                 = UIScrollViewDecelerationRateFast
        cv.bounces                          = false
        cv.mj_header                        = self.mj_header

        self.cv                             = cv
        self.view.addSubview(self.cv)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
//        return
//    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        var reusableView : UICollectionReusableView? = nil
        
        if kind == CollectionViewWaterfallElementKindSectionHeader {
   
            
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: cell_header_reuse, forIndexPath: indexPath) as! VCTopicHeaderView
            
            if let pic = self.vo_topic?.topicImg {
                headerView.imageView.set_webimage_url(pic )
            }
            
            reusableView    =  headerView
            
//            print ( self.vo_topic)
        }
        
        
        return reusableView!
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
                    toVCProduct(row.productId!)
                }
            }

    }
    
}




