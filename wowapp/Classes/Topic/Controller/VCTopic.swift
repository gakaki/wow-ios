
import UIKit
import ObjectMapper
import SnapKit

import UIKit

class HairlineView: UIView {
    override func awakeFromNib() {
        guard let backgroundColor = self.backgroundColor?.cgColor else { return }
        self.layer.borderColor = backgroundColor
        self.layer.borderWidth = (1.0 / UIScreen.main.scale) / 2;
        self.backgroundColor = UIColor.clear
    }
}

class VCTopicHeaderView:UICollectionReusableView{
    
    var imageView: UIImageView!
    
    var label_name:UILabel      = {
        let l = UILabel()
        l.textAlignment = .left
//        l.lineBreakMode = .ByWordWrapping
        l.numberOfLines = 0
        l.setLineHeightAndLineBreak(1.05)
        l.font          = UIFont.mediumScaleFontSize(20)
        return l
    }()
    
    var label_desc:UILabel      = {
        let l = UILabel()
        l.textAlignment = .left
        l.lineBreakMode = .byWordWrapping
        l.numberOfLines = 0
        l.textAlignment = .center
        l.setLineHeightAndLineBreak(1.25)
        l.textColor     = UIColor.gray
        l.font          = UIFont.systemScaleFontSize(14)
        return l
    }()
    
    
    var view_line:UIView   = {
        var l = UIView()
        l.layer.borderWidth = 0.25
        l.layer.borderColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.00).cgColor
        return l
    }()
   

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.scaleToFill
        self.addSubview(imageView)
        
        self.addSubview(label_name)
        self.addSubview(label_desc)
        self.addSubview(view_line)

        
        imageView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            
            make.height.equalTo(280)
            make.top.equalTo(self.snp.top)
        }
        
        label_name.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.frame.width * 0.9)
            make.height.equalTo(50)
            make.left.equalTo(imageView.snp.left).offset(20)
            make.top.equalTo(imageView.snp.bottom).offset(10)
        }
        label_desc.snp.makeConstraints { (make) -> Void in
            make.width.equalTo( self.frame.width * 0.7 )
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(label_name.snp.bottom).offset(5)
        }
        
        view_line.snp.makeConstraints { (make) -> Void in
            make.width.equalTo( self.frame.width * 0.35 )
            make.height.equalTo(1)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(label_desc.snp.bottom).offset(15)
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
        addObserver()
        config_collectionView()
        
    }
    override func pullToRefresh() {
        super.pullToRefresh()
         request()
        
    }
    func btnBack(){
        self.navBack()
    }
    fileprivate func addObserver(){
        /**
         添加通知
         */
        
        NotificationCenter.default.addObserver(self, selector:#selector(refreshData), name:NSNotification.Name(rawValue: WOWRefreshFavoritNotificationKey), object:nil)
        
    }
    // 刷新物品的收藏状态与否 传productId 和 favorite状态
    func refreshData(_ sender: Notification)  {
        guard (sender.object != nil) else{//
            return
        }
        for a in 0..<vo_products.count{// 遍历数据，拿到productId model 更改favorite 状态
            let model = vo_products[a]
            
            
            
            if  let send_obj =  sender.object as? [String:AnyObject] {
                
                if model.productId! == send_obj["productId"] as? Int {
                    model.favorite = send_obj["favorite"] as? Bool
                    break
                }
            }
            
            
        }
        self.cv.reloadData()
    }

    override func request(){
      
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_Topics(topicId:topic_id), successClosure: {[weak self] (result) in
            
            if let strongSelf = self{
                
                let r                                     =  JSON(result)
                strongSelf.vo_topic                       =  Mapper<WOWModelVoTopic>().map(JSONObject: r.object )
                
                WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_Topic_Products(topicId:strongSelf.topic_id), successClosure: {[weak self] (result) in
                    if let strongSelf = self{
                        
                        let r                             =  JSON(result)
                        strongSelf.vo_products            =  Mapper<WOWProductModel>().mapArray(JSONObject:r["productList"].arrayObject) ?? [WOWProductModel]()
                        
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
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cell_reuse)
        cv.delegate                         = self
        cv.dataSource                       = self
        cv.backgroundColor                  = UIColor.white
        
        cv.register(UINib.nibName(String(describing: WOWGoodsSmallCell.self)), forCellWithReuseIdentifier:String(describing: WOWGoodsSmallCell.self))
        cv.register(VCTopicHeaderView.self, forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionHeader, withReuseIdentifier: cell_header_reuse)
        
        let bg_view                         = UIView()
        bg_view.backgroundColor             = UIColor.white
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableView : UICollectionReusableView? = nil
        
        if kind == CollectionViewWaterfallElementKindSectionHeader {
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: cell_header_reuse, for: indexPath) as! VCTopicHeaderView
            
            if let pic = self.vo_topic?.topicImg {
                headerView.imageView.set_webimage_url(pic )
                headerView.label_name.text = self.vo_topic?.topicMainTitle
                headerView.label_desc.text = self.vo_topic?.topicDesc
                headerView.label_desc.setLineHeightAndLineBreak(1.5)
//                headerView.label_name.text = "归自然，崇尚原木韵味，外加现代、实用、精美的艺术设计风格，北欧人似乎有着不可替代的天赋归自然，崇尚原木韵味，外加现代、实用、精美的艺术设计风格，北欧人似乎有着不可替代的天赋"

            }
            
            reusableView    =  headerView
            
//            print ( self.vo_topic)
        }
        
        
        return reusableView!
    }
    
    
    func collectionView(_ collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:IndexPath) -> CGSize
    {
        return CGSize(width: WOWGoodsSmallCell.itemWidth,height: WOWGoodsSmallCell.itemWidth + 75)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vo_products.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WOWGoodsSmallCell.self), for: indexPath) as! WOWGoodsSmallCell
        let model = vo_products[(indexPath as NSIndexPath).row]
        cell.showData(model, indexPath: indexPath)
        return cell
        
    }
    
 
    //选中时的操作
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if  let cell = collectionView.cellForItem(at: indexPath) {
                
                self.cv.deselectItem(at: indexPath, animated: false)
                let row = vo_products[(indexPath as NSIndexPath).row]
                cell.isSelected  = false;
                
                if ( row.productId != nil ){
                    toVCProduct(row.productId!)
                }
            }

    }
    
}




