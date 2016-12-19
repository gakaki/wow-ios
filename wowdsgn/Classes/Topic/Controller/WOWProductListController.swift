//
//  WOWProductListController.swift
//  wowdsgn
//
//  Created by 陈旭 on 2016/12/16.
//  Copyright © 2016年 g. All rights reserved.
//
class WOWProductListTopInfo: WOWBaseModel,Mappable {
    
    var id                  : Int?
    var name                : String?
    var image               : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id              <- map["id"]
        name            <- map["name"]
        image           <- map["image"]
        
    }
    
}
import ObjectMapper
import UIKit

class WOWProductListController: VCBaseNavCart {
    
    fileprivate let headerIdentifier = "ProductListHeaderView"
    var vo_topic:WOWProductListTopInfo?
    var topUrl : String?
    var vo_products             = [WOWProductModel]()
    var groupId  : Int!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        request()
    }
    override func request() {
        super.request()
        requestTop()
        requestList()
    }
    func requestTop(){
        
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_ProductGroupTop(groupId: groupId), successClosure: {[weak self] (result, code) in
            
            if let strongSelf = self{
                
                let r                                     =  JSON(result)
                DLog(r)
                strongSelf.vo_topic                       =  Mapper<WOWProductListTopInfo>().map(JSONObject: r.object )

                strongSelf.topUrl = strongSelf.vo_topic?.image
            }
            
        }){ (errorMsg) in
            
            self.endRefresh()
        }
    }
    func requestList(){
        
        let params = ["groupId":groupId , "currentPage": 1, "pageSize": 10]
        
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_ProductGroupList(params: params as [String : AnyObject]), successClosure: {[weak self] (result, code) in
            
            if let strongSelf = self{
                
                let r                             =  JSON(result)
                DLog(r)
                strongSelf.vo_products            =  Mapper<WOWProductModel>().mapArray(JSONObject:r["products"].arrayObject) ?? [WOWProductModel]()
                //先这样写吧，动态计算label的高度，更改header的高度
          
                strongSelf.collectionView.reloadData()
                strongSelf.endRefresh()
                
                
            }
            
        }){ (errorMsg) in
            self.endRefresh()
        }
    }
    override func setUI()
    {
        super.setUI()
        configCollectionView()
        addObserver()
    }
    func configCollectionView()  {
        
        collectionView.delegate     = self
        collectionView.dataSource   = self
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor                  = UIColor.white
        
        collectionView.register(UINib.nibName(String(describing: WOWGoodsSmallCell.self)), forCellWithReuseIdentifier:String(describing: WOWGoodsSmallCell.self))
        
        collectionView.register(ProductListHeaderView.self, forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
    lazy var layout:CollectionViewWaterfallLayout = {
        let l = CollectionViewWaterfallLayout()
        l.columnCount = 2
        l.minimumColumnSpacing = 0
        l.minimumInteritemSpacing = 0
        l.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        l.headerHeight = Float(MGScreenWidth * 0.67)
        return l
    }()
    
    fileprivate func addObserver(){
        /**
         添加通知
         */
        
        NotificationCenter.default.addObserver(self, selector:#selector(refreshData), name:NSNotification.Name(rawValue: WOWRefreshFavoritNotificationKey), object:nil)
        
    }
    // 刷新物品的收藏状态与否 传productId 和 favorite状态
    func refreshData(_ sender: Notification)  {
        
        if  let send_obj =  sender.object as? [String:AnyObject] {
            
            vo_products.ergodicArrayWithProductModel(dic: send_obj)
            self.collectionView.reloadData()
        }
        
    }
    deinit {
         NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: WOWRefreshFavoritNotificationKey), object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
}

extension WOWProductListController:UICollectionViewDelegate,UICollectionViewDataSource,CollectionViewWaterfallLayoutDelegate{
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableView : UICollectionReusableView? = nil
        
        if kind == CollectionViewWaterfallElementKindSectionHeader {
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProductListHeaderView

            headerView.imageView.set_webimage_url(topUrl )
            reusableView    =  headerView
        }
        
        
        return reusableView!
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
    func collectionView(_ collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:IndexPath) -> CGSize
    {
        return CGSize(width: WOWGoodsSmallCell.itemWidth,height: WOWGoodsSmallCell.itemWidth + 75)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if  let cell = collectionView.cellForItem(at: indexPath) {
            
            self.collectionView.deselectItem(at: indexPath, animated: false)
            let model = vo_products[(indexPath as NSIndexPath).row]
            cell.isSelected  = false;
            
            if ( model.productId != nil ){
                toVCProduct(model.productId!)
            }
        }
    }
}

class ProductListHeaderView:UICollectionReusableView{
    
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.scaleToFill
        self.addSubview(imageView)
        
   
        
        imageView.snp.makeConstraints {[weak self] (make) -> Void in
            make.width.equalTo(MGScreenWidth)
            
            make.height.equalTo(MGScreenWidth * 0.67)
            make.top.right.equalTo(self!)
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


