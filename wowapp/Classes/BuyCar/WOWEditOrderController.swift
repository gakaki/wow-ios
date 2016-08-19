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
    
    private var tipsTextField           : UITextField!

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
        let v = WOWPayBackView(frame:CGRectMake(0,0,self.view.w,self.view.h + 64))
        v.payView.delegate = self
        return v
    }()
    
    //MARK: - 弹出选择支付窗口
    func chooseStyle() {
        let window = UIApplication.sharedApplication().windows.last
        
        window?.addSubview(backView)
        window?.bringSubviewToFront(backView)
        backView.show()
    }

    
    //MARK:Private Method
    override func setUI() {
        navigationItem.title = "确认订单"
        totalPriceLabel.text = "¥ " + (totalPrice ?? "")
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = GrayColorLevel5
        tableView.registerNib(UINib.nibName(String(WOWOrderAddressCell)), forCellReuseIdentifier:String(WOWOrderAddressCell))
        tableView.registerNib(UINib.nibName(String(WOWProductOrderCell)), forCellReuseIdentifier:String(WOWProductOrderCell))
        tableView.registerNib(UINib.nibName(String(WOWOrderFreightCell)), forCellReuseIdentifier:String(WOWOrderFreightCell))
        tableView.registerNib(UINib.nibName(String(WOWTipsCell)), forCellReuseIdentifier:String(WOWTipsCell))
        tableView.keyboardDismissMode = .OnDrag
 
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
    @IBAction func sureClick(sender: UIButton) {
        guard addressInfo != nil else {
            WOWHud.showMsg("请选择收货地址")
            return
        }
        if orderCode.isEmpty {
            switch entrance! {
            case editOrderEntrance.buyEntrance:
                requestBuyNowOrderCreat()
            case editOrderEntrance.carEntrance:
                requestOrderCreat()
            }

            chooseStyle()
        }

    }
    
    
    //MARK:Network
    override func request() {
        super.request()
        //请求地址数据
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_AddressDefault, successClosure: { [weak self](result) in
            if let strongSelf = self{
                strongSelf.addressInfo = Mapper<WOWAddressListModel>().map(result)
                let section = NSIndexSet(index: 0)
                strongSelf.tableView.reloadSections(section, withRowAnimation: .None)
            
            }
        }) { (errorMsg) in
            
        }
    }
    
    //请求商品列表
    func requestProduct() -> Void {
        WOWNetManager.sharedManager.requestWithTarget(.Api_OrderSettle, successClosure: { [weak self](result) in
            if let strongSelf = self {
                strongSelf.orderSettle = Mapper<WOWEditOrderModel>().map(result)
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
        WOWNetManager.sharedManager.requestWithTarget(.Api_OrderBuyNow(productId: productId ?? 0, productQty: productQty ?? 1), successClosure: { [weak self](result) in
            if let strongSelf = self {
                strongSelf.orderSettle = Mapper<WOWEditOrderModel>().map(result)
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
        var params = [String: AnyObject]?()
        if let endUserCouponId = couponModel?.id {
            params = ["shippingInfoId": (addressInfo?.id)!, "orderSource": 2, "orderAmount": (orderSettle?.totalAmount) ?? 0, "remark": tipsTextField.text ?? "", "endUserCouponId": endUserCouponId]
        }else {
            params = ["shippingInfoId": (addressInfo?.id)!, "orderSource": 2, "orderAmount": (orderSettle?.totalAmount) ?? 0, "remark": tipsTextField.text ?? ""]
        }
        
        WOWNetManager.sharedManager.requestWithTarget(.Api_OrderCreate(params: params), successClosure: { [weak self](result) in
            if let strongSelf = self {
                strongSelf.orderCode = JSON(result)["orderCode"].string ?? ""
            }
            
            }) { (errorMsg) in
                
        }
    }
    
    //立即支付创建订单
    func requestBuyNowOrderCreat() -> Void {
        var params = [String: AnyObject]?()
        if let endUserCouponId = couponModel?.id {
            params = ["productId": productId ?? 0, "productQty": productQty ?? 1, "shippingInfoId": (addressInfo?.id) ?? 0, "orderSource": 2, "orderAmount": (orderSettle?.totalAmount) ?? 0, "remark": tipsTextField.text ?? "", "endUserCouponId": endUserCouponId]
        }else {
            params = ["productId": productId ?? 0, "productQty": productQty ?? 1, "shippingInfoId": (addressInfo?.id) ?? 0, "orderSource": 2, "orderAmount": (orderSettle?.totalAmount) ?? 0, "remark": tipsTextField.text ?? ""]
        }
        
        WOWNetManager.sharedManager.requestWithTarget(.Api_OrderCreate(params: params), successClosure: { [weak self](result) in
            if let strongSelf = self {
                strongSelf.orderCode = JSON(result)["orderCode"].string ?? ""
            }
            
        }) { (errorMsg) in
            
        }
    }
    
    //去支付
    private func goPay(charge:AnyObject){
        dispatch_async(dispatch_get_main_queue()) {
            Pingpp.createPayment(charge as! NSObject, appURLScheme:WOWDSGNSCHEME) {[weak self] (ret, error) in
                if let strongSelf = self{
                    switch ret{
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
        WOWNetManager.sharedManager.requestWithTarget(.Api_PayResult(orderCode: orderCode), successClosure: { [weak self](result) in
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
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var returnCell:UITableViewCell?
        switch indexPath.section {
        case 0: //地址
            let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWOrderAddressCell), forIndexPath: indexPath) as! WOWOrderAddressCell
            cell.showData(addressInfo)
            returnCell = cell
        case 1: //商品清单
            let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWProductOrderCell), forIndexPath: indexPath) as! WOWProductOrderCell
            if let productArr = productArr {
                cell.showData(productArr[indexPath.row])
            }
            returnCell = cell
        case 2: //运费及优惠券信息
            let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWOrderFreightCell), forIndexPath: indexPath) as! WOWOrderFreightCell
            if indexPath.row == 0 {
                cell.leftLabel.text = "运费"
                let result = WOWCalPrice.calTotalPrice([self.orderSettle?.deliveryFee ?? 0],counts:[1])
                cell.freightPriceLabel.text = result
                cell.couponLabel.hidden = true
                cell.nextImage.hidden = true
                cell.freightPriceLabel.hidden = false
                cell.freightInfoImage.hidden = false
                cell.lineView.hidden = false
            }else {
                cell.leftLabel.text = "优惠券"
                cell.freightPriceLabel.hidden = true
                cell.freightInfoImage.hidden = true
                cell.nextImage.hidden = false
                cell.couponLabel.hidden = false
                cell.lineView.hidden = true
                let result = WOWCalPrice.calTotalPrice([self.orderSettle?.deduction ?? 0],counts:[1])
                cell.couponLabel.text = "-" + result
            }
            returnCell = cell
        case 3: //订单备注
            let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWTipsCell), forIndexPath:indexPath) as! WOWTipsCell
            tipsTextField = cell.textField
            returnCell = cell
        default:
            break
        }
        return returnCell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section, indexPath.row ){
        case (0, 0):
            
            let vc = UIStoryboard.initialViewController("User", identifier:String(WOWAddressController)) as! WOWAddressController
            vc.entrance = WOWAddressEntrance.SureOrder
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
                        
                        let section = NSIndexSet(index: 2)
                        strongSelf.tableView.reloadSections(section, withRowAnimation: .None)
                        
                        //重新计算总金额
                        let productTotal = NSDecimalNumber(double: strongSelf.orderSettle?.productTotalAmount ?? 0)
                        let delivery = NSDecimalNumber(double: strongSelf.orderSettle?.deliveryFee ?? 0)
                        let deduction = NSDecimalNumber(double: couponInfo?.deduction ?? 0)
                        
                        strongSelf.orderSettle?.totalAmount = (productTotal.decimalNumberByAdding(delivery).decimalNumberBySubtracting(deduction)).doubleValue
                        
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
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return 0.01
        default:
            return 15
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
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
    func surePay(channel: String) {
        backView.hidePayView()
        if  orderCode.isEmpty {
            WOWHud.showMsg("订单生成失败")
        }
        WOWNetManager.sharedManager.requestWithTarget(.Api_OrderCharge(orderNo: orderCode ?? "", channel: channel, clientIp: IPManager.sharedInstance.ip_public), successClosure: { [weak self](result) in
            if let strongSelf = self {
                let json = JSON(result)
                let charge = json["charge"]
                strongSelf.goPay(charge.object)
            }
            
            }) { (errorMsg) in
                
        }
    }
    
    func canclePay() {
        if  orderCode.isEmpty {
            WOWHud.showMsg("订单生成失败")
        }
        goOrderDetail()
    }

}

