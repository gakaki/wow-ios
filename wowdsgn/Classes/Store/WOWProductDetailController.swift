//
//  WOWProductDetailController.swift
//  wowapp
//
//  Created by 小黑 on 16/6/3.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
import wow_vendor_ui

public func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

public func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class WOWProductDetailController: WOWBaseViewController {
    //Param
    var productId                       : Int?
    var productModel                    : WOWProductModel?
    var productSpecModel                : WOWProductSpecModel?
    var aboutProductArray               = [WOWProductModel]()
    
    var noMoreData                      :Bool = true
    public var numberSections = 0
    let pageSize = 6
    //UI
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var carEntranceButton: MIBadgeButton!
    @IBOutlet weak var bottomView: UIView!
    //是否展开参数
    var isOpenParam: Bool = false
    //是否展开温馨提示
    var isOpenTips: Bool = false
    public var shareProductImage:UIImage? //供分享使用
    lazy var placeImageView:UIImageView={  //供分享使用
        let image = UIImageView()
        return image
    }()
    
        override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    deinit {
        removeObservers()
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
        addObservers()
        

      }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

//MARK:Lazy
    var cycleView:CyclePictureView! = {
        let v = CyclePictureView(frame:MGFrame(0, y: 0, width:MGScreenWidth, height:MGScreenWidth), imageURLArray: nil)
        v.placeholderImage = UIImage(named: "placeholder_product")
        v.currentDotColor = UIColor.black
        v.otherDotColor   = UIColor(hexString: "#000000", alpha: 0.2)!
        v.timeInterval = 3
        return v
    }()
    lazy var backView:WOWBuyBackView = {
        let v = WOWBuyBackView(frame:CGRect(x: 0,y: 0,width: self.view.w,height: self.view.h))
        v.buyView.delegate = self
        return v
    }()
    //产品描述
    lazy var productDescView:WOWProductDescView = {
        let v = Bundle.main.loadNibNamed(String(describing: WOWProductDescView.self), owner: self, options: nil)?.last as! WOWProductDescView
        return v
    }()
    //产品参数
    lazy var paramView:WOWProductHeaderView = {
        let v = Bundle.main.loadNibNamed(String(describing: WOWProductHeaderView.self), owner: self, options: nil)?.last as! WOWProductHeaderView
        return v
    }()
    //温馨提示
    lazy var tipsView:WOWProductHeaderView = {
        let v = Bundle.main.loadNibNamed(String(describing: WOWProductHeaderView.self), owner: self, options: nil)?.last as! WOWProductHeaderView
        v.lineView.isHidden = false
        return v
    }()

//MARK:Private Method
    override func setUI() {
        super.setUI()
        configTable()
//        buyCarCount()
    }

    fileprivate func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(loginSucces), name: NSNotification.Name(rawValue: WOWLoginSuccessNotificationKey), object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(buyCarCount), name:NSNotification.Name(rawValue: WOWUpdateCarBadgeNotificationKey), object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(refreshData), name:NSNotification.Name(rawValue: WOWRefreshFavoritNotificationKey), object:nil)
    }
    // 刷新物品的收藏状态与否 传productId 和 favorite状态
    func refreshData(_ sender: Notification)  {
        guard (sender.object != nil) else{//
            return
        }
        for a in 0..<aboutProductArray.count{// 遍历数据，拿到productId model 更改favorite 状态
            let model = aboutProductArray[a]
            
            if  let send_obj =  sender.object as? [String:AnyObject] {
                
                if model.productId! == send_obj["productId"] as? Int {
                    model.favorite = send_obj["favorite"] as? Bool
                    break
                }
            }
            
        }
        self.tableView.reloadData()
    }

    fileprivate func removeObservers() {
         NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: WOWLoginSuccessNotificationKey), object: nil)
         NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: WOWUpdateCarBadgeNotificationKey), object: nil)
    }
    
    /**
     购物车数量显示
     */
    func buyCarCount()  {
        if WOWUserManager.userCarCount <= 0 {
            carEntranceButton.badgeString = ""
        }else if WOWUserManager.userCarCount > 0 && WOWUserManager.userCarCount <= 99{
            carEntranceButton.badgeString = "\(WOWUserManager.userCarCount)"
        }else {
            carEntranceButton.badgeString = "99+"
        }
        

    }

    //初始化数据，商品banner
    fileprivate func configData(){
        //如果相关商品有数据显示。如果没有数据则不显示
        if aboutProductArray.count > 0 {
            //详情页共分为7组数据
            numberSections = 7
        }else {
            numberSections = 6
        }
        
        //产品描述说明
        productDescView.productDescLabel.text = productModel?.detailDescription
        productDescView.productDescLabel.setLineHeightAndLineBreak(1.5)
        //banner轮播
        
        if let array = productModel?.primaryImgs {
            if array.count >= 1 {
                cycleView.imageURLArray = productModel?.primaryImgs ?? [""]
                cycleView.delegate = self
                placeImageView.kf.setImage(
                    with: URL(string:array[0] )!,
                    placeholder: nil,
                    options: nil,
                    progressBlock: { (arg1, arg2) in
                    
                    
                    },
                    completionHandler: { [weak self](image, error, cacheType, imageUrl) in
                        if let strongSelf = self{
                            strongSelf.shareProductImage = image
                        }
                    }
                )
               
            }
            

        }
        
    }

    
//MARK:Actions
    //MARK:更新角标
    func updateCarBadge(_ carCount: Int){
        WOWUserManager.userCarCount += carCount
//        buyCarCount()
        NotificationCenter.postNotificationNameOnMainThread(WOWUpdateCarBadgeNotificationKey, object: nil)

    }
    //MARK:购物车
    @IBAction func carEntranceButton(_ sender: UIButton) {
        //判断下是否在登录状态
        guard WOWUserManager.loginStatus else {
            toLoginVC(true)
            return
        }
        let vc = UIStoryboard.initialViewController("BuyCar", identifier:String(describing: WOWBuyCarController.self)) as! WOWBuyCarController
        vc.hideNavigationBar = false
        navigationController?.pushViewController(vc, animated: true)

    }
    
    //MARK:登录成功回调
    func loginSucces(){
        DLog("登录成功")
        requestFavoriteProduct()
    }
    
    //MARK:立即购买
    @IBAction func buyClick(_ sender: UIButton) {
        guard WOWUserManager.loginStatus else{
            toLoginVC(true)
            return
        }
        chooseStyle(carEntrance.payEntrance)
    }
    
    //MARK:放入购物车
    @IBAction func addCarClick(_ sender: UIButton) {
        guard WOWUserManager.loginStatus else{
            toLoginVC(true)
            return
        }
        chooseStyle(carEntrance.addEntrance)
    }
    
    //MARK:分享
    @IBAction func shareClick(_ sender: UIButton) {
        let shareUrl = WOWShareUrl + "/item/\(productModel?.productId ?? 0)"
        WOWShareManager.share(productModel?.productName, shareText: productModel?.sellingPoint, url:shareUrl,shareImage:shareProductImage ?? UIImage(named: "me_logo")!)
    }
    
    //MARK:喜欢
    @IBAction func likeClick(_ sender: UIButton) {
        if !WOWUserManager.loginStatus {
            toLoginVC(true)
        }else{
           requestFavoriteProduct()
        }
        
    }

    //MARK:选择规格,有两种视图
    func chooseStyle(_ entrue: carEntrance) {
        WOWBuyCarMananger.sharedBuyCar.productSpecModel      = self.productSpecModel
        if let product = productModel {
            if product.primaryImgs?.count > 0 {
                WOWBuyCarMananger.sharedBuyCar.defaultImg = product.primaryImgs![0]
            }
            
            let result = WOWCalPrice.calTotalPrice([product.sellPrice ?? 0],counts:[1])

            WOWBuyCarMananger.sharedBuyCar.defaultPrice = result

        }
        view.addSubview(backView)
        view.bringSubview(toFront: backView)
        backView.show(entrue)
    }
    
    @IBAction func backClick(_ sender: UIButton) {
       _ = navigationController?.popViewController(animated: true)
    }
    
//MARK:Private Network
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(.api_ProductDetail(productId: productId ?? 0), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                strongSelf.productModel = Mapper<WOWProductModel>().map(JSONObject:result)
                strongSelf.productModel?.productId = strongSelf.productId
                
                strongSelf.requestAboutProduct()
                strongSelf.buyCarCount()
                
                //Talking Data order detail 浏览商品 商品详情
                var price:Int32     =  Int32(strongSelf.productModel?.sellPrice ?? 0)
                price               =  Int32(price) * 100
                let id              =  String(describing:(strongSelf.productId ?? 0)!)
                let name            =  strongSelf.productModel?.productName
                TalkingDataAppCpa.onViewItem(withCategory: "", itemId: id, name: name, unitPrice:price)
  
                

            }
        }) {[weak self](errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }
        
        requestProductSpec()
        
        //如果是登录状态的时候才请求是否喜欢单品的接口
        if WOWUserManager.loginStatus {
            requestIsFavoriteProduct()
        }
        
    }
    //产品参数
    func requestProductSpec() -> Void {
        WOWNetManager.sharedManager.requestWithTarget(.api_ProductSpec(productId: productId ?? 0), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                strongSelf.productSpecModel = Mapper<WOWProductSpecModel>().map(JSONObject:result)
                DLog(strongSelf.productSpecModel)
                
            }
        }) {(errorMsg) in
           
        }

    }
    
//    用户是否喜欢单品
    func requestIsFavoriteProduct() -> Void {
        WOWNetManager.sharedManager.requestWithTarget(.api_IsFavoriteProduct(productId: productId ?? 0), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                let favorite = JSON(result)["favorite"].bool
                strongSelf.likeButton.isSelected = favorite ?? false
            }
        }) {(errorMsg) in
            
        }
        
    }
    
    //用户喜欢某个单品
    func requestFavoriteProduct()  {
        
            WOWHud.showLoadingSV()
        WOWClickLikeAction.requestFavoriteProduct(productId: productId ?? 0,view:bottomView,btn:likeButton, isFavorite: { [weak self](isFavorite) in
            if let strongSelf = self{
                
               strongSelf.likeButton.isSelected = isFavorite ?? false
            }
            })

        
        
//        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_FavoriteProduct(productId:productId ?? 0), successClosure: { [weak self](result) in
//            if let strongSelf = self{
//                let favorite = JSON(result)["favorite"].bool
//                strongSelf.likeButton.selected = favorite ?? false
//
//                var params = [String: AnyObject]?()
//                
//                params = ["productId": strongSelf.productId!, "favorite": favorite!]
//                
//                NSNotificationCenter.postNotificationNameOnMainThread(WOWRefreshFavoritNotificationKey, object: params)
////                 NSNotificationCenter.postNotificationNameOnMainThread(WOWRefreshFavoritNotificationKey, object: nil)
//            }
//            }) { (errorMsg) in
//                
//        
//        }
    }
    
    // 相关商品信息
    func requestAboutProduct()  {
        let params = ["brandId": productModel?.brandId ?? 0, "currentPage": pageIndex,"pageSize":pageSize, "excludes": [productModel?.productId ?? 0]] as [String : Any]
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_ProductBrand(params: params as [String : AnyObject]?), successClosure: {[weak self] (result) in
            
            if let strongSelf = self {
                let arr = Mapper<WOWProductModel>().mapArray(JSONObject:JSON(result)["productVoList"].arrayObject)
                
                if let array = arr{
                    strongSelf.aboutProductArray = array
                    
                }
                //初始化详情页数据
                strongSelf.configData()
                strongSelf.tableView.reloadData()
                strongSelf.endRefresh()
            }

            
        }) {[weak self] (errorMsg) in
            
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }
    }
   
    
    
}

extension WOWProductDetailController :goodsBuyViewDelegate {
    //确定购买
    func sureBuyClick(_ product: WOWProductInfoModel?) {
        backView.hideBuyView()
        let sv = UIStoryboard.initialViewController("BuyCar", identifier:"WOWEditOrderController") as!WOWEditOrderController
        //入口
        sv.entrance = editOrderEntrance.buyEntrance
        sv.productId = product?.subProductId
        sv.productQty = product?.productQty
        navigationController?.pushViewController(sv, animated: true)

    }
    //确定加车
    func sureAddCarClick(_ product: WOWProductInfoModel?) {
        backView.hideBuyView()
        if let product = product {
            
            var c = product.productQty ?? 1

            WOWNetManager.sharedManager.requestWithTarget(.api_CartAdd(productId:product.subProductId ?? 0, productQty:c), successClosure: {[weak self] (result) in
                if let strongSelf = self {
                    strongSelf.updateCarBadge(product.productQty ?? 1)
                }
                
                //查看购物车
                let id      = String(describing:product.subProductId)
                let price   = Int32(product.sellPrice ?? 0) * 100
                let name    = product.productName ?? ""
                let shoppingCart = TDShoppingCart.create()
                
                shoppingCart?.addItem(withCategory: "", itemId: id, name: "", unitPrice: price, amount: Int32(c))
                TalkingDataAppCpa.onViewShoppingCart(shoppingCart)
               
                
                TalkingDataAppCpa.onAddItemToShoppingCart(withCategory: "", itemId: id, name: name, unitPrice: price, amount:  Int32(c))

                
            }) { (errorMsg) in
                
            }
            
        }else {
            WOWHud.showMsg("添加购物车失败")
        }

    }
   
}

extension WOWProductDetailController : CyclePictureViewDelegate {
    func cyclePictureView(_ cyclePictureView: CyclePictureView, didSelectItemAtIndexPath indexPath: IndexPath) {
        func setPhoto() -> [PhotoModel] {
            var photos: [PhotoModel] = []
            for (_, photoURLString) in (productModel?.primaryImgs ?? [""]).enumerated() {
                // 这个方法只能返回可见的cell, 如果不可见, 返回值为nil
//                let cell = cyclePictureView.collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as? CyclePictureCell
                
//                let sourceView = cell?.imageView
                
                let photoModel = PhotoModel(imageUrlString: photoURLString, sourceImageView: nil)
                photos.append(photoModel)
            }
            return photos
        }
        
        let photoBrowser = PhotoBrowser(photoModels: setPhoto()) {[weak self] (extraBtn) in
            if let sSelf = self {
                let hud = SimpleHUD(frame:CGRect(x: 0.0, y: (sSelf.view.zj_height - 80)*0.5, width: sSelf.view.zj_width, height: 80.0))
                sSelf.view.addSubview(hud)
            }
            
        }
        // 指定代理
        
        photoBrowser.show(inVc: self, beginPage: (indexPath as NSIndexPath).row)
    }
}



