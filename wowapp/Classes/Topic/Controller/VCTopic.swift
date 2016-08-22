
import UIKit
import ObjectMapper
import SnapKit

import UIKit

class HairlineView: UIView {
    override func awakeFromNib() {
        guard let backgroundColor = self.backgroundColor?.CGColor else { return }
        self.layer.borderColor = backgroundColor
        self.layer.borderWidth = (1.0 / UIScreen.mainScreen().scale) / 2;
        self.backgroundColor = UIColor.clearColor()
    }
}

class VCTopicHeaderView:UICollectionReusableView{
    
    var imageView: UIImageView!
    
    var label_name:UILabel      = {
        let l = UILabel()
        l.textAlignment = .Left
//        l.lineBreakMode = .ByWordWrapping
        l.numberOfLines = 0
        l.setLineHeightAndLineBreak(1.05)
        l.font          = UIFont.mediumScaleFontSize(20)
        return l
    }()
    
    var label_desc:UILabel      = {
        let l = UILabel()
        l.textAlignment = .Left
        l.lineBreakMode = .ByWordWrapping
        l.numberOfLines = 0
        l.textAlignment = .Center
        l.setLineHeightAndLineBreak(1.25)
        l.textColor     = UIColor.grayColor()
        l.font          = UIFont.systemScaleFontSize(14)
        return l
    }()
    
    
    var view_line:UIView   = {
        var l = UIView()
        l.layer.borderWidth = 0.25
        l.layer.borderColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.00).CGColor
        return l
    }()
   

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.ScaleToFill
        self.addSubview(imageView)
        
        self.addSubview(label_name)
        self.addSubview(label_desc)
        self.addSubview(view_line)

        
        imageView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            
            make.height.equalTo(280)
            make.top.equalTo(self.snp_top)
        }
        
        label_name.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(self.frame.width * 0.9)
            make.height.equalTo(50)
            make.left.equalTo(imageView.snp_left).offset(20)
            make.top.equalTo(imageView.snp_bottom).offset(10)
        }
        label_desc.snp_makeConstraints { (make) -> Void in
            make.width.equalTo( self.frame.width * 0.7 )
            make.height.equalTo(100)
            make.centerX.equalTo(self.snp_centerX)
            make.top.equalTo(label_name.snp_bottom).offset(5)
        }
        
        view_line.snp_makeConstraints { (make) -> Void in
            make.width.equalTo( self.frame.width * 0.35 )
            make.height.equalTo(1)
            make.centerX.equalTo(self.snp_centerX)
            make.top.equalTo(label_desc.snp_bottom).offset(15)
        }
//        
//                self.bringSubviewToFront(imageView)

    } 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class VCTopic:VCBaseNavCart ,UICollectionViewDelegate,UICollectionViewDataSource,CollectionViewWaterfallLayoutDelegate{
    
    var vo_products             = [WOWProductModel]()
    let cell_reuse              = "cell_reuse"
    let cell_header_reuse       = "cell_header_reuse"
    let header_height           = Float(500)

    var topic_id                = 4
    var vo_topic:WOWModelVoTopic?

    var cv:UICollectionView!
    
    override func setUI()
    {
        super.setUI()
        config_collectionView()
        
    }
    override func pullToRefresh() {
        super.pullToRefresh()
         request()
        
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
//        cv.bounces                          = false
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
                headerView.label_name.text = self.vo_topic?.topicName
                headerView.label_desc.text = self.vo_topic?.topicDesc
                headerView.label_name.text = "归自然，崇尚原木韵味，外加现代、实用、精美的艺术设计风格，北欧人似乎有着不可替代的天赋归自然，崇尚原木韵味，外加现代、实用、精美的艺术设计风格，北欧人似乎有着不可替代的天赋"

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




