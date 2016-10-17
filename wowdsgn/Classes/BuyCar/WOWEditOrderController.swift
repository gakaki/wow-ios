//
//  WOWEditOrderController.swift
//  wowapp
//
//  Created by 安永超 on 16/8/3.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
enum editOrderEntrance {
    case buyEntrance        //立即购买入口
    case carEntrance        //购物车入口
}

class WOWEditOrderController: WOWBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var productId                       :Int?
    var productQty                      :Int?
    var entrance                        :editOrderEntrance?
    
    var productArr                      :[WOWCarProductModel]?
    var orderSettle                     :WOWEditOrderModel?
    var totalPrice                      : String?
    var addressInfo                     :WOWAddressListModel?
    var orderCode                       = String()
    var couponModel                     :WOWCouponModel?
    
    fileprivate var tipsTextField           : HolderTextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        request()
        //如果是立即购买入口需要添加商品id和商品数量来创建订单。如果是购物车进来的，直接获取商品列表
        switch entrance! {
        case editOrderEntrance.buyEntrance:
            requestBuyNowProduct()
        case editOrderEntrance.carEntrance:
            requestProduct()
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - lazy
    lazy var backView:WOWPayBackView = {
        let v = WOWPayBackView(frame:CGRect(x: 0,y: 0,width: self.view.w,height: self.view.h + 64))
        v.payView.delegate = self
        return v
    }()
    
    //MARK: - 弹出选择支付窗口
    func chooseStyle() {
        let window = UIApplication.shared.windows.last
        
        window?.addSubview(backView)
        window?.bringSubview(toFront: backView)
        backView.show()
    }

    
    //MARK:Private Method
    override func setUI() {
        navigationItem.title = "确认订单"
        totalPriceLabel.text = "¥ " + (totalPrice ?? "")
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = GrayColorLevel5
        tableView.register(UINib.nibName(String(describing: WOWOrderAddressCell.self)), forCellReuseIdentifier:String(describing: WOWOrderAddressCell.self))
        tableView.register(UINib.nibName(String(describing: WOWProductOrderCell.self)), forCellReuseIdentifier:String(describing: WOWProductOrderCell.self))
        tableView.register(UINib.nibName(String(describing: WOWOrderFreightCell.self)), forCellReuseIdentifier:String(describing: WOWOrderFreightCell.self))
        tableView.register(UINib.nibName(String(describing: WOWTipsCell.self)), forCellReuseIdentifier:String(describing: WOWTipsCell.self))
        tableView.keyboardDismissMode = .onDrag
 
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
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_AddressDefault, successClosure: { [weak self](result) in
            if let strongSelf = self{
                strongSelf.addressInfo = Mapper<WOWAddressListModel>().map(JSONObject:result)
                let section = IndexSet(integer: 0)
                strongSelf.tableView.reloadSections(section, with: .none)
            
            }
        }) { (errorMsg) in
            
        }
    }
    
    //请求商品列表
    func requestProduct() -> Void {
        WOWNetManager.sharedManager.requestWithTarget(.api_OrderSettle, successClosure: { [weak self](result) in
            if let strongSelf = self {
                strongSelf.orderSettle = Mapper<WOWEditOrderModel>().map(JSONObject:result)
                strongSelf.productArr = strongSelf.orderSettle?.orderSettles ?? [WOWCarProductModel]()
                let coupon = WOWCouponModel.init()
                coupon.id = strongSelf.orderSettle?.endUserCouponId
                coupon.deduction = strongSelf.orderSettle?.deduction
                strongSelf.couponModel = coupon
                let result = WOWCalPrice.calTotalPrice([strongSelf.orderSettle?.totalAmount ?? 0],counts:[1])

                strongSelf.totalPriceLabel.text = result
                strongSelf.tableView.reloadData()
            }
            
            }) { (errorMsg) in
                
        }
    }
    
    //请求立即购买订单信息
    func requestBuyNowProduct() -> Void {
        WOWNetManager.sharedManager.requestWithTarget(.api_OrderBuyNow(productId: productId ?? 0, productQty: productQty ?? 1), successClosure: { [weak self](result) in
            if let strongSelf = self {
                
                strongSelf.orderSettle = Mapper<WOWEditOrderModel>().map(JSONObject:result)
                
                strongSelf.productArr = strongSelf.orderSettle?.orderSettles ?? [WOWCarProductModel]()
                
                let coupon = WOWCouponModel.init()
                coupon.id = strongSelf.orderSettle?.endUserCouponId
                coupon.deduction = strongSelf.orderSettle?.deduction
                strongSelf.couponModel = coupon
                
                let result = WOWCalPrice.calTotalPrice([strongSelf.orderSettle?.totalAmount ?? 0],counts:[1])
                strongSelf.totalPriceLabel.text = result
                strongSelf.tableView.reloadData()
            }
            
        }) { (errorMsg) in
            
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
        
        if let endUserCouponId = couponModel?.id {
            
            params = [
                "shippingInfoId": shippingInfoId as AnyObject,
                "orderSource": orderSource as AnyObject,
                "orderAmount": totalAmout as AnyObject,
                "remark": remark as AnyObject,
                "endUserCouponId": endUserCouponId  as AnyObject
            ]
            
        }else {
            params = [
                "shippingInfoId": shippingInfoId as AnyObject ,
                "orderSource": orderSource  as AnyObject,
                "orderAmount": totalAmout  as AnyObject,
                "remark": remark  as AnyObject
            ]

        }
        
        WOWNetManager.sharedManager.requestWithTarget(.api_OrderCreate(params: params), successClosure: { [weak self](result) in
            if let strongSelf = self {
                
                //重新计算购物车数量
                for product in (strongSelf.productArr ?? [WOWCarProductModel]()) {
                    WOWUserManager.userCarCount -= product.productQty ?? 1
                }
                NotificationCenter.postNotificationNameOnMainThread(WOWUpdateCarBadgeNotificationKey, object: nil)
                
                strongSelf.orderCode = JSON(result)["orderCode"].string ?? ""
                strongSelf.chooseStyle()
                
                let sum                  = Int32(totalAmout) ?? 0
                let order_id             = strongSelf.orderCode
                
                let order                = TDOrder.init(orderId: order_id, total: sum, currencyType: "CNY")
                order?.addItem(withCategory: "", name: "", unitPrice: sum, amount: sum)
                order?.addItem(withCategory: "", itemId: order_id, name: "", unitPrice: sum, amount: sum    )
                TalkingDataAppCpa.onPlaceOrder(WOWUserManager.userID, with: order)

            }
            
            }) { (errorMsg) in
                
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
        
        if let endUserCouponId = couponModel?.id {
            
            params = [
                "productId": product_id as AnyObject,
                "productQty": product_qty as AnyObject,
                "shippingInfoId": shippingInfoId as AnyObject,
                "orderSource": orderSource as AnyObject,
                "orderAmount": totalAmount as AnyObject,
                "remark": remark as AnyObject,
                "endUserCouponId": endUserCouponId as AnyObject
            ]
            
        }else {
      
            
            params = [
                "productId": product_id as AnyObject,
                "productQty": product_qty as AnyObject,
                "shippingInfoId": shippingInfoId as AnyObject,
                "orderSource": orderSource as AnyObject,
                "orderAmount": totalAmount as AnyObject,
                "remark": remark as AnyObject
            ]
        }
        
        WOWNetManager.sharedManager.requestWithTarget(.api_OrderCreate(params: params), successClosure: { [weak self](result) in
            if let strongSelf = self {
                strongSelf.orderCode = JSON(result)["orderCode"].string ?? ""
                strongSelf.chooseStyle()
            }
            
        }) { (errorMsg) in
            
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
        WOWNetManager.sharedManager.requestWithTarget(.api_PayResult(orderCode: orderCode), successClosure: { [weak self](result) in
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
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
            
            }) { (errorMsg) in
                
        }
    }
    
}

extension WOWEditOrderController:UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:     //地址
            return 1
        case 1:     //商品清单
            return productArr?.count ?? 0
        case 2:   //运费，优惠券
            return 2
        case 3:     //订单备注
            return 1
        default:
            return 0
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
                cell.leftLabel.text = "运费"
                let result = WOWCalPrice.calTotalPrice([self.orderSettle?.deliveryFee ?? 0],counts:[1])
                cell.freightPriceLabel.text = result
                cell.couponLabel.isHidden = true
                cell.nextImage.isHidden = true
                cell.freightPriceLabel.isHidden = false
                cell.lineView.isHidden = false
            }else {
                cell.leftLabel.text = "优惠券"
                cell.freightPriceLabel.isHidden = true
                cell.nextImage.isHidden = false
                cell.couponLabel.isHidden = false
                cell.lineView.isHidden = true
                
                if let deduction = self.orderSettle?.deduction  {
                        let result = WOWCalPrice.calTotalPrice([deduction],counts:[1])
                        cell.couponLabel.text = "-" + result
                    
                }else {
                    cell.couponLabel.text = String(format: "您有%i张优惠券可用",self.orderSettle?.avaliableCouponCount ?? 0 )
                }
            }
            returnCell = cell
        case 3: //订单备注
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WOWTipsCell.self), for:indexPath) as! WOWTipsCell
            cell.textView.placeHolder = "写下您的特殊要求"
            tipsTextField = cell.textView
            returnCell = cell
        default:
            break
        }
        return returnCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch ((indexPath as NSIndexPath).section, (indexPath as NSIndexPath).row ){
        case (0, 0):
            
            let vc = UIStoryboard.initialViewController("User", identifier:String(describing: WOWAddressController.self)) as! WOWAddressController
            vc.entrance = WOWAddressEntrance.sureOrder
            vc.action = {(model:AnyObject) in
                self.addressInfo = model as? WOWAddressListModel
                self.tableView.reloadData()
            }
            navigationController?.pushViewController(vc, animated: true)
        case (2, 1):
            let vc = UIStoryboard.initialViewController("User", identifier: "WOWCouponController") as! WOWCouponController
            vc.entrance = couponEntrance.orderEntrance
            vc.couponModel = couponModel
            vc.minAmountLimit = orderSettle?.productTotalAmount
            //从优惠券返回的时候要重新更新减得金额
            vc.action = {[weak self] (model:AnyObject) in
                if let strongSelf = self {
                    let couponInfo: WOWCouponModel? = model as? WOWCouponModel
                    
                    if couponInfo?.id != strongSelf.couponModel?.id {
                        strongSelf.couponModel = model as? WOWCouponModel
                        
                        strongSelf.orderSettle?.deduction = strongSelf.couponModel?.deduction
                        
                        let section = IndexSet(integer: 2)
                        strongSelf.tableView.reloadSections(section, with: .none)
                        
                        //重新计算总金额，先把double转为number类型的，避免计算过程中由于浮点型而改变数值
                        let productTotal = NSDecimalNumber(value: strongSelf.orderSettle?.productTotalAmount ?? 0 as Double)
                        
                        let delivery = NSDecimalNumber(value: strongSelf.orderSettle?.deliveryFee ?? 0 as Double)
                        let deduction = NSDecimalNumber(value: couponInfo?.deduction ?? 0 as Double)
                        
                        //用商品的总价加上运费然后减去优惠券金额得出结算价格
                        strongSelf.orderSettle?.totalAmount = (productTotal.adding(delivery).subtracting(deduction)).doubleValue
                        
                        
                        let result = WOWCalPrice.calTotalPrice([strongSelf.orderSettle?.totalAmount ?? 0],counts:[1])
                        
                        strongSelf.totalPriceLabel.text = result

                    }
                    
                }
            }
            navigationController?.pushViewController(vc, animated: true)

        default:
            break
        }
    }
    

    
//    //尾视图  只有商品清单栏需要
//    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        if section == 1 { //地址
//            let footerView = NSBundle.mainBundle().loadNibNamed(String(WOWOrderFooterView), owner: self, options: nil).last as!WOWOrderFooterView
//            var count = Int()
//            if let arr = productArr {
//                for product in arr {
//                    count += product.productQty ?? 0
//                }
//            }
//            
//            footerView.countLabel.text = "共\(count)件"
//            footerView.totalPriceLabel.text = String(format:"合计¥ %.2f",(self.orderSettle?.productTotalAmount) ?? 0)
//            return footerView
//        }
//        return nil
//    }
    
    
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
        case 3:
            return 50
        default:
            return 0.01
        }
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
        
        
        WOWNetManager.sharedManager.requestWithTarget(.api_OrderCharge(orderNo: orderCode , channel: channel, clientIp: IPManager.sharedInstance.ip_public), successClosure: { [weak self](result) in
            if let strongSelf = self {
                let json = JSON(result)
                let charge = json["charge"]
                strongSelf.goPay(charge.object as AnyObject)
            }
            
            }) { (errorMsg) in
                
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

