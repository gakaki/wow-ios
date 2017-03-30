
//
//  WOWProductDetailController.swift
//  wowapp
//
//  Created by 小黑 on 16/6/3.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

protocol UpdateBuyCarListDelegate:class {
    func updateBuyCarList()
}

class WOWProductDetailController: WOWBaseViewController {
    
    var selectedView: UIView = UIView()        //转场cell

    fileprivate var percentDrivenTransition: UIPercentDrivenInteractiveTransition?

    weak var delegate:UpdateBuyCarListDelegate?
    
    var isNeedCustomPop                 : Bool = false             //是否需要转场动画
    //Param
    var productId                       : Int?                  //产品id
    var productModel                    : WOWProductModel?      //产品model
    var productSpecModel                : WOWProductSpecModel?  //产品规格model
    var aboutProductArray               = [WOWProductModel]()   //相关商品数组
    //商品促销信息
    var promotionTag                : String?                   //促销tag
    var promotionTime               : String?                   //促销时间
    var commentList = [WOWProductCommentModel]() //评论列表
    
    var noMoreData                      :Bool = true
    fileprivate(set) var numberSections = 0
    var isHaveLimit = 0  //是否有限购
    var isHavePromotion = 0 //是否有促销
    var isHaveComment = 0   //是否有评论
    var isHaveAbout = 0 //是否有相关产品
    let pageSize = 6
    //UI
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var carEntranceButton: MIBadgeButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var productEffectView: UIView!
    @IBOutlet weak var addCartButton: UIButton!
    @IBOutlet weak var nowBuyButton: UIButton!
    @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    @IBOutlet weak var topSpace: NSLayoutConstraint!
    //是否展开参数
    var isOpenParam: Bool = true
    //是否展开温馨提示
    var isOpenTips: Bool = false
    //轮播图数组
    var imgUrlArr = [String]()
//    fileprivate var shareProductImage:UIImage? //供分享使用
//    lazy var placeImageView:UIImageView={  //供分享使用
//        let image = UIImageView()
//        return image
//    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.delegate = self
        showBottom()
    }
    deinit {
        removeObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.e(UMengEvent.Product_Detail)

    }
    
    func showBottom() {
       
        bottomSpace.constant = 0
        topSpace.constant = 0
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            if let strongSelf = self {

                strongSelf.view.layoutIfNeeded()
            }
        }) { (finish) in
            
        }
    }
    func hiddenBottom(progress: CGFloat) {
        UIView.animate(withDuration: 0.01, animations: {[weak self] in
            if let strongSelf = self {
                strongSelf.bottomSpace.constant = -(CGFloat(50.0) * progress)
                strongSelf.topSpace.constant = -(CGFloat(72.0) * progress)

            }
        }) { (finish) in
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
        addObservers()
        if isNeedCustomPop {
            //手势监听器
            let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgePanGesture(_:)))
            edgePan.edges = UIRectEdge.left
            self.view.addGestureRecognizer(edgePan)
        }
       

        
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
    //评价与晒单
    lazy var commentView: WOWCommentHeaderView = {
        let v = Bundle.main.loadNibNamed(String(describing: WOWCommentHeaderView.self), owner: self, options: nil)?.last as! WOWCommentHeaderView
        v.moreCommentClick.addTarget(self, action: #selector(moreCommentClick), for: .touchUpInside)
        return v
    }()
    //相关商品
    lazy var aboutView:WOWAboutHeaderView = {
        let v = Bundle.main.loadNibNamed(String(describing: WOWAboutHeaderView.self), owner: self, options: nil)?.last as! WOWAboutHeaderView
        v.labelText.text = "相关商品"
        return v
    }()
    
    //MARK:Private Method
    override func setUI() {
        super.setUI()
        configTable()
        cycleView.delegate = self
        
        //        buyCarCount()
    }

    fileprivate func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(loginSucces), name: NSNotification.Name(rawValue: WOWLoginSuccessNotificationKey), object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(buyCarCount), name:NSNotification.Name(rawValue: WOWUpdateCarBadgeNotificationKey), object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(refreshData), name:NSNotification.Name(rawValue: WOWRefreshFavoritNotificationKey), object:nil)
    }
    // 刷新物品的收藏状态与否 传productId 和 favorite状态
    func refreshData(_ sender: Notification)  {

        if  let send_obj =  sender.object as? [String:AnyObject] {
            aboutProductArray.ergodicArrayWithProductModel(dic: send_obj, successLikeClosure:{[weak self] in
                if let strongSelf = self {
                    strongSelf.tableView.reloadData()
                    //                    strongSelf.collectionView.reloadData()
                }
                
            })
//            aboutProductArray.ergodicArrayWithProductModel(dic: send_obj)
//             self.tableView.reloadData()
        }

       
    }
    
    fileprivate func removeObservers() {

        
         NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: WOWLoginSuccessNotificationKey), object: nil)
         NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: WOWUpdateCarBadgeNotificationKey), object: nil)
         NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: WOWRefreshFavoritNotificationKey), object: nil)

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
        //如果没有促销标签，则不显示
        isHaveLimit = 0
        isHavePromotion = 0
        productModel?.limitTag = ""
        promotionTag = ""
        promotionTime = ""
        for singModel in productModel?.sings ?? []{
            switch singModel.id ?? 0{
            case 5: //限购相关的信息
                isHaveLimit = 1
                productModel?.limitTag = singModel.desc
            case 6: //促销相关信息
                isHavePromotion = 1
                promotionTag = singModel.desc
                promotionTime = singModel.extra
            default: break
            }
        }
        //如果有评论就显示，没有不显示
        if commentList.count > 0 {
            //商品评论
            isHaveComment = 1
            //如果评论数大于三条显示更多评论
            if commentList.count > 3 {
                commentView.moreCommentClick.isHidden = false
            }else {
                commentView.moreCommentClick.isHidden = true
            }
        }
        //如果相关商品有数据显示。如果没有数据则不显示
        if aboutProductArray.count > 0 {
            //详情页共分为7组数据
            isHaveAbout = 1
        }else {
            isHaveAbout = 0
        }
        //产品参数默认打开
        paramView.isOpen(isOpenParam)
        numberSections = 7 + isHaveLimit + isHavePromotion + isHaveComment + isHaveAbout
        //产品描述说明
        productDescView.productDescLabel.text = productModel?.detailDescription
        productDescView.productDescLabel.setLineHeightAndLineBreak(1.5)
        refreshParameter()
        //banner轮播
        configBanner()
        
        
        
        
    }
    //初始化尺寸。重量
    fileprivate func configParameter() {
        if productModel?.productParameter?.count > 0 {
            let sizeParam = WOWParameter.init(parameterShowName: "尺寸", parameterValue: productSpec.productSize(productInfo: productModel!))
            let netWeightParam = WOWParameter.init(parameterShowName: "重量", parameterValue: productSpec.productWeight(productInfo: productModel!))
            productModel?.productParameter?.insert(sizeParam, at: 0)
            productModel?.productParameter?.insert(netWeightParam, at: 1)
        }
    }
    //选完规格重新刷新商品尺寸、重量
    fileprivate func refreshParameter() {
        if productModel?.productParameter?.count > 0 {
            let sizeParam = WOWParameter.init(parameterShowName: "尺寸", parameterValue: productSpec.productSize(productInfo: productModel!))
            let netWeightParam = WOWParameter.init(parameterShowName: "重量", parameterValue: productSpec.productWeight(productInfo: productModel!))
            productModel?.productParameter?[0] = sizeParam
            productModel?.productParameter?[1] = netWeightParam
        }
    }
    
    fileprivate func configBanner() {
        if imgUrlArr.count >= 1 {
            //当前主品放到轮播的第一个
            cycleView.imageURLArray = imgUrlArr
            
        }
        tableView.reloadData()
    }
    //商品过期
    fileprivate func productExpired() {
        productEffectView.isHidden = false
        shareButton.isHidden = true
        addCartButton.isHidden = true
        nowBuyButton.isEnabled = false
        nowBuyButton.setBackgroundColor(UIColor.init(hexString: "CCCCCC")!, forState: .disabled)
        buyCarCount()
    }
    //MARK:Actions
    //更多评论
    func moreCommentClick() {
        let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWProductCommentController.self)) as! WOWProductCommentController
        vc.product_id = productId ?? 0
        navigationController?.pushViewController(vc, animated: true)
        
    }
    //MARK:更新角标
    func updateCarBadge(_ carCount: Int){
        WOWUserManager.userCarCount += carCount
        NotificationCenter.postNotificationNameOnMainThread(WOWUpdateCarBadgeNotificationKey, object: nil)
        
    }
    //查看大图
    func loadBigImage(_ imageArray: Array<String>, _ index: Int) {
        func setPhoto() -> [PhotoModel] {
            var photos: [PhotoModel] = []
            for photoURLString in imageArray {
                
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
        photoBrowser.show(inVc: self, beginPage: index)
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
        MobClick.e(.Immebuy_Button)
        MobClick.e(.Buy_It_Now)
        chooseStyle(carEntrance.payEntrance)
    }
    
    //MARK:放入购物车
    @IBAction func addCarClick(_ sender: UIButton) {
        guard WOWUserManager.loginStatus else{
            toLoginVC(true)
            return
        }
        MobClick.e(.Add_To_Cart)
        chooseStyle(carEntrance.addEntrance)
    }
    
    //MARK:分享
    @IBAction func shareClick(_ sender: UIButton) {
        let shareUrl = WOWShareUrl + "/item/\(productId ?? 0)"
        WOWShareManager.share(productModel?.productTitle, shareText: productModel?.sellingPoint, url:shareUrl,shareImage:imgUrlArr[0] )
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
        WOWBuyCarMananger.sharedBuyCar.productSpecModel = productSpecModel
        WOWBuyCarMananger.sharedBuyCar.productId = productId
        view.addSubview(backView)
        view.bringSubview(toFront: backView)
        backView.show(entrue)
    }
    
    func edgePanGesture(_ edgePan: UIScreenEdgePanGestureRecognizer) {
        let progress = edgePan.translation(in: self.view).x / self.view.bounds.width
        
        if edgePan.state == UIGestureRecognizerState.began {
            self.percentDrivenTransition = UIPercentDrivenInteractiveTransition()
          _ =  self.navigationController?.popViewController(animated: true)
        } else if edgePan.state == UIGestureRecognizerState.changed {
            self.hiddenBottom(progress: progress)
            self.percentDrivenTransition?.update(progress)
        } else if edgePan.state == UIGestureRecognizerState.cancelled || edgePan.state == UIGestureRecognizerState.ended {
            if progress > 0.2 {
                self.hiddenBottom(progress: 1)

                self.percentDrivenTransition?.finish()
            } else {
                self.hiddenBottom(progress: 0)

                self.percentDrivenTransition?.cancel()
            }
            self.percentDrivenTransition = nil
        }
    }
    
    
    
    @IBAction func backClick(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK:Private Network
    override func request() {
        isCurrentRequest = true
        super.request()
        //消失loading页面
        
        WOWNetManager.sharedManager.requestWithTarget(.api_ProductDetail(productId: productId ?? 0), successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                //商品过期
                if code == RequestCode.ProductExpired.rawValue {
                    
                    strongSelf.productExpired()
                    return
                }
                strongSelf.productEffectView.isHidden = true
                strongSelf.productModel = Mapper<WOWProductModel>().map(JSONObject:result)
                strongSelf.productModel?.productId = strongSelf.productId
                strongSelf.imgUrlArr = strongSelf.productModel?.primaryImgs ?? [String]()
                //把当前产品的url加入到图片url中，显示到第一个
                if let imgUrl = strongSelf.productModel?.productImg {
                    strongSelf.imgUrlArr.insert(imgUrl, at: 0)
                }
                //产品参数里面要拼接上尺寸重量
                strongSelf.configParameter()
                strongSelf.requestCommentList()
                strongSelf.buyCarCount()
                
                
                
                let dict = [
                    "sellprice"             :strongSelf.productModel?.sellPrice ?? "",
                    "productId"             :strongSelf.productModel?.productId ?? "",
                    "productName"           :strongSelf.productModel?.productName ?? ""
                    ] as [String : Any]
                let price = (strongSelf.productModel?.sellPrice ?? 0) * 100
                AnalyaticEvent.e2(.ViewItem, dict)
                TalkingDataAppCpa.onViewItem(withCategory: "", itemId: strongSelf.productModel?.productId?.toString, name: strongSelf.productModel?.productName ?? "", unitPrice: Int32(price))
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
        WOWNetManager.sharedManager.requestWithTarget(.api_ProductSpec(productId: productId ?? 0), successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                strongSelf.productSpecModel = Mapper<WOWProductSpecModel>().map(JSONObject:result)
                
            }
        }) {(errorMsg) in
            
        }
        
    }
    
    //    用户是否喜欢单品
    func requestIsFavoriteProduct() -> Void {
        WOWNetManager.sharedManager.requestWithTarget(.api_IsFavoriteProduct(productId: productId ?? 0), successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                let favorite = JSON(result)["favorite"].bool
                strongSelf.likeButton.isSelected = favorite ?? false
            
            }
        }) {(errorMsg) in
            
        }
        
    }
    
    //用户喜欢某个单品
    func requestFavoriteProduct()  {
        
//        WOWHud.showLoadingSV()

        WOWClickLikeAction.requestFavoriteProduct(productId: productId ?? 0,view:bottomView,btn:likeButton, isFavorite: { [weak self](isFavorite) in
            if let strongSelf = self{
                
                strongSelf.likeButton.isSelected = isFavorite ?? false
            }
            })
        
        
      
    }
    //商品评论
    func requestCommentList() {
        ///获取评论列表
        WOWNetManager.sharedManager.requestWithTarget(.api_ProductCommentList(pageSize: pageSize, currentPage: pageIndex, productId: productId ?? 0), successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                let r = JSON(result)
                let arr = Mapper<WOWProductCommentModel>().mapArray(JSONObject:r["productCommentList"].arrayObject)
                if let array = arr{
                    strongSelf.commentList = array
                }
                strongSelf.requestAboutProduct()
            }
            
            
        }){[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                strongSelf.requestAboutProduct()
            }
            
        }

    }
    
    // 相关商品信息
    func requestAboutProduct()  {
        let params = ["productId": productModel?.productId ?? 0, "currentPage": pageIndex,"pageSize":pageSize] as [String : Any]
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_ProductAbout(params: params as [String : AnyObject]), successClosure: {[weak self] (result, code) in
            
            if let strongSelf = self {
                let arr = Mapper<WOWProductModel>().mapArray(JSONObject:JSON(result)["productVoList"].arrayObject)
                
                if let array = arr{
                    strongSelf.aboutProductArray = array
                    
                }
                //初始化详情页数据
                strongSelf.configData()
                strongSelf.endRefresh()
            }
            
            
        }) {[weak self] (errorMsg) in
            
            if let strongSelf = self{
                //初始化详情页数据
                strongSelf.configData()
                strongSelf.endRefresh()
            }
        }
    }
    
    
    
}

extension WOWProductDetailController :goodsBuyViewDelegate {
    //确定购买
    func sureBuyClick(_ product: WOWProductModel?) {
        backView.hideBuyView()
        let sv = UIStoryboard.initialViewController("BuyCar", identifier:"WOWEditOrderController") as!WOWEditOrderController
        //入口
        sv.entrance = editOrderEntrance.buyEntrance
        sv.productId = product?.productId
        sv.productQty = product?.productQty
        navigationController?.pushViewController(sv, animated: true)
        
    }
    //确定加车
    func sureAddCarClick(_ product: WOWProductModel?) {
        backView.hideBuyView()
        if let product = product {
            
            
            //添加talkingdata 加入购物车事件
            let dict = [
                "count"            :product.productQty ?? 1,
                "ProductName"      :product.productName ?? "",
                "SubProductId"     :product.productId ?? 0,
                "sellprice"        :product.sellPrice ?? 0.00
            ] as [String : Any]
            let price = (product.sellPrice ?? 0) * 100
            AnalyaticEvent.e2(.AddItemToShoppingCart,dict)
            TalkingDataAppCpa.onAddItemToShoppingCart(withCategory: "", itemId: product.productId?.toString , name: product.productName ?? "", unitPrice: Int32(price), amount: Int32(product.productQty ?? 1))
            
            WOWNetManager.sharedManager.requestWithTarget(.api_CartAdd(productId:product.productId ?? 0, productQty:product.productQty ?? 1), successClosure: {[weak self](result, code) in
                if let strongSelf = self {
                    MobClick.e(.Add_To_Cart_Successful)
                    strongSelf.updateCarBadge(product.productQty ?? 1)
                    if let del = strongSelf.delegate {
                        del.updateBuyCarList()
                    }
                }
                
            }) { (errorMsg) in
                
            }
            
        }else {
            WOWHud.showMsg("添加购物车失败")
        }
        
    }
    
    //关闭规格弹窗
    func closeBuyView(_ productInfo: WOWProductModel?) {
        if let productInfo = productInfo {
            productId = productInfo.productId
            productModel?.productTitle = productInfo.productTitle
            productModel?.sellPrice = productInfo.sellPrice
            productModel?.originalprice = productInfo.originalprice
            productModel?.sings = productInfo.sings
            productModel?.discount = productInfo.discount
            productModel?.length = productInfo.length
            productModel?.width = productInfo.width
            productModel?.height = productInfo.height
            productModel?.netWeight = productInfo.netWeight
            if imgUrlArr.count >= 1 {
                imgUrlArr[0] = productInfo.productImg ?? ""
            }
            configData()
            requestIsFavoriteProduct()
        }
    }
    
}

extension WOWProductDetailController : CyclePictureViewDelegate {
    func cyclePictureView(_ cyclePictureView: CyclePictureView, didSelectItemAtIndexPath indexPath: IndexPath) {
        loadBigImage(imgUrlArr, indexPath.row)
    }
}
extension WOWProductDetailController: UINavigationControllerDelegate ,UIGestureRecognizerDelegate
{
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == UINavigationControllerOperation.pop, toVC.className == VCTopic.className {
            let popController = toVC as! VCTopic
            return MagicMovePop(popController: popController, selectView: popController.selectedCell.pictureImageView )
        }else if operation == UINavigationControllerOperation.pop, toVC.className == WOWProductListController.className {
            let popController = toVC as! WOWProductListController
            return MagicMovePop(popController: popController, selectView: popController.selectedCell.pictureImageView )
        }else if operation == UINavigationControllerOperation.pop, toVC.className == WOWSceneController.className {
            let popController = toVC as! WOWSceneController
            return MagicMovePop(popController: popController, selectView: popController.selectedCell.pictureImageView )
        }else if operation == UINavigationControllerOperation.pop, toVC.className == WOWSearchController.className {
            let popController = toVC as! WOWSearchController
            return MagicMovePop(popController: popController, selectView: popController.selectedCell.pictureImageView )
        }else if operation == UINavigationControllerOperation.pop, toVC.className == WOWBuyCarController.className {
            let popController = toVC as! WOWBuyCarController
            return MagicMovePop(popController: popController, selectView: popController.selectedImage)
        }else if operation == UINavigationControllerOperation.pop, toVC.className == WOWBrandHomeController.className {
            let popController = toVC as! WOWBrandHomeController
            return MagicMovePop(popController: popController, selectView: popController.selectedCell.pictureImageView )
        }else {
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animationController is MagicMovePop {
            return self.percentDrivenTransition
        } else {
            return nil
        }
    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
    
}


