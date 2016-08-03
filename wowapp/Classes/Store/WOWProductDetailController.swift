//
//  WOWProductDetailController.swift
//  wowapp
//
//  Created by 小黑 on 16/6/3.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWProductDetailController: WOWBaseViewController {
    //Param
    var productId                       : String?
    var productModel                    : WOWProductModel?
    var productSpecModel                : WOWProductSpecModel?
    private(set) var numberSections = 0
    
    //UI
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var carEntranceButton: MIBadgeButton!
    
    
    private var shareProductImage:UIImage? //供分享使用
    lazy var placeImageView:UIImageView={  //供分享使用
        let image = UIImageView()
        return image
    }()
    
    lazy var backView:WOWBuyBackView = {
        let v = WOWBuyBackView(frame:CGRectMake(0,0,self.view.w,self.view.h))
        v.buyView.delegate = self
        return v
    }()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        addObservers()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:WOWGoodsSureBuyNotificationKey, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:WOWLoginSuccessNotificationKey, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:WOWUpdateCarBadgeNotificationKey, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:WOWGoodsSureAddCarNotificationKey, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productId = "104"
        request()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

//MARK:Lazy
    var cycleView:CyclePictureView! = {
        let v = CyclePictureView(frame:MGFrame(0, y: 0, width:MGScreenWidth, height:MGScreenWidth), imageURLArray: nil)
        v.placeholderImage = UIImage(named: "placeholder_banner")
        v.currentDotColor = UIColor.blackColor()
        v.otherDotColor   = UIColor.whiteColor()
        v.autoScroll = false
        return v
    }()

//MARK:Private Method
    override func setUI() {
        super.setUI()
        configTable()

    }

    private func addObservers(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(loginSucces), name: WOWLoginSuccessNotificationKey, object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateCarBadge), name: WOWUpdateCarBadgeNotificationKey, object: nil)

        

    }

    
    private func configData(){
        cycleView.imageURLArray = productModel?.primaryImgs ?? [""]
        placeImageView.kf_setImageWithURL(NSURL(string:productModel?.productImage ?? "")!, placeholderImage:nil, optionsInfo: nil) {[weak self](image, error, cacheType, imageURL) in
            if let strongSelf = self{
                strongSelf.shareProductImage = image
            }
        }
    }
    
//MARK:Actions
    //MARK:更新角标
    func updateCarBadge(){
//        WOWBuyCarMananger.updateBadge()
//        carEntranceButton.badgeString = WOWBuyCarMananger.calCarCount()
//        carEntranceButton.badgeEdgeInsets = UIEdgeInsetsMake(15, 0, 0,15)
//        if let action = updateBadgeAction {
//            action()
//        }
    }
    //MARK:购物车
    @IBAction func carEntranceButton(sender: UIButton) {
        let vc = UIStoryboard.initialViewController("BuyCar", identifier:String(WOWBuyCarController)) as! WOWBuyCarController
        vc.hideNavigationBar = false
        navigationController?.pushViewController(vc, animated: true)

    }
    
    //MARK:登录成功回调
    func loginSucces(){
        DLog("登录成功")
    }
    
    //MARK:立即购买
    @IBAction func buyClick(sender: UIButton) {
        chooseStyle(carEntrance.PayEntrance)
    }
    
    //MARK:放入购物车
    @IBAction func addCarClick(sender: UIButton) {
        chooseStyle(carEntrance.AddEntrance)
    }
    
    //MARK:分享
    @IBAction func shareClick(sender: UIButton) {
        let shareUrl = "http://www.wowdsgn.com/\(productModel?.skuID ?? "").html"
        WOWShareManager.share(productModel?.productName, shareText: productModel?.productDes, url:shareUrl,shareImage:shareProductImage ?? UIImage(named: "me_logo")!)
    }
    
    //MARK:喜欢
    @IBAction func likeClick(sender: UIButton) {
        if !WOWUserManager.loginStatus {
            toLoginVC(true)
        }else{
           requestFavoriteProduct()
        }
    }
    
    
    private func goLogin(){
        let vc = UIStoryboard.initialViewController("Login", identifier: "WOWLoginNavController")
        presentViewController(vc, animated: true, completion: nil)
    }
    

    //MARK:选择规格,有两种视图
    func chooseStyle(entrue: carEntrance) {
        WOWBuyCarMananger.sharedBuyCar.productSpecModel      = self.productSpecModel
        WOWBuyCarMananger.sharedBuyCar.isFavorite       = likeButton.selected
        WOWBuyCarMananger.sharedBuyCar.skuName          = self.productModel?.skus?.first?.skuTitle
        WOWBuyCarMananger.sharedBuyCar.buyCount         = 1
        WOWBuyCarMananger.sharedBuyCar.skuID            = self.productModel?.skus?.first?.skuID ?? ""
        WOWBuyCarMananger.sharedBuyCar.skuPrice         = productModel?.price ?? ""
        WOWBuyCarMananger.sharedBuyCar.skuDefaultSelect = 0
        view.addSubview(backView)
        view.bringSubviewToFront(backView)
        backView.show(entrue)
    }
    
    @IBAction func backClick(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
//MARK:Private Network
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(.Api_ProductDetail(productId: productId ?? ""), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                strongSelf.productModel = Mapper<WOWProductModel>().map(result)
                strongSelf.productModel?.productId = strongSelf.productId
                strongSelf.configData()
                strongSelf.numberSections = 5
                strongSelf.tableView.reloadData()
                strongSelf.endRefresh()
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
        WOWNetManager.sharedManager.requestWithTarget(.Api_ProductSpec(productId: productId ?? ""), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                strongSelf.productSpecModel = Mapper<WOWProductSpecModel>().map(result)
                print(strongSelf.productSpecModel)
                
            }
        }) {(errorMsg) in
           
        }

    }
    
    //用户是否喜欢单品
    func requestIsFavoriteProduct() -> Void {
        WOWNetManager.sharedManager.requestWithTarget(.Api_IsFavoriteProduct(productId: productId?.toInt() ?? 0), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                let favorite = JSON(result)["favorite"].bool
                strongSelf.likeButton.selected = favorite ?? false
            }
        }) {(errorMsg) in
            
        }

    }
    
    //用户喜欢某个单品
    func requestFavoriteProduct()  {
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_FavoriteProduct(productId: (productId?.toInt()) ?? 0), successClosure: { [weak self](result) in
            if let strongSelf = self{
                strongSelf.likeButton.selected = !strongSelf.likeButton.selected
            }
            }, failClosure: { (errorMsg) in
                
        })

    }
    
}

extension WOWProductDetailController :goodsBuyViewDelegate {
    //确定购买
    func sureBuyClick(product: WOWProductInfoModel?) {
        print("确定购买")
    }
    //确定加车
    func sureAddCarClick(product: WOWProductInfoModel?) {
        backView.hideBuyView()
        if let product = product {
            print(product.weight, product.sizeText, product.subProductId, product.sellPrice)
            
            WOWNetManager.sharedManager.requestWithTarget(.Api_CarAdd(productId:product.subProductId ?? 0, productQty:product.productQty ?? 1), successClosure: { (result) in
                
            }) { (errorMsg) in
                
            }
            
        }
        print("确定驾车")

    }
    //收藏单品
    func favoriteClick() -> Bool{
        if !WOWUserManager.loginStatus {
            toLoginVC(true)
        }else{
            requestFavoriteProduct()
        }
        return likeButton.selected
    }
    //分享
    func sharClick() {
        backView.hideBuyView()
        let shareUrl = "http://www.wowdsgn.com/\(productModel?.skuID ?? "").html"
        WOWShareManager.share(productModel?.productName, shareText: productModel?.productDes, url:shareUrl,shareImage:shareProductImage ?? UIImage(named: "me_logo")!)

    }
}




