//
//  WOWEditOrderController.swift
//  wowapp
//
//  Created by 安永超 on 16/8/3.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import AdSupport

enum editOrderEntrance {
    case buyEntrance        //立即购买入口
    case carEntrance        //购物车入口
}

class WOWEditOrderController: WOWBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var productId                       :Int?       //立即购买过来的产品id
    var productQty                      :Int?       //立即购买的产品数量
    var entrance                        :editOrderEntrance?     //入口
    
    var productArr                      :[WOWCarProductModel]?  //产品列表清单
    var orderSettle                     :WOWEditOrderModel?     //确认订单的信息
    var addressInfo                     :WOWAddressListModel?       //地址信息
    var orderCode                       = String()      //订单号
    var couponModel                     :WOWCouponModel?        //优惠券信息
    var discountAmount                  : Double?  //优惠金额
    
    //是否使用促销优惠
    var isPromotion                     = true

    //时间戳，用来验证唯一
    let timeInterval = Date().timeIntervalSince1970
    
    fileprivate var tipsTextField           : HolderTextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        request()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - lazy
    //支付方式
    lazy var backView:WOWPayBackView = {
        let v = WOWPayBackView(frame:CGRect(x: 0,y: 0,width: MGScreenWidth,height: MGScreenHeight))
        v.payView.delegate = self
        return v
    }()
    //促销信息
    lazy var remissionView:WOWRemissionBackView = {
        let v = WOWRemissionBackView(frame:CGRect(x: 0,y: 0,width: self.view.w,height: self.view.h + 64))
        return v
    }()
    
    
    
    //MARK:Private Method
    override func setUI() {
        
        navigationItem.title = "确认订单"
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = GrayColorLevel5
        //选择地址
        tableView.register(UINib.nibName(String(describing: WOWOrderAddressCell.self)), forCellReuseIdentifier:String(describing: WOWOrderAddressCell.self))
        //产品列表
        tableView.register(UINib.nibName(String(describing: WOWProductOrderCell.self)), forCellReuseIdentifier:String(describing: WOWProductOrderCell.self))
        //选择优惠
        tableView.register(UINib.nibName(String(describing: WOWOrderFreightCell.self)), forCellReuseIdentifier:String(describing: WOWOrderFreightCell.self))
        //备注信息
        tableView.register(UINib.nibName(String(describing: WOWTipsCell.self)), forCellReuseIdentifier:String(describing: WOWTipsCell.self))
        //优惠信息
        tableView.register(UINib.nibName(String(describing: WOWOrderRemissionCell.self)), forCellReuseIdentifier:String(describing: WOWOrderRemissionCell.self))
        //需要帮助
        tableView.register(UINib.nibName(String(describing: WOWTelCell.self)), forCellReuseIdentifier:String(describing: WOWTelCell.self))
        
        tableView.keyboardDismissMode = .onDrag
        self.tableView.mj_header = self.mj_header

    }
    
    func configData() {
        let coupon = WOWCouponModel.init()
        coupon.id = orderSettle?.endUserCouponId
        coupon.deduction = orderSettle?.deduction
        couponModel = coupon
        //如果优惠金额 = 0 ，说明没有优惠
        //默认选促销
        if orderSettle?.totalPromotionDeduction == 0 {
            isPromotion = false
            discountAmount = orderSettle?.deduction
        }else {
            isPromotion = true
            discountAmount = orderSettle?.totalPromotionDeduction

        }
        
        let result = WOWCalPrice.calTotalPrice([orderSettle?.totalAmount ?? 0],counts:[1])
        totalPriceLabel.text = result
        tableView.reloadData()

    }
    
    //MARK: - 弹出选择支付窗口
    func chooseStyle() {
        let window = UIApplication.shared.windows.last
        
        window?.addSubview(backView)
        window?.bringSubview(toFront: backView)
        backView.show()
    }
    // 弹出促销信息
    func remissionInfo() {
        let window = UIApplication.shared.windows.last
        
        window?.addSubview(remissionView)
        window?.bringSubview(toFront: remissionView)
        remissionView.remissionView.promotionInfoArr = self.orderSettle?.promotionProductInfoVos ?? [WOWPromotionProductInfoModel]()
        remissionView.show()
    }
    
    // 跳转地址选择
    func goAddress() {
        let vc = UIStoryboard.initialViewController("User", identifier:String(describing: WOWAddressController.self)) as! WOWAddressController
        vc.entrance = WOWAddressEntrance.sureOrder
        vc.action = {(model:AnyObject) in
            self.addressInfo = model as? WOWAddressListModel
            self.tableView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 跳转优惠券
    func goCoupons() {
        let vc = UIStoryboard.initialViewController("User", identifier: "WOWCouponController") as! WOWCouponController
        vc.entrance = couponEntrance.orderEntrance
        //如果使用促销，则不传优惠券信息
        if isPromotion {
            
        }else {
            vc.couponModel = couponModel

        }
        vc.minAmountLimit = orderSettle?.productTotalAmount
        
  
        //从优惠券返回的时候要重新更新减得金额
        vc.action = {[weak self] (model:AnyObject) in
            if let strongSelf = self {
                let couponInfo: WOWCouponModel? = model as? WOWCouponModel
                
                    strongSelf.couponModel = model as? WOWCouponModel
                    
                    strongSelf.orderSettle?.deductionName = strongSelf.couponModel?.couponTitle
                    //优惠金额
                    strongSelf.orderSettle?.deduction = couponInfo?.deduction
                    //优惠title
                    strongSelf.orderSettle?.deductionName = couponInfo?.title
                    //选择优惠券
                    strongSelf.selectCoupons()
                
            }
        }
        navigationController?.pushViewController(vc, animated: true)

    }
    //重新计算总金额
    func reCalTotalPrice() {
        //重新计算总金额，先把double转为number类型的，避免计算过程中由于浮点型而改变数值
        //所有产品总金额
        let productTotal = NSDecimalNumber(value: orderSettle?.productTotalAmount ?? 0 as Double)
        //优惠金额
        let deduction = NSDecimalNumber(value: discountAmount ?? 0 as Double)
        //产品总金额减去优惠总金额，判断下是否需要增加运费
        let amount = productTotal.subtracting(deduction)
        //如果订单金额满足免邮，邮费=0
        
        if amount.doubleValue < orderSettle?.deliveryFeeThreshold {
            orderSettle?.deliveryFee = orderSettle?.deliveryStandard
        }else {
            orderSettle?.deliveryFee = 0
        }
        //运费
        let delivery = NSDecimalNumber(value: orderSettle?.deliveryFee ?? 0 as Double)
        
        let amountPrice = (amount.adding(delivery)).doubleValue
        //用商品的总价加上运费然后减去优惠券金额得出结算价格
        orderSettle?.totalAmount = amountPrice < 0 ? 0 : amountPrice
        
        
        let result = WOWCalPrice.calTotalPrice([orderSettle?.totalAmount ?? 0],counts:[1])
        
        totalPriceLabel.text = result
    }
    /**
     跳转订单详情
     
     */
        func goOrderDetail() {
        let vc = UIStoryboard.initialViewController("User", identifier: "WOWOrderDetailController") as! WOWOrderDetailController
        vc.orderCode = orderCode
        vc.entrance = orderDetailEntrance.orderPay
        navigationController?.pushViewController(vc, animated: true)

    }
    
    //MARK: - Action
    @IBAction func sureClick(_ sender: UIButton) {
        guard addressInfo != nil else {
            WOWHud.showMsg("请选择收货地址")
            return
        }
        if  let array = productArr {
            //status -1 失效。2下架
            for product in array {
                if product.productStatus == -1 {
                    let str = String(format:"您购买的商品\"%@\"已失效",product.productName ?? "")
                    WOWHud.showWarnMsg(str)
                    return
                }
                if product.productStatus == 2 {
                    let str = String(format:"您购买的商品\"%@\"已下架",product.productName ?? "")
                    WOWHud.showWarnMsg(str)
                    return
                }
                if product.productStatus == 1 && product.productStock == 0 {
                    let str = String(format:"您购买的商品\"%@\"已售罄",product.productName ?? "")
                    WOWHud.showWarnMsg(str)
                    return
                }
            }
        }
        
        //下单前判断一下是否已经生成订单号，如果已经生成了则直接弹窗
        guard orderCode.isEmpty else {
            chooseStyle()
            return
        }
        //提交订单时候增加loading框，防止同时提交多个订单
        WOWHud.showLoadingSV()
        switch entrance! {
        case editOrderEntrance.buyEntrance:
            requestBuyNowOrderCreat()
        case editOrderEntrance.carEntrance:
            requestOrderCreat()
        }

    }
    
    
    //MARK:Network
    override func request() {
        super.request()
        
        //请求地址数据
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_AddressDefault, successClosure: { [weak self](result, code) in
            if let strongSelf = self{
                strongSelf.addressInfo = Mapper<WOWAddressListModel>().map(JSONObject:result)
                strongSelf.tableView.reloadData()
                strongSelf.endRefresh()
            }
        }) { [weak self](errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                WOWHud.showMsgNoNetWrok(message: errorMsg)
            }
        }
        //如果是立即购买入口需要添加商品id和商品数量来创建订单。如果是购物车进来的，直接获取商品列表
        switch entrance! {
        case editOrderEntrance.buyEntrance:
            requestBuyNowProduct()
        case editOrderEntrance.carEntrance:
            requestProduct()
        }
    }
    
    //请求商品列表
    func requestProduct() -> Void {
        WOWNetManager.sharedManager.requestWithTarget(.api_OrderSettle, successClosure: { [weak self](result, code) in
            if let strongSelf = self {
                strongSelf.orderSettle = Mapper<WOWEditOrderModel>().map(JSONObject:result)
                strongSelf.productArr = strongSelf.orderSettle?.orderSettles ?? [WOWCarProductModel]()
                strongSelf.configData()
            }
            
            }) { (errorMsg) in
                WOWHud.showMsgNoNetWrok(message: errorMsg)
        }
    }
    
    //请求立即购买订单信息
    func requestBuyNowProduct() -> Void {
        WOWNetManager.sharedManager.requestWithTarget(.api_OrderBuyNow(productId: productId ?? 0, productQty: productQty ?? 1), successClosure: { [weak self](result, code) in
            if let strongSelf = self {
                
                strongSelf.orderSettle = Mapper<WOWEditOrderModel>().map(JSONObject:result)
                
                strongSelf.productArr = strongSelf.orderSettle?.orderSettles ?? [WOWCarProductModel]()
                
                strongSelf.configData()
            }
            
        }) { (errorMsg) in
            WOWHud.showMsgNoNetWrok(message: errorMsg)
        }
    }
    
    //请求创建订单
    func requestOrderCreat() -> Void {
       
        
        var params = [String: AnyObject]()
        // 截取两位小数点，确保金额正确
        
        let totalAmoutStr   = String(format: "%.2f",((orderSettle?.totalAmount) ?? 0))
        let shippingInfoId  = (addressInfo?.id) ?? 0
        let orderSource     = 2
        let totalAmout      = totalAmoutStr 
        let remark          = tipsTextField.text ?? ""
        
        //往服务端传过去价格确保价格一致性
        var productPriceGroup = ""
        if let arr = productArr {
            if arr.count > 0 {
                for product in arr.enumerated() {
                    if product.offset == arr.count - 1 {
                        let str = String(format: "%i:%.2f",product.element.productId ?? 0,product.element.sellPrice ?? 0)
                        productPriceGroup.append(str)
                    }else {
                        let str = String(format: "%i:%.2f,",product.element.productId ?? 0,product.element.sellPrice ?? 0)
                        productPriceGroup.append(str)
                    }
                }
            }
            
        }
        if isPromotion {
            var promotionIds = [String]()
            if let promotionProductInfoVos = orderSettle?.promotionProductInfoVos {
                for promotion in promotionProductInfoVos {
                    promotionIds.append(String(format:"%i", promotion.promotionId ?? 0))
                }
            }
            
            params = [
                "shippingInfoId": shippingInfoId as AnyObject,
                "orderSource": orderSource as AnyObject,
                "orderAmount": totalAmout as AnyObject,
                "remark": remark as AnyObject,
                "promotionIds": promotionIds  as AnyObject,
                "productPriceGroup": productPriceGroup as AnyObject,
                "orderToken": timeInterval as AnyObject
            ]

        }else {
            if let endUserCouponId = couponModel?.id {
                
                params = [
                    "shippingInfoId": shippingInfoId as AnyObject,
                    "orderSource": orderSource as AnyObject,
                    "orderAmount": totalAmout as AnyObject,
                    "remark": remark as AnyObject,
                    "endUserCouponId": endUserCouponId  as AnyObject,
                    "productPriceGroup": productPriceGroup as AnyObject,
                    "orderToken": timeInterval as AnyObject
                ]
                
            }else {
                params = [
                    "shippingInfoId": shippingInfoId as AnyObject ,
                    "orderSource": orderSource  as AnyObject,
                    "orderAmount": totalAmout  as AnyObject,
                    "remark": remark  as AnyObject,
                    "productPriceGroup": productPriceGroup as AnyObject,
                    "orderToken": timeInterval as AnyObject
                    
                ]
                
            }

        }
        
        
        WOWNetManager.sharedManager.requestWithTarget(.api_OrderCreate(params: params), successClosure: { [weak self](result, code) in
            if let strongSelf = self {
                
                //重新计算购物车数量
                for product in (strongSelf.productArr ?? [WOWCarProductModel]()) {
                    WOWUserManager.userCarCount -= product.productQty ?? 1
                }
                NotificationCenter.postNotificationNameOnMainThread(WOWUpdateCarBadgeNotificationKey, object: nil)
                
                strongSelf.orderCode = JSON(result)["orderCode"].string ?? ""
                strongSelf.chooseStyle()
                WOWHud.dismiss()

                //TalkingData 下单
                var sum = strongSelf.orderSettle?.totalAmount ?? 0
                sum                  = sum * 100 
                let order_id             = strongSelf.orderCode
                
                let order                = TDOrder.init(orderId: order_id, total: Int32(sum), currencyType: "CNY")
                order?.addItem(withCategory: "", name: "", unitPrice: Int32(sum), amount: Int32(sum))
                order?.addItem(withCategory: "", itemId: "", name: "", unitPrice: Int32(sum), amount: Int32(sum)   )
    
                TalkingDataAppCpa.onPlaceOrder(WOWUserManager.userID, with: order)
                AnalyaticEvent.e2(.PlaceOrder,["totalAmount":sum ,"OrderCode":order_id ])
                MobClick.e(.Orders_Submitted)
            }
            
            }) { (errorMsg) in
                
//                LoadView.dissMissView()
                WOWHud.showMsgNoNetWrok(message: errorMsg)
        }
        
      
    }
    
    //立即支付创建订单
    func requestBuyNowOrderCreat() -> Void {
        
        
        var params              = [String: AnyObject]()
        let totalAmount         = String(format: "%.2f",((orderSettle?.totalAmount) ?? 0))
        let product_id          = productId ?? 0
        let product_qty         = productQty ?? 1
        let shippingInfoId      = (addressInfo?.id) ?? 0
        let orderSource         = 2
        let remark              = tipsTextField.text ?? ""
        
        //往服务端传过去价格确保价格一致性
        var productPriceGroup = ""
        if let arr = productArr {
            if arr.count > 0 {
                for product in arr.enumerated() {
                    if product.offset == arr.count - 1 {
                        let str = String(format: "%i:%.2f",product.element.productId ?? 0,product.element.sellPrice ?? 0)
                        productPriceGroup.append(str)
                    }else {
                        let str = String(format: "%i:%.2f,",product.element.productId ?? 0,product.element.sellPrice ?? 0)
                        productPriceGroup.append(str)
                    }
                }
            }
            
        }
        if isPromotion {
            var promotionIds = [String]()
            if let promotionProductInfoVos = orderSettle?.promotionProductInfoVos {
                for promotion in promotionProductInfoVos {
                    promotionIds.append(String(format:"%i", promotion.promotionId ?? 0))
                }
            }
            
            params = [
                "productId": product_id as AnyObject,
                "productQty": product_qty as AnyObject,
                "shippingInfoId": shippingInfoId as AnyObject,
                "orderSource": orderSource as AnyObject,
                "orderAmount": totalAmount as AnyObject,
                "remark": remark as AnyObject,
                "promotionIds": promotionIds  as AnyObject,
                "productPriceGroup": productPriceGroup as AnyObject,
                "orderToken": timeInterval as AnyObject
            ]
            
        }else {
            if let endUserCouponId = couponModel?.id {
                
                params = [
                    "productId": product_id as AnyObject,
                    "productQty": product_qty as AnyObject,
                    "shippingInfoId": shippingInfoId as AnyObject,
                    "orderSource": orderSource as AnyObject,
                    "orderAmount": totalAmount as AnyObject,
                    "remark": remark as AnyObject,
                    "endUserCouponId": endUserCouponId as AnyObject,
                    "productPriceGroup": productPriceGroup as AnyObject,
                    "orderToken": timeInterval as AnyObject
                    
                ]
                
            }else {
                
                
                params = [
                    "productId": product_id as AnyObject,
                    "productQty": product_qty as AnyObject,
                    "shippingInfoId": shippingInfoId as AnyObject,
                    "orderSource": orderSource as AnyObject,
                    "orderAmount": totalAmount as AnyObject,
                    "remark": remark as AnyObject,
                    "productPriceGroup": productPriceGroup as AnyObject,
                    "orderToken": timeInterval as AnyObject
                    
                ]
            }
        }
        
        
        WOWNetManager.sharedManager.requestWithTarget(.api_OrderCreate(params: params), successClosure: { [weak self](result, code) in
            if let strongSelf = self {
                strongSelf.orderCode = JSON(result)["orderCode"].string ?? ""
                strongSelf.chooseStyle()
                WOWHud.dismiss()
                //TalkingData 下单
                var sum = strongSelf.orderSettle?.totalAmount ?? 0
                sum                  = sum * 100 
                let order_id             = strongSelf.orderCode
                
        
                let order                = TDOrder.init(orderId: order_id, total: Int32(sum), currencyType: "CNY")
                order?.addItem(withCategory: "", name: "", unitPrice: Int32(sum), amount: Int32(sum))
                order?.addItem(withCategory: "", itemId: "", name: "", unitPrice: Int32(sum), amount: Int32(sum)   )
                
                TalkingDataAppCpa.onPlaceOrder(WOWUserManager.userID, with: order)
                AnalyaticEvent.e2(.PlaceOrder,["totalAmount":sum ,"OrderCode":order_id ])
                

            }
            
        }) { (errorMsg) in
//            LoadView.dissMissView()
            WOWHud.dismiss()
            WOWHud.showMsgNoNetWrok(message: errorMsg)

        }
    }
    
    //去支付
    fileprivate func goPay(_ charge:AnyObject){
        DispatchQueue.main.async {
            Pingpp.createPayment(charge as! NSObject, appURLScheme:WOWDSGNSCHEME) {[weak self] (ret, error) in
                if let strongSelf = self ,
                    let ret_str = ret as String!{
                    
                    switch ret_str{
                    case "success":
                        strongSelf.requestPayResult()
                    case "cancel":
                        WOWHud.showMsg("支付取消")
                        strongSelf.goOrderDetail()

                        break
                    default:
                        WOWHud.showMsg("支付失败")
                        strongSelf.goOrderDetail()

                        break
                    }
                }
            }
        }
    }
    
    //从服务端去拉取支付结果
    func requestPayResult() {
        WOWNetManager.sharedManager.requestWithTarget(.api_PayResult(orderCode: orderCode), successClosure: { [weak self](result, code) in
            if let strongSelf = self {
                let json = JSON(result)
                let orderCode = json["orderCode"].string
                let payAmount = json["payAmount"].double
                let paymentChannelName = json["paymentChannelName"].string
                let vc = UIStoryboard.initialViewController("BuyCar", identifier:"WOWPaySuccessController") as! WOWPaySuccessController
                vc.payMethod = paymentChannelName ?? ""
                vc.orderid = orderCode ?? ""
                let result = WOWCalPrice.calTotalPrice([payAmount ?? 0],counts:[1])
                vc.totalPrice = result
                
                //TalkingData 支付成功
                var sum = payAmount ?? 0
                sum                  = sum * 100 
                let order_id             = orderCode ?? ""

                AnalyaticEvent.e2(.PaySuccess,["totalAmount":Int32(sum) ,"OrderCode":order_id ])
                //支付结果
                strongSelf.navigationController?.pushViewController(vc, animated: true)
                MobClick.e(.Orders_Payment)
                
                
            }
            
            }) { (errorMsg) in
                WOWHud.showMsgNoNetWrok(message: errorMsg)
        }
    }
    
}

extension WOWEditOrderController:UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:     //地址
            return 1
        case 1:     //商品清单
            return productArr?.count ?? 0
        case 2:   //优惠券 如果促销金额 = 0不显示促销
            return orderSettle?.totalPromotionDeduction == 0 ? 1 : 2
        case 3:     //订单备注
            return 1
        case 4:     //运费。优惠显示
            return 2
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell:UITableViewCell?
        switch (indexPath as NSIndexPath).section {
        case 0: //地址
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WOWOrderAddressCell.self), for: indexPath) as! WOWOrderAddressCell
            cell.showData(addressInfo)
            returnCell = cell
        case 1: //商品清单
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WOWProductOrderCell.self), for: indexPath) as! WOWProductOrderCell
            if let productArr = productArr {
                cell.showData(productArr[(indexPath as NSIndexPath).row])
            }
            returnCell = cell
        case 2: //运费及优惠券信息
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WOWOrderFreightCell.self), for: indexPath) as! WOWOrderFreightCell
            if (indexPath as NSIndexPath).row == 0 {
                cell.leftLabel.text = "优惠券"
                cell.lineView.isHidden = false
                cell.selectBtn.isSelected = !isPromotion
                cell.selectBtn.addTarget(self, action: #selector(selectCoupons), for:.touchUpInside)
                if let deductionName = self.orderSettle?.deductionName {
                    cell.selectBtn.isEnabled = true
                    cell.couponLabel.text = deductionName

                }else {
                    cell.couponLabel.text = String(format: "您有%i张优惠券可用",self.orderSettle?.avaliableCouponCount ?? 0 )
                    cell.selectBtn.isSelected = false
                    cell.selectBtn.setImage(UIImage.init(named: "disable"), for: .disabled)
                    cell.selectBtn.isEnabled = false
                    //如果有促销不使用优惠券则默认选中促销
                    if orderSettle?.totalPromotionDeduction != 0 {
                        isPromotion = true
                        discountAmount = orderSettle?.totalPromotionDeduction
                        reCalTotalPrice()
                        
                    }
                }

            }else {
                cell.leftLabel.text = "促销"
                cell.couponLabel.text = self.orderSettle?.promotionNames?.formatArray("；")
                cell.lineView.isHidden = true
                cell.selectBtn.isEnabled = true
                cell.selectBtn.isSelected = isPromotion
                cell.selectBtn.addTarget(self, action: #selector(selectPromotion), for:.touchUpInside)
            }
            returnCell = cell
        case 3: //订单备注
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WOWTipsCell.self), for:indexPath) as! WOWTipsCell
            cell.textView.placeHolder = "写下您的特殊要求"
            tipsTextField = cell.textView
            returnCell = cell
        case 4: //优惠信息
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WOWOrderRemissionCell.self), for: indexPath) as! WOWOrderRemissionCell
            if (indexPath as NSIndexPath).row == 0 {
                cell.label.text = "运费"
                cell.amountLabel.textColor = UIColor.black
                cell.amountLabel.text = WOWCalPrice.calTotalPrice([self.orderSettle?.deliveryFee ?? 0], counts: [1])
            }else {
                cell.label.text = "优惠"
                cell.amountLabel.textColor = UIColor(hexString: "FF7070")
                let amount = WOWCalPrice.calTotalPrice([self.discountAmount ?? 0], counts: [1])
                cell.amountLabel.text = String(format: "－%@", amount)
            }
            returnCell = cell
        case 5:
            // 需要帮助 UI
  
                let cell =  tableView.dequeueReusableCell(withIdentifier: String(describing: WOWTelCell.self), for: indexPath) as! WOWTelCell
                cell.titleLabel.text = "需要帮助"
                cell.contentView.addTapGesture {(sender) in
                    MobClick.e(.contact_customer_service_edit_order)
                    WOWCustomerNeedHelp.show("",title: "确认订单")
                }
                
               returnCell = cell
        
        default:
            break
        }
        return returnCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch ((indexPath as NSIndexPath).section, (indexPath as NSIndexPath).row ){
        case (0, 0):        //选择地址
            goAddress()
        case (2, 0):        //选择优惠券
            goCoupons()
        case (2, 1):        //查看促销信息
            remissionInfo()
        default:
            break
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return 0.01
        default:
            return 15
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 5:     //最后一组
            return 50
        default:
            return 0.01
        }
    }
    
    
    //MARK: Action -selectRemissionType 选择优惠类型
    //选择优惠券
    func selectCoupons()  {
        isPromotion = false
        discountAmount = orderSettle?.deduction
        reCalTotalPrice()
        tableView.reloadData()

    }
    //选择促销
    func selectPromotion() {
        isPromotion = true
        discountAmount = orderSettle?.totalPromotionDeduction
        reCalTotalPrice()
        tableView.reloadData()

    }
}

//MARK: - selectPayDelegate
extension WOWEditOrderController: selectPayDelegate {
    func surePay(_ channel: String) {
        backView.hidePayView()
        if  orderCode.isEmpty {
            WOWHud.showMsg("订单生成失败")
            return
        }
        
        let deviceId = TalkingDataAppCpa.getDeviceId()
        let adid = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        let sysVersion = UIDevice.current.systemVersion //获取系统版本 例如：9.2

        let params = ["orderNo": orderCode, "channel": channel, "clientIp": IPManager.sharedInstance.ip_public, "tdid": deviceId, "idfa": adid, "osversion": sysVersion]
       
        
        WOWNetManager.sharedManager.requestWithTarget(.api_OrderCharge(params:params as [String : AnyObject]), successClosure: { [weak self](result, code) in
            if let strongSelf = self {
                let json = JSON(result)
                let charge = json["charge"]
                strongSelf.goPay(charge.object as AnyObject)
            }
            
            }) { (errorMsg) in
                WOWHud.showMsgNoNetWrok(message: errorMsg)
        }
    }
    
    func canclePay() {
        if  orderCode.isEmpty {
            WOWHud.showMsg("订单生成失败")
            return
        }
        goOrderDetail()
    }

}

