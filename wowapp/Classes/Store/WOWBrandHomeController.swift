//
//  WOWBrandHomeController.swift
//  Wow
//
//  Created by 小黑 on 16/4/11.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

enum brandOrDesignerEntrance {
    case brandEntrance
    case designerEntrance
}

class WOWBrandHomeController: WOWBaseViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var likeButton: UIButton!
    
    var dataArr = [WOWProductModel]()
    var brandID : Int?
    var brandModel : WOWBrandV1Model?
    var designerId : Int?
    var designerModel : WOWDesignerModel?
    var labelHeight : CGFloat?
    let pageSize = 10
    
    var entrance = brandOrDesignerEntrance.brandEntrance
    
    fileprivate var shareBrandImage:UIImage? //供分享使用
    lazy var placeImageView:UIImageView={  //供分享使用
        let image = UIImageView()
        return image
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
        addObserver()
    }
    
    lazy var layout:CollectionViewWaterfallLayout = {
        let l = CollectionViewWaterfallLayout()
        l.columnCount = 2
        l.minimumColumnSpacing = 0
        l.minimumInteritemSpacing = 0
        l.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        l.headerHeight = 355
        return l
    }()

    
    override func setUI() {
        super.setUI()
        self.edgesForExtendedLayout = UIRectEdge()
        configCollectionView()
        collectionView.mj_header = self.mj_header
        collectionView.mj_footer = self.mj_footer
        //判断一下是品牌详情还是设计师详情
        switch entrance {
        case .brandEntrance:
            
            requestBrandDetail()
            if WOWUserManager.loginStatus {
                requestIsFavoriteBrand()
            }
            
        case .designerEntrance:
            
            requestDesignerDetail()
            if WOWUserManager.loginStatus {
                requestIsFavoriteDesigner()
            }
            
        }

    }
    fileprivate func addObserver(){
        /**
         添加通知
         */
        
        NotificationCenter.default.addObserver(self, selector:#selector(refreshData), name:NSNotification.Name(rawValue: WOWRefreshFavoritNotificationKey), object:nil)
        
    }
    func refreshData(_ sender: Notification)  {
        guard (sender.object != nil) else{//
            return
        }
        for a in 0..<dataArr.count{// 遍历数据，拿到productId model 更改favorite 状态
            let model = dataArr[a]
            
            
            if  let send_obj =  sender.object as? [String:AnyObject] {
                
                if model.productId! == send_obj["productId"] as? Int {
                    model.favorite = send_obj["favorite"] as? Bool
                    break
                }
            }
           
        }
        self.collectionView.reloadData()
    }
    func configCollectionView(){
        collectionView.collectionViewLayout = self.layout
        collectionView.register(UINib.nibName(String(describing: WOWGoodsSmallCell.self)), forCellWithReuseIdentifier:String(describing: WOWGoodsSmallCell.self))
//        WOWBorderColor(collectionView)

        collectionView.register(UINib.nibName(String(describing: WOWBrandHeaderView.self)), forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionHeader, withReuseIdentifier: "Header")
    }
    
    func configBrandData(){
        
       placeImageView.kf.setImage(with: URL(string:(brandModel?.image)!), placeholder: nil, options: nil, progressBlock: nil){ [weak self] (image, error, cacheType, imageURL) in
        
            if let strongSelf = self{
                strongSelf.shareBrandImage = image
            }
        }
      
    }
    func configDesignerData(){
        
        placeImageView.kf.setImage(with: URL(string:(designerModel?.designerPhoto)!), placeholder: nil, options: nil, progressBlock: nil){ [weak self] (image, error, cacheType, imageURL) in
            
            if let strongSelf = self{
                strongSelf.shareBrandImage = image
            }
        }
        
        
    }
    
//MARK:Actions
    @IBAction func back(_ sender: UIButton) {
       _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func favoriteButton(_ sender: UIButton) {
        
        guard WOWUserManager.loginStatus else {
            toLoginVC(true)
            return
        }
        switch entrance {
        case .brandEntrance:
          
            requestFavoriteBrand()
            
        case .designerEntrance:
            
            requestFavoriteDesigner()
            
        }

    }
    @IBAction func shareButton(_ sender: UIButton) {
        switch entrance {
        case .brandEntrance:
            
            let shareUrl = WOWShareUrl + "/brand/\(brandID ?? 0)"
            WOWShareManager.share(brandModel?.brandEname, shareText: brandModel?.desc, url:shareUrl,shareImage:shareBrandImage ?? UIImage(named: "me_logo")!)
        case .designerEntrance:
            
            let shareUrl = WOWShareUrl + "/designer/\(designerId ?? 0)"
            WOWShareManager.share(designerModel?.designerName, shareText: designerModel?.designerDesc, url:shareUrl,shareImage:shareBrandImage ?? UIImage(named: "me_logo")!)
            
        }

    }
    
//MARK:Network
    override func request() {
        super.request()
        //判断一下是品牌详情还是设计师详情
        switch entrance {
        case .brandEntrance:
            requestProductBrand()
            
        case .designerEntrance:
            requestProductDesigner()
            
        }

    }
    
    //品牌详情
    func requestBrandDetail() {
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_BrandDetail(brandId: brandID ?? 0), successClosure: {[weak self](result) in
            if let strongSelf = self{
                let json = JSON(result)
                DLog(json)
                strongSelf.brandModel = Mapper<WOWBrandV1Model>().map(JSONObject:result)
                strongSelf.collectionView.reloadData()
                strongSelf.configBrandData()
                strongSelf.endRefresh()
            }
        }) {[weak self](errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }
        
        
    }
    
    //品牌商品列表
    func requestProductBrand() {
//        var params = [String: AnyObject]?()
        let params = ["brandId": brandID ?? 0, "currentPage": pageIndex,"pageSize":pageSize]
       
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_ProductBrand(params: params as [String : AnyObject]?), successClosure: {[weak self](result) in
          
                if let strongSelf = self{
                    
                    strongSelf.endRefresh()
                    
                    let arr = Mapper<WOWProductModel>().mapArray(JSONObject:JSON(result)["productVoList"].arrayObject)
                    
                    if let array = arr{
                        
                        if strongSelf.pageIndex == 1{
                            strongSelf.dataArr = []
                        }
                        strongSelf.dataArr.append(contentsOf: 
                            array)
                        //如果请求的数据条数小于totalPage，说明没有数据了，隐藏mj_footer
                        if array.count < strongSelf.pageSize {
                            strongSelf.collectionView.mj_footer = nil
                            
                        }else {
                            strongSelf.collectionView.mj_footer = strongSelf.mj_footer
                        }
                        
                    }else {
                        if strongSelf.pageIndex == 1{
                            strongSelf.dataArr = []
                        }
                    
                        strongSelf.collectionView.mj_footer = nil
                        
                    }
                    strongSelf.collectionView.reloadData()

            }
            
        }) {[weak self](errorMsg) in
            if let strongSelf = self{
                strongSelf.collectionView.mj_footer = nil
                strongSelf.endRefresh()
            }
        }
    }
    //设计师详情
    func requestDesignerDetail() {
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_DesignerDetail(designerId: designerId ?? 0), successClosure: {[weak self](result) in
            if let strongSelf = self{
                let json = JSON(result)
                DLog(json)
                strongSelf.designerModel = Mapper<WOWDesignerModel>().map(JSONObject:result)
                strongSelf.collectionView.reloadData()
                strongSelf.configDesignerData()
                strongSelf.endRefresh()
            }
        }) {[weak self](errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }
        
       
    }
    //设计师商品列表
    func requestProductDesigner() {
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_productDesigner(designerId: designerId ?? 0, pageSize: pageSize, currentPage: pageIndex), successClosure: {[weak self](result) in
            
            if let strongSelf = self{
                
                strongSelf.endRefresh()
                
                let arr = Mapper<WOWProductModel>().mapArray(JSONObject:JSON(result)["productVoList"].arrayObject)
                
                if let array = arr{
                    
                    if strongSelf.pageIndex == 1{
                        strongSelf.dataArr = []
                    }
                    strongSelf.dataArr.append(contentsOf: array)
                    //如果请求的数据条数小于totalPage，说明没有数据了，隐藏mj_footer
                    if array.count < strongSelf.pageSize {
                        strongSelf.collectionView.mj_footer = nil
                        
                    }else {
                        strongSelf.collectionView.mj_footer = strongSelf.mj_footer
                    }
                    
                }else {
                    if strongSelf.pageIndex == 1{
                        strongSelf.dataArr = []
                    }
                    
                    strongSelf.collectionView.mj_footer = nil
                    
                }
                strongSelf.collectionView.reloadData()
                
            }

        }) {[weak self](errorMsg) in
            if let strongSelf = self{
                strongSelf.collectionView.mj_footer = nil
                strongSelf.endRefresh()
            }
        }
    }
    //用户是否喜欢某品牌
    func requestIsFavoriteBrand() {
        WOWNetManager.sharedManager.requestWithTarget(.api_IsFavoriteBrand(brandId: brandID ?? 0), successClosure: {[weak self] (result) in
            
            
            if let strongSelf = self{
                let favorite = JSON(result)["favorite"].bool
                strongSelf.likeButton.isSelected = favorite ?? false
            }
            
            
            
        }) {(errorMsg) in
            
        }
        
    }
    
    //用户喜欢某个品牌
    func requestFavoriteBrand()  {
        
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_FavoriteBrand(brandId: brandID ?? 0), successClosure: { [weak self](result) in
            if let strongSelf = self{
                strongSelf.likeButton.isSelected = !strongSelf.likeButton.isSelected
                 NotificationCenter.postNotificationNameOnMainThread(WOWRefreshFavoritNotificationKey, object: nil)
            }
        }) { (errorMsg) in
            
            
        }
    }
    //用户是否喜欢某设计师
    func requestIsFavoriteDesigner() {
        WOWNetManager.sharedManager.requestWithTarget(.api_IsFavoriteDesigner(designerId: designerId ?? 0), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                let favorite = JSON(result)["favorite"].bool
                strongSelf.likeButton.isSelected = favorite ?? false
      

            }
        }) {(errorMsg) in
            
        }
        
    }
    
    //用户喜欢某个设计师
    func requestFavoriteDesigner()  {
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_FavoriteDesigner(designerId: designerId ?? 0), successClosure: { [weak self](result) in
            if let strongSelf = self{
                strongSelf.likeButton.isSelected = !strongSelf.likeButton.isSelected
                 NotificationCenter.postNotificationNameOnMainThread(WOWRefreshFavoritNotificationKey, object: nil)
            }
        }) { (errorMsg) in
            
            
        }
    }
    
   
    
}


extension WOWBrandHomeController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WOWGoodsSmallCell.self), for: indexPath) as! WOWGoodsSmallCell
        let model = dataArr[(indexPath as NSIndexPath).row]
        cell.showData(model, indexPath: indexPath)
//        cell.delegate = self

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView: UICollectionReusableView? = nil
        if kind == CollectionViewWaterfallElementKindSectionHeader {
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as? WOWBrandHeaderView
            if let view = headerView {
                //品牌详情
                if let brandModel = brandModel {
                    view.showBrandData(model: brandModel)
                }
                
                //设计师详情
                if let designerModel = designerModel {
                    view.showDesignerData(model: designerModel)
                }
                labelHeight = view.brandDescLabel.getEstimatedHeight()
                
                view.delegate = self
                
                reusableView = view
            }
        }
        return reusableView!
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWProductDetailController())) as! WOWProductDetailController
        let model = dataArr[(indexPath as NSIndexPath).row]
        vc.hideNavigationBar = true
        vc.productId = model.productId ?? 0
        navigationController?.pushViewController(vc, animated: true)
    }
}

//extension WOWBrandHomeController: WOWGoodsSmallCellDelegate {
//    func likeClick(productId: Int) {
//        if WOWUserManager.loginStatus{
////            strongSelf.goUserInfo()
////            requestFavoriteProduct(productId)
//        }else{
//            toLoginVC(true)
//        }
//    }
//}

extension WOWBrandHomeController:CollectionViewWaterfallLayoutDelegate{
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: WOWGoodsSmallCell.itemWidth,height: WOWGoodsSmallCell.itemWidth + 75)
    }
}

extension WOWBrandHomeController: brandHeaderViewDelegate {
    func moreClick(_ sender: UIButton!) {
        print("更多")
        if sender.isSelected {
            layout.headerHeight = 355
            
        }else {
            layout.headerHeight = 355 + Float(labelHeight ?? 0) - 75

        }
        self.collectionView.reloadData()
        sender.isSelected = !sender.isSelected
        
    }
}
//extension WOWBrandHomeController:WOWActionDelegate{
//    func itemAction(tag: Int) {
//        switch tag {
//        case WOWItemActionType.Like.rawValue:
//            DLog("喜欢")
//        case WOWItemActionType.Share.rawValue:
//            WOWShareManager.share(brandModel?.name, shareText:brandModel?.desc, url:brandModel?.url,shareImage:shareBrandImage ?? UIImage(named: "me_logo")!)
//        case WOWItemActionType.Brand.rawValue:
//            let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandDetailController)) as! WOWBrandDetailController
//            vc.brandModel = brandModel!
//            vc.modalTransitionStyle = .CrossDissolve
//            presentViewController(vc, animated: true, completion: nil)
//        default:
//            break
//        }
//    }
//}


    


