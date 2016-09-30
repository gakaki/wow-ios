//
//  WOWGoodsDetailController.swift
//  Wow
//
//  Created by 小黑 on 16/4/11.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit
class WOWGoodsDetailController: WOWBaseViewController {
    var productId:Int?
    var cycleView:CyclePictureView!
    
    @IBOutlet weak var carEntranceButton: MIBadgeButton!
    @IBOutlet weak var favoriteButton   : UIButton!
    @IBOutlet weak var tableView        : UITableView!
    @IBOutlet weak var priceLabel       : UILabel!
    var productModel                    : WOWProductModel?
    var updateBadgeAction               : WOWActionClosure?
    fileprivate var shareProductImage:UIImage? //供分享使用
    
    lazy var placeImageView:UIImageView={  //供分享使用
        let image = UIImageView()
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: WOWGoodsSureBuyNotificationKey), object: nil)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: WOWLoginSuccessNotificationKey), object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addObservers()
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setUI() {
        super.setUI()
        self.edgesForExtendedLayout = UIRectEdge()
        configTableView()
        configHeaderView()
        updateCarBadge()
    }
    
    
    
//MARK:Private Method
    
    fileprivate func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(sureButton(_:)), name: NSNotification.Name(rawValue: WOWGoodsSureBuyNotificationKey), object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(rawValue: WOWLoginSuccessNotificationKey), object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateCarBadge), name: NSNotification.Name(rawValue: WOWUpdateCarBadgeNotificationKey), object: nil)
    }
    
    func loginSuccess() {
        request()
    }
    
    func sureButton(_ nf:Notification)  {
        let object = nf.object as? WOWCarProductModel
        if let model = object {
           resolveBuyModel(model)
        }
        backView.hideBuyView()
    }
    
    fileprivate func resolveBuyModel(_ model:WOWCarProductModel){
        //放进购物车管理类，进行选中
//        WOWBuyCarMananger.sharedBuyCar.chooseProducts.append(model.skuID)
        
        if WOWUserManager.loginStatus { //登录
//            saveNetBuyCar(model)
        }else{
            //存入本地数据库 先判断是否存在
//            let skus = WOWRealm.objects(WOWCarProductModel).filter("skuID = '\(model.skuID)'")
//            if let m = skus.first{
//                let count = m.skuProductCount
//                model.skuProductCount += count
//                try! WOWRealm.write({
//                    WOWRealm.add(model, update: true)
//                })
//                WOWHud.showMsg("添加购物车成功")
//            }else{
//                try! WOWRealm.write({
//                    WOWRealm.add(model, update:true)
//                })
//                WOWHud.showMsg("添加购物车成功")
//            }
            updateCarBadge()
        }
    }
    
    
//    private func saveNetBuyCar(model:WOWBuyCarModel){
//        let uid = WOWUserManager.userID
//        let carItems = [["skuid":model.skuID,"count":"\(model.skuProductCount)","productid":model.productID,"skuname":model.skuName]]
//        let param = ["uid":uid,"cart":carItems,"tag":"0"]
//        let string = JSONStringify(param)
//        WOWNetManager.sharedManager.requestWithTarget(.Api_CarEdit(cart:string), successClosure: {[weak self] (result) in
//            if let strongSelf = self{
//                let json = JSON(result)
//                DLog(json)
//                WOWHud.showMsg("添加购物车成功")
//                let carCount = json["productcount"].int ?? 0
//                WOWUserManager.userCarCount = carCount
//                strongSelf.updateCarBadge()
//            }
//        }) { (errorMsg) in
//            WOWHud.showMsg("添加购物车失败")
//        }
//    }
    
    
    func updateCarBadge(){
        WOWBuyCarMananger.updateBadge()
//        carEntranceButton.badgeString = WOWBuyCarMananger.calCarCount()
        carEntranceButton.badgeEdgeInsets = UIEdgeInsetsMake(15, 0, 0,15)
        if let action = updateBadgeAction {
            action()
        }
    }
    
    
    fileprivate func configTableView(){
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.mj_header = self.mj_header
        tableView.register(UINib.nibName(String(describing: WOWGoodsTypeCell.self)), forCellReuseIdentifier:String(describing: WOWGoodsTypeCell.self))
        tableView.register(UINib.nibName(String(describing: WOWGoodsDetailCell.self)), forCellReuseIdentifier:String(describing: WOWGoodsDetailCell.self))
        tableView.register(UINib.nibName(String(describing: WOWGoodsParamCell.self)), forCellReuseIdentifier:String(describing: WOWGoodsParamCell.self))
        tableView.register(UINib.nibName(String(describing: WOWSenceLikeCell.self)), forCellReuseIdentifier:String(describing: WOWSenceLikeCell.self))
        tableView.register(UINib.nibName(String(describing: WOWCommentCell.self)), forCellReuseIdentifier:String(describing: WOWCommentCell.self))
        tableView.register(UINib.nibName(String(describing: WOWDesignerCell.self)), forCellReuseIdentifier:String(describing: WOWDesignerCell.self))
    }
    
    func configHeaderView(){
        cycleView = CyclePictureView(frame:MGFrame(0, y: 0, width: MGScreenWidth, height: MGScreenWidth), imageURLArray: nil)
        cycleView.placeholderImage = UIImage(named: "placeholder_product")
        tableView.tableHeaderView = cycleView
    }
    
    func configData(){
        let result = WOWCalPrice.calTotalPrice([productModel?.sellPrice ?? 0],counts:[1])
        priceLabel.text = result
        cycleView.imageURLArray = [productModel?.productImg ?? ""]
        
        
//TODO
//        placeImageView.kf.setImage(with: URL(string:productModel?.productImg ?? "")', placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in {
//            if let strongSelf = self{
//                strongSelf.shareProductImage = image
//            }
//        })
     
    }
    
//MARK:Actions
    
    @IBAction func carEntranceClick(_ sender: UIButton) {
        let nav = UIStoryboard.initialViewController("BuyCar")
        self.present(nav, animated: true, completion: nil)
    }

//MARK:Private Network
    override func request() {
        super.request()
//        let uid = WOWUserManager.userID
        WOWNetManager.sharedManager.requestWithTarget(.api_ProductDetail(productId: productId ?? 0), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                strongSelf.productModel = Mapper<WOWProductModel>().map(JSONObject:result)
                strongSelf.configData()
                strongSelf.tableView.reloadData()
                strongSelf.endRefresh()
            }
        }) {[weak self](errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }
    }
    
//MARK:Actions
    @IBAction func back(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func likeButtonClick(_ sender: UIButton) {
        if !WOWUserManager.loginStatus {
            goLogin()
        }else{
            let uid         = WOWUserManager.userID
            _     = self.productId ?? 0
            let type        = "1" //1为商品 2 为场景
            let is_delete   = favoriteButton.isSelected ? "1":"0"
//            WOWNetManager.sharedManager.requestWithTarget(RequestApi.Apifa(product_id: thingid, uid: uid, type: type, is_delete:is_delete, scene_id:""), successClosure: { [weak self](result) in
//                let json = JSON(result)
//                DLog(json)
//                if let strongSelf = self{
//                    strongSelf.favoriteButton.selected = !strongSelf.favoriteButton.selected
//                }
//            }, failClosure: { (errorMsg) in
//                    
//            })
        }
    }
    
    
    fileprivate func goLogin(){
        let vc = UIStoryboard.initialViewController("Login", identifier: "WOWLoginNavController")
        present(vc, animated: true, completion: nil)
    }

    
    @IBAction func shareButtonClick(_ sender: UIButton) {
//        let shareUrl = "http://www.wowdsgn.com/\(productModel?.skuID ?? "").html"
//        WOWShareManager.share(productModel?.productName, shareText: productModel?.productDes, url:shareUrl,shareImage:shareProductImage ?? UIImage(named: "me_logo")!)
    }
    
    lazy var backView:WOWBuyBackView = {
        let v = WOWBuyBackView(frame:CGRect(x: 0,y: 0,width: self.view.w,height: self.view.h))
        return v
    }()

//MARK:选择规格
    @IBAction func buyButtonClick(_ sender: UIButton) {
//        WOWBuyCarMananger.sharedBuyCar.productSpecModel = self.productModel
//        WOWBuyCarMananger.sharedBuyCar.skuName     = self.productModel?.skus?.first?.skuTitle
//        WOWBuyCarMananger.sharedBuyCar.buyCount    = 1
//        WOWBuyCarMananger.sharedBuyCar.skuID       = self.productModel?.skus?.first?.skuID ?? ""
//        WOWBuyCarMananger.sharedBuyCar.skuPrice = productModel?.price ?? ""
//        WOWBuyCarMananger.sharedBuyCar.skuDefaultSelect = 0
        view.addSubview(backView)
        view.bringSubview(toFront: backView)
        backView.show(carEntrance.payEntrance)
    }
}

extension WOWGoodsDetailController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: //系列
            return 1
        case 1: //图文
            if let pics = productModel?.primaryImgs{
                return pics.count
            }
            return 0
        case 2: //设计师
            if let _ = productModel?.designerName{
                return 1
            }
            return 0
        case 3: //参数
//            if let att = productModel?.productParameter {
//                return att.count
//            }
            return 0
        case 4: //喜欢
            return 0
        case 5: //评论
//            if let commentList = productModel?.comments {
//                return commentList.count > 5 ? 5 : commentList.count
//            }
            return 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell :UITableViewCell!
        switch (indexPath as NSIndexPath).section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WOWGoodsTypeCell.self), for: indexPath) as! WOWGoodsTypeCell
            cell.headImageView.addTarget(self, action: #selector(brandHeadClick), for:.touchUpInside)
            cell.showData(productModel)
            returnCell = cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WOWGoodsDetailCell.self), for: indexPath) as! WOWGoodsDetailCell
            if let pics = productModel?.primaryImgs{
                let model = pics[(indexPath as NSIndexPath).row]
//                cell.showData(model)
            }
            returnCell = cell
        case 2: //设计师
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WOWDesignerCell.self), for:indexPath) as! WOWDesignerCell
            cell.showData(productModel)
            returnCell = cell
        case 3: //参数
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WOWGoodsParamCell.self), for: indexPath) as! WOWGoodsParamCell
//            if let att = productModel?.attributes {
//                cell.showData(att[indexPath.row])
//            }
            returnCell = cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WOWSenceLikeCell.self),for: indexPath) as! WOWSenceLikeCell
//            cell.rightTitleLabel.text = "\(productModel?.likesCount ?? 0)人喜欢"
            cell.rightBackView.addAction({ [weak self] in
                if let strongSelf = self{
                    let likeVC = UIStoryboard.initialViewController("Home", identifier:String(describing: WOWLikeListController.self))
                    strongSelf.navigationController?.pushViewController(likeVC, animated: true)
                }
            })
            returnCell = cell
        case 5: //评论
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WOWCommentCell.self),for: indexPath)as!WOWCommentCell
            cell.hideHeadImage()
//            if let model = productModel?.comments?[indexPath.row]{
//                cell.commentLabel.text = model.comment
//                cell.dateLabel.text    = model.created_at
//                cell.nameLabel.text    = model.user_nick
//            }
            returnCell = cell
        default:
            DLog("")
        }
        return returnCell
    }
    
    func brandHeadClick() {
        let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWBrandHomeController.self)) as! WOWBrandHomeController
        vc.brandID = productModel?.brandId
        vc.hideNavigationBar = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func moreLikeButtonClick(){
        let likeVC = UIStoryboard.initialViewController("Home", identifier:String(describing: WOWLikeListController.self))
        navigationController?.pushViewController(likeVC, animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 2:
            return productModel?.designerName == nil ? 0.01 : 36
        case 3:
            return 36
        case 5: //评论
//            if let arr = productModel?.comments {
//                return arr.count == 0 ? 0.01 : 36
//            }
            return 0.01
        default:
            return 0.01
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 2:
            return 0.01
        case 1,3:
            return 20
        case 5: //评论
            return 44
        default:
            return 0.01
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0,1:
            return nil
        case 2: //设计师
            return productModel?.designerName == nil ? nil : WOWMenuTopView(leftTitle: "设计师", rightHiden: true, topLineHiden: true, bottomLineHiden: false)
        case 3://参数
            return WOWMenuTopView(leftTitle: "产品参数", rightHiden: true, topLineHiden: true, bottomLineHiden: false)
//        case 5: //评论
//            if let arr = productModel?.comments {
//                if arr.count == 0 {
//                    return nil
//                }else{
//                    let view =  WOWMenuTopView(leftTitle: "\(productModel?.comments_count ?? 0)条评论", rightHiden: false, topLineHiden: false, bottomLineHiden: false)
//                    goComment(view)
//                    return view
//                }
//            }else{
//                return nil
//            }
        default:
            return nil
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        if section == 5 {
//            let footerView = WOWMenuTopView(leftTitle: "发表评论", rightHiden: false, topLineHiden:(productModel?.comments?.count ?? 0) == 0 ? true:false, bottomLineHiden: false)
//            goComment(footerView)
//            return footerView
//        }
        return nil
    }
    
    fileprivate func goComment(_ commentView:UIView!){
        commentView.addAction{[weak self] in
            if let strongSelf = self{
                let vc = UIStoryboard.initialViewController("Home", identifier: String(describing: WOWCommentController())) as! WOWCommentController
                vc.commentType = CommentType.product
                vc.mainID = self?.productId ?? 0
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    
}



