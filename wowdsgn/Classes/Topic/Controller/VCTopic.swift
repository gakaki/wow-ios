
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

class VCTopic:VCBaseNavCart ,UICollectionViewDelegate,UICollectionViewDataSource,CollectionViewWaterfallLayoutDelegate{
    
    weak var selectedCell: WOWGoodsSmallCell!        //转场cell
    
    var vo_products             = [WOWProductModel]()
    let cell_reuse              = "cell_reuse"
    let cell_header_reuse       = "cell_header_reuse"
    var header_height           = Float(440)

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

        if  let send_obj =  sender.object as? [String:AnyObject] {
            vo_products.ergodicArrayWithProductModel(dic: send_obj, successLikeClosure:{[weak self] in
                if let strongSelf = self {
                    strongSelf.cv.reloadData()
//                    strongSelf.collectionView.reloadData()
                }
                
            })
//            vo_products.ergodicArrayWithProductModel(dic: send_obj)
//            self.cv.reloadData()
            
        }

    }

    override func request(){
      
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_Topics(topicId:topic_id), successClosure: {[weak self] (result, code) in
            
            if let strongSelf = self{
                
                let r                                     =  JSON(result)
                strongSelf.vo_topic                       =  Mapper<WOWModelVoTopic>().map(JSONObject: r.object )
                
                WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_Topic_Products(topicId:strongSelf.topic_id), successClosure: {[weak self] (result, code) in
                    if let strongSelf = self{
                        
                        let r                             =  JSON(result)
                        strongSelf.vo_products            =  Mapper<WOWProductModel>().mapArray(JSONObject:r["productList"].arrayObject) ?? [WOWProductModel]()


                        //先这样写吧，动态计算label的高度，更改header的高度
                        strongSelf.header_height = Float(strongSelf.vo_topic?.topicDesc?.heightWithConstrainedWidth(MGScreenWidth - 30, font: UIFont.systemScaleFontSize(14), lineSpace: 1.3) ?? 0) * 1.3 + Float(strongSelf.vo_topic?.topicName?.heightWithConstrainedWidth(MGScreenWidth - 30, font: UIFont.mediumScaleFontSize(20), lineSpace: 1) ?? 0)
                        if strongSelf.vo_topic?.topicDesc == nil || strongSelf.vo_topic?.topicDesc == ""{
                            strongSelf.layout.headerHeight = Float(MGScreenWidth * (2/3)) + 25 + strongSelf.header_height

                        }else {
                            strongSelf.layout.headerHeight = Float(MGScreenWidth * (2/3)) + 55 + strongSelf.header_height

                        }
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
        self.title = "列表专题"
        request()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.delegate = self
    }
    
    lazy var layout:CollectionViewWaterfallLayout = {
        let l = CollectionViewWaterfallLayout()
        l.columnCount = 2
        l.minimumColumnSpacing = 0
        l.minimumInteritemSpacing = 0
        l.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        l.headerHeight = 390
        return l
    }()
    
    func config_collectionView(){

        let cv                              = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cell_reuse)
        cv.delegate                         = self
        cv.dataSource                       = self
        cv.backgroundColor                  = UIColor.white
        
        cv.register(UINib.nibName(String(describing: WOWGoodsSmallCell.self)), forCellWithReuseIdentifier:String(describing: WOWGoodsSmallCell.self))
        cv.register(UINib.nibName(String(describing: WOWTopicHeaderView.self)), forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionHeader, withReuseIdentifier: cell_header_reuse)
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
//        cv.mj_footer                        = self.mj_footer

        self.cv                             = cv
        self.view.addSubview(self.cv)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableView : UICollectionReusableView? = nil
        
        if kind == CollectionViewWaterfallElementKindSectionHeader {
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: cell_header_reuse, for: indexPath) as! WOWTopicHeaderView
            headerView.showData(model: vo_topic)
             
//                header_height = headerView.label_desc.getEstimatedHeight()
//                headerView.label_name.text = "归自然，崇尚原木韵味，外加现代、实用、精美的艺术设计风格，北欧人似乎有着不可替代的天赋归自然，崇尚原木韵味，外加现代、实用、精美的艺术设计风格，北欧人似乎有着不可替代的天赋"

            
            
            reusableView    =  headerView
            
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
                    selectedCell = cell as! WOWGoodsSmallCell
                    VCRedirect.toVCProduct(row.productId, customPop: true)
                }
            }

    }
    
}

extension VCTopic: UINavigationControllerDelegate
{
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        if operation == .push, toVC.className == WOWProductDetailController.className
        {
            return MagicMovePush(selectView: self.selectedCell.pictureImageView)
        }
        else
        {
            return nil
        }
    }
}


