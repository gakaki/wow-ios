//
//  WOWOrderDetailController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/16.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit


enum orderDetailEntrance {
    case orderList
    case orderPay
}
enum OrderNewType {
    case payMent             //= "待付款"
    
    case forGoods            //= "待收货"
    
    case noForGoods          //= "待发货" ／"订单关闭" / "已经取消"
    
    case finish              //= "已完成"
    
    case someFinishForGoods  //= "部分完成"
}
enum PayType {
    case none                //= 无
    
    case payAli              //= 支付宝
    
    case payWiXin            //= 微信

}
protocol OrderDetailDelegate:class{
    func orderStatusChange()
}

struct CellHight {
    /// hight : 70
    static var ProductCellHight : CGFloat        = 70
    /// hight : 60
    static var PayCellHight     : CGFloat        = 60
    /// hight : 50
    static var CourceHight      : CGFloat        = 50
    /// hight : 0.01
    static var minHight         : CGFloat        = 0.01
    /// hight : 40
    static var fooderHight      : CGFloat        = 40
}
class WOWOrderDetailController: WOWBaseViewController{

    var orderNewModel               : WOWNewOrderListModel?
    
    var orderNewDetailModel         : WOWNewOrderDetailModel?
    
    var surePayType                 : PayType = .none
    
    var OrderDetailNewaType         : OrderNewType = .someFinishForGoods
    ///  : 存放包裹的数组
    var goodsArray = [WOWNewForGoodsModel]()
    ///  : 未发货商品清单
    var goodsNoArray = [WOWNewProductModel]()
    ///  : 部分发货：发货清单的 产品 的数量
    var orderGoodsNumber                 : Int!

    ///  : 未发货清单的的包裹商品个数
    var orderNoNumber                 : Int! // 测试数据 未发货清单的的包裹商品个数

    var isOpen                      : Bool!
    
    var isSomeForGoodsType          : Bool! // 记录是否是 部分发货 的布局。 区分页眉上 标题不同
    
    
    @IBOutlet weak var tableView    : UITableView!
    @IBOutlet weak var countLabel   : UILabel!
    @IBOutlet weak var priceLabel   : UILabel!
    @IBOutlet weak var rightButton  : UIButton!
    @IBOutlet weak var clooseOrderButton  : UIButton!
    var statusLabel                 : UILabel!
    var orderCode                   : String!
    var entrance                    = orderDetailEntrance.orderList
    
    weak var delegate               : OrderDetailDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK:Private Method
    override func setUI() {
        super.setUI()
        
        orderNoNumber        = 0
        orderGoodsNumber     = 0
        isSomeForGoodsType   = true
        isOpen               = true

        request()
        WOWBorderColor(rightButton)
        navigationItem.title = "订单详情"
        configTableView()
        configBarItem()
        
    }
    fileprivate func configBarItem(){
        
        
        makeCustomerImageNavigationItem("telephonekefu", left:false) { () -> () in
//            if let strongSelf = self{

                WOWTool.callPhone()
                DLog("你点击了客服")
//            }
        }
    }
    override func navBack() {
        switch entrance {
        case .orderPay:
//            let vc = UIStoryboard.initialViewController("User", identifier: "WOWOrderController") as! WOWOrderController
            let vc = WOWOrderListViewController()
            vc.entrance = orderDetailEntrance.orderPay
            navigationController?.pushViewController(vc, animated: true)
        default:
            popVC()
        }
    }
    
    fileprivate func configTableView(){
        tableView.clearRestCell()
        tableView.backgroundColor = DefaultBackColor
        tableView.estimatedRowHeight = 70
        tableView.register(UINib.nibName("WOWOrderDetailNewCell"), forCellReuseIdentifier: "WOWOrderDetailNewCell")
        tableView.register(UINib.nibName("WOWOrderDetailTwoCell"), forCellReuseIdentifier: "WOWOrderDetailTwoCell")
        tableView.register(UINib.nibName("WOWOrderDetailSThreeCell"), forCellReuseIdentifier: "WOWOrderDetailSThreeCell")
        tableView.register(UINib.nibName("WOWOrderDetailCostCell"), forCellReuseIdentifier: "WOWOrderDetailCostCell")
        tableView.register(UINib.nibName("WOWOrderDetailPayCell"), forCellReuseIdentifier: "WOWOrderDetailPayCell")
        tableView.clearRestCell()
    }
    // 取消订单
    @IBAction func clooseOrderButtonClick(_ sender: UIButton) {
        func clooseOrder(){
            WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_OrderCancel(orderCode: orderCode), successClosure: { [weak self](result) in
                if let strongSelf = self{
                    //取消订单成功后重新请求下网络刷新列表
                    strongSelf.request()
                    strongSelf.delegate?.orderStatusChange()
                    NotificationCenter.postNotificationNameOnMainThread(WOWUpdateOrderListAllNotificationKey, object: nil)
                }
            }) { (errorMsg) in
                
            }
        }

        let alert = UIAlertController(title:"确定取消订单吗？", message:nil, preferredStyle:.actionSheet)
        let cancel = UIAlertAction(title: "再看看", style: .cancel, handler: nil)
        let sure = UIAlertAction(title: "确定取消", style: .default) { (action) in

           clooseOrder()
            
        }
        alert.addAction(cancel)
        alert.addAction(sure)
        present(alert, animated: true, completion: nil)


    }
    // 右边点击按钮
    @IBAction func rightButtonClick(_ sender: UIButton) {
        
        if let orderNewModel = orderNewDetailModel {
        switch orderNewModel.orderStatus!  {
            case 0:// 立即支付
                
                switch surePayType {
                case .payAli:
                    sureOrderPay("alipay")
                case .payWiXin:
                    sureOrderPay("wx")
                default:
                    WOWHud.showMsg("请选择支付方式")
                    break
                }
            
            case 3:// 确认收货
                
                confirmReceive(orderNewModel.orderCode!)
                
            default:
                break
            }
        }

    }
 
    /**
     隐藏右边按钮
     */
    func hideRightBtn() {
        self.rightButton.isHidden       = true
        self.clooseOrderButton.isHidden = true
        if let orderNewModel          = orderNewDetailModel {
            
            let result = WOWCalPrice.calTotalPrice([orderNewModel.orderAmount ?? 0],counts:[1])
            self.priceLabel.text          = result
        }
        
    }
    /**
     *  区分订单类型 UI
     */
    func orderType(_ OrderDetailModel:WOWNewOrderDetailModel?) {
        if let orderNewModel = OrderDetailModel {
            
           
            switch orderNewModel.orderStatus!  {
            case 0:
                self.OrderDetailNewaType          = OrderNewType.payMent
                self.rightButton.setTitle("立即支付", for: UIControlState())
                
                let result = WOWCalPrice.calTotalPrice([orderNewModel.orderAmount ?? 0],counts:[1])
                self.priceLabel.text          = result
                
            case 1,5,6:
                self.OrderDetailNewaType = OrderNewType.noForGoods
                hideRightBtn()
            case 4:
                self.OrderDetailNewaType = OrderNewType.finish
                if orderNewModel.packages?.count > 1 { // 如果大于1， 说明有不多个包裹的订单 则 换UI界面
                    self.OrderDetailNewaType          = OrderNewType.someFinishForGoods
                    isSomeForGoodsType = false
                }
                hideRightBtn()
                
            case 2:
                self.OrderDetailNewaType = OrderNewType.someFinishForGoods
                
                hideRightBtn()
                
                
            case 3:
                self.OrderDetailNewaType          = OrderNewType.forGoods
                self.clooseOrderButton.isHidden     = true
                self.rightButton.setTitle("确认收货", for: UIControlState())
                let result = WOWCalPrice.calTotalPrice([orderNewModel.orderAmount ?? 0],counts:[1])
                self.priceLabel.text          = result

                if orderNewModel.packages?.count > 1 {// 如果大于1， 说明有不多个包裹的订单 则 换UI界面
                     self.OrderDetailNewaType          = OrderNewType.someFinishForGoods
                    isSomeForGoodsType = false
                }
            default:
                break
            }
        }
    }
    /**
     拿到 定制tableView 所需要的数据
     */
    func getOrderData(){
        switch OrderDetailNewaType {
        case .forGoods,.finish:
            /// 拿出发货的商品数组
            if  let forGoodsArr = self.orderNewDetailModel?.packages {
                self.goodsArray = forGoodsArr

                self.orderGoodsNumber = forGoodsArr[0].orderItems?.count > 3 ? 3 : forGoodsArr[0].orderItems?.count
                
                
            }
            
            
        case .payMent,.noForGoods:
            
            /// 拿出未发货的商品数组
            if  let noForGoodsArr = self.orderNewDetailModel?.unShipOutOrderItems {
                self.orderNoNumber = noForGoodsArr.count > 3 ? 3 : noForGoodsArr.count
                
                
            }
            
            
        default:
            /// 拿出发货的商品数组
            if  let forGoodsArr = self.orderNewDetailModel?.packages {
                self.goodsArray = forGoodsArr
              
                self.orderGoodsNumber = forGoodsArr[0].orderItems?.count > 3 ? 3 : forGoodsArr[0].orderItems?.count
                
            }
            
            /// 拿出未发货的商品数组
            if  let noForGoodsArr = self.orderNewDetailModel?.unShipOutOrderItems {
                self.goodsNoArray = noForGoodsArr
                
                self.orderNoNumber = noForGoodsArr.count
                
            }
            
        }
        
    }
    
    //确认收货
    fileprivate func confirmReceive(_ orderCode:String){
        func confirm(){
            WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_OrderConfirm(orderCode: orderCode), successClosure: { [weak self](result) in
                if let strongSelf = self{
                    //确认收货成功后重新请求下网络刷新列表
                    strongSelf.request()
                    strongSelf.delegate?.orderStatusChange()
                     NotificationCenter.postNotificationNameOnMainThread(WOWUpdateOrderListAllNotificationKey, object: nil)
                }
            }) { (errorMsg) in
                
            }
        }
        
        let alert = UIAlertController(title:"确认收货", message:nil, preferredStyle:.alert)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let sure = UIAlertAction(title: "确定", style: .default) { (action) in
            confirm()
        }
        
        alert.addAction(cancel)
        alert.addAction(sure)
        present(alert, animated: true, completion: nil)
    }

    //MARK:Network
    override func request() {
        
        
        super.request()
        
//        orderType()
        
                isOpen = true // 默认 不展开
            WOWNetManager.sharedManager.requestWithTarget(.api_OrderDetail(OrderCode:self.orderCode!), successClosure: { [weak self](result) in
                let json = JSON(result)
                DLog(json)
                if let strongSelf = self{
                    
                    strongSelf.orderNewDetailModel = Mapper<WOWNewOrderDetailModel>().map(JSONObject:result)
                    strongSelf.orderCode =  strongSelf.orderNewDetailModel!.orderCode
                    
                    strongSelf.orderType(strongSelf.orderNewDetailModel)
                    
                    strongSelf.getOrderData()
                
                    strongSelf.tableView.reloadData()
                }
            }) { (errorMsg) in
                
            }
            
        }
}
// MARK: - 订单支付相关
extension WOWOrderDetailController{
    
    func sureOrderPay(_ channl: String){
        if let orderNewModel = self.orderNewDetailModel {
            
            //    backView.hidePayView()
            if  orderNewModel.orderCode!.isEmpty {
                WOWHud.showMsg("订单不存在")
                return
            }

            WOWNetManager.sharedManager.requestWithTarget(.api_OrderCharge(orderNo: self.orderCode ?? "", channel: channl, clientIp: IPManager.sharedInstance.ip_public), successClosure: { [weak self](result) in
                if let strongSelf = self {
                    let json = JSON(result)
                    let charge = json["charge"]
                    strongSelf.goPay(charge.object as AnyObject)
                }
                
            }) { (errorMsg) in
                
            }
        }
        
    }
    //去支付
    fileprivate func goPay(_ charge:AnyObject){
        DispatchQueue.main.async {
            Pingpp.createPayment(charge as! NSObject, appURLScheme:WOWDSGNSCHEME) {[weak self] (ret, error) in
                if let strongSelf = self  , let ret_str = ret as String! {
                    switch ret_str{
                    case "success":
                        strongSelf.requestPayResult()
                    case "cancel":
                        WOWHud.showMsg("支付取消")
                        
                        break
                    default:
                        WOWHud.showMsg("支付失败")
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
                strongSelf.request() // 更新最新状态
                strongSelf.delegate?.orderStatusChange()
                 NotificationCenter.postNotificationNameOnMainThread(WOWUpdateOrderListAllNotificationKey, object: nil)
                
                
                let json = JSON(result)
                let orderCode = json["orderCode"].string
                let payAmount = json["payAmount"].double
                let paymentChannelName = json["paymentChannelName"].string
                let vc = UIStoryboard.initialViewController("BuyCar", identifier:"WOWPaySuccessController") as! WOWPaySuccessController
                vc.payMethod = paymentChannelName ?? ""
                vc.orderid = orderCode ?? ""
                vc.totalPrice = "¥ " + String(format: "%.2f",payAmount ?? 0)
                strongSelf.navigationController?.pushViewController(vc, animated: true)
                
                
                
                //TalkingData 支付成功
                var sum                  = Int32( payAmount ?? 0  )
                sum                      = sum * 100
                let order_id             = orderCode ?? ""
                TalkingDataAppCpa.onOrderPaySucc( WOWUserManager.userID, withOrderId: order_id, withAmount: sum, withCurrencyType: "CNY", withPayType: paymentChannelName)
                
                
            }
            
        }) { (errorMsg) in
            
        }
    }
    

}

// MARK: - UITableViewDelegate,UITableViewDataSource
extension WOWOrderDetailController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        switch OrderDetailNewaType {
        case .payMent:
            return 5
        case .forGoods,.noForGoods,.finish:
            return 4
        case .someFinishForGoods:
//            return 3 + goodsNoArray.count + goodsArray.count
            return 4 + goodsArray.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch OrderDetailNewaType {
        case .payMent:
            switch section {
            case 0: //订单
                return 1
                
            case 1: //收货人
                return 1
            case 2: //商品清单  如果大于三个商品隐藏
              
                return orderNoNumber
                
            case 3: //运费
                return 2
            case 4: //支付方式
                return 2
            default:
                return 1
            }
        case .forGoods:
            switch section {
            case 0: //订单 订单信息 or 派送信息
                
                return 2
                
            case 1: //收货人
                return 1
            case 2: //商品清单  如果大于三个商品隐藏
                
                return self.orderGoodsNumber
                
            case 3: //运费
                return 2
            default:
                return 1
            }
        case .noForGoods:
            switch section {
            case 0: //订单
                
                return 1
                
            case 1: //收货人
                return 1
            case 2: //商品清单  如果大于三个商品隐藏
              
                return orderNoNumber
            
                
            case 3: //运费
                return 2
            default:
                return 1
            }
        case .finish:
            switch section {
            case 0: //订单
                
                return 1
                
            case 1: //收货人
                return 1
            case 2: //商品清单  如果大于三个商品隐藏
               
                return self.orderGoodsNumber
          
            case 3: //运费
                return 2
            default:
                return 1
            }
            
            
        case .someFinishForGoods:
            
            switch section {
            case 0:
                return 1
            case 1:
                return 1
            case goodsArray.count + 2 :
                switch goodsNoArray.count {
                case 0:
                    return 0
                default:
                    return orderNoNumber
                }
                
            case goodsArray.count + 3 :
                return 2
            default:
                
                let goods : WOWNewForGoodsModel = goodsArray[section - 2]
                
                return goods.orderItems!.count + 1
                
            }
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch OrderDetailNewaType {
        case .payMent:
            switch (indexPath as NSIndexPath).section {
            case 3:
                return CellHight.CourceHight
            case 4:
                return CellHight.PayCellHight
            default:
                return CellHight.ProductCellHight
            }
            
        case .forGoods,.noForGoods,.finish:
            switch (indexPath as NSIndexPath).section {
                
            case 3:
                return CellHight.CourceHight
            default:
                return CellHight.ProductCellHight
            }
        case .someFinishForGoods:
            switch (indexPath as NSIndexPath).section {
                
            case goodsArray.count + 3 :
                return CellHight.CourceHight
            default:
                
                return CellHight.ProductCellHight
            }
            
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell:UITableViewCell!
        switch OrderDetailNewaType {
        case .payMent:
            switch (indexPath as NSIndexPath).section {
            case 0:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "WOWOrderDetailTwoCell", for: indexPath) as! WOWOrderDetailTwoCell
                
                if let orderNewDetailModel = orderNewDetailModel{
                    
                    cell.showData(orderNewDetailModel)
                    
                    
                }
                
                returnCell = cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "WOWOrderDetailSThreeCell", for: indexPath) as! WOWOrderDetailSThreeCell
                if let orderNewDetailModel = orderNewDetailModel{
                    
                    cell.showData(orderNewDetailModel)
                    
                }
                
                returnCell = cell
                
            case 2:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "WOWOrderDetailNewCell", for: indexPath) as! WOWOrderDetailNewCell
                if let orderNewDetailModel = orderNewDetailModel {
                    
                    cell.showData(orderNewDetailModel,indexRow: (indexPath as NSIndexPath).row)
                    
                }
                
                
                returnCell = cell
                
            case 3:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "WOWOrderDetailCostCell", for: indexPath) as! WOWOrderDetailCostCell
                if let orderNewDetailModel = orderNewDetailModel {
                    
                    cell.showUI(orderNewDetailModel, indexPath: indexPath)
                    
                    
                }
                returnCell = cell
            case 4:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "WOWOrderDetailPayCell", for: indexPath) as! WOWOrderDetailPayCell
                if (indexPath as NSIndexPath).row == 0 {
                    cell.payTypeImageView.image  = UIImage(named: "alipay")

                    cell.payTypeLabel.text       = "支付宝"
                    switch surePayType {
                        
                    case PayType.payAli:
                        cell.isClooseImageView.image = UIImage(named: "select")
                    default:
                        cell.isClooseImageView.image = UIImage(named: "car_check")
                    }

                }
                if (indexPath as NSIndexPath).row == 1 {
                    cell.payTypeImageView.image = UIImage(named: "weixin")
                    cell.payTypeLabel.text      = "微信支付"
                    switch surePayType {
                    case PayType.payWiXin:
                        cell.isClooseImageView.image = UIImage(named: "select")
                    default:
                        cell.isClooseImageView.image = UIImage(named: "car_check")
                    }

                }
                
                returnCell = cell
                
            default:
                break
            }
            
        case .forGoods,.noForGoods,.finish:
            switch (indexPath as NSIndexPath).section {
            case 0:
                if (indexPath as NSIndexPath).row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "WOWOrderDetailTwoCell", for: indexPath) as! WOWOrderDetailTwoCell
                    
                    if let orderNewDetailModel = orderNewDetailModel{
                        
                        cell.showData(orderNewDetailModel)
                        
                    }
                    
                    returnCell = cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "WOWOrderDetailSThreeCell", for: indexPath) as! WOWOrderDetailSThreeCell
                    if let orderNewDetailModel = orderNewDetailModel {
                        
                        cell.personNameLabel.text = "由 " + orderNewDetailModel.packages![(indexPath as NSIndexPath).section].deliveryCompanyName! + " 派送中"
                        cell.addressLabel.text    = "运单号：" + orderNewDetailModel.packages![(indexPath as NSIndexPath).section].deliveryOrderNo!
                        
                    }
                    returnCell = cell
                    
                }
                
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "WOWOrderDetailSThreeCell", for: indexPath) as! WOWOrderDetailSThreeCell
                
                if let orderNewDetailModel = orderNewDetailModel{
                    
                    cell.showData(orderNewDetailModel)
                    
                }
                

                returnCell = cell
                
            case 2:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "WOWOrderDetailNewCell", for: indexPath) as! WOWOrderDetailNewCell
                if let orderNewDetailModel = orderNewDetailModel {
                    
                    
                    switch OrderDetailNewaType {
                    case .forGoods,.finish:
                        cell.showPackages(orderNewDetailModel, indexSection: (indexPath as NSIndexPath).section - 2, indexRow: (indexPath as NSIndexPath).row)
                        
                    default:
                        cell.showData(orderNewDetailModel,indexRow: (indexPath as NSIndexPath).row)
                    }
                    
                }
                
                returnCell = cell
                
            case 3:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "WOWOrderDetailCostCell", for: indexPath) as! WOWOrderDetailCostCell
                if let orderNewDetailModel = orderNewDetailModel {
                    
                    cell.showUI(orderNewDetailModel, indexPath: indexPath)
                    
                }
                
                returnCell = cell
                
            default:
                break
            }
        case .someFinishForGoods:
            
            
            switch (indexPath as NSIndexPath).section {
            case 0:
                let cell   = tableView.dequeueReusableCell(withIdentifier: "WOWOrderDetailTwoCell", for: indexPath) as! WOWOrderDetailTwoCell
                
                if let orderNewDetailModel = orderNewDetailModel{
                    
                    cell.showData(orderNewDetailModel)
                    
                    
                }
                
                returnCell = cell
            case 1:
                let cell   = tableView.dequeueReusableCell(withIdentifier: "WOWOrderDetailSThreeCell", for: indexPath) as! WOWOrderDetailSThreeCell
                if let orderNewDetailModel = orderNewDetailModel{
                    
                    cell.showData(orderNewDetailModel)
                    
                }
                
                returnCell = cell
            case goodsArray.count + 2 :
                let cell = tableView.dequeueReusableCell(withIdentifier: "WOWOrderDetailNewCell", for: indexPath) as! WOWOrderDetailNewCell
                if let orderNewDetailModel = orderNewDetailModel {
                    
                    cell.showData(orderNewDetailModel,indexRow: (indexPath as NSIndexPath).row)
                    
                }
                
                returnCell = cell
            case goodsArray.count + 3 :
                let cell = tableView.dequeueReusableCell(withIdentifier: "WOWOrderDetailCostCell", for: indexPath) as! WOWOrderDetailCostCell
                if let orderNewDetailModel = orderNewDetailModel {
                    
                    cell.showUI(orderNewDetailModel, indexPath: indexPath)
                    
                }
                
                returnCell = cell
                
                
            default:
                
                if (indexPath as NSIndexPath).row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "WOWOrderDetailSThreeCell", for: indexPath) as! WOWOrderDetailSThreeCell
                    if let orderNewDetailModel = orderNewDetailModel {
                        
                        cell.personNameLabel.text = "包裹" + ((indexPath as NSIndexPath).section - 1).toString + "：" + orderNewDetailModel.packages![indexPath.section - 2].deliveryCompanyName!
                        cell.addressLabel.text    = "运单号：" + orderNewDetailModel.packages![(indexPath as NSIndexPath).section - 2].deliveryOrderNo!
                        
                    }
                    
                    returnCell = cell
                    
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "WOWOrderDetailNewCell", for: indexPath) as! WOWOrderDetailNewCell
                    
                    if let orderNewDetailModel = orderNewDetailModel {
                        
                        cell.showPackages(orderNewDetailModel,indexSection:(indexPath as NSIndexPath).section - 2 , indexRow:(indexPath as NSIndexPath).row - 1)
                        
                    }
                    
                    returnCell = cell
                }
            }
            
        }
        
        returnCell.selectionStyle = .none
        return returnCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        switch (indexPath as NSIndexPath).section {
        case 4:
            switch (indexPath as NSIndexPath).row {
            case 0:

                switch surePayType {
                case .payAli:
                    self.surePayType = PayType.none
                default:
                    self.surePayType = PayType.payAli
                }
                
               

            case 1:
                switch surePayType {
                case .payWiXin:
                    self.surePayType = PayType.none
                default:
                    self.surePayType = PayType.payWiXin
                }

            default:
                break
            }
            tableView.reloadData()
        default:
            break
        }
    }
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch OrderDetailNewaType {
        case .someFinishForGoods:
            
            switch section {
            case 0:
                return CellHight.minHight
            case 1 , 2:
                return 38
                
            case goodsArray.count + 2:
                switch goodsNoArray.count {
                case 0:
                    return 0.01
                default:
                    return 38
                }
                
            case goodsArray.count + 3 :
                return 12
            default:
                return 12
            }
            
            
        default:
            switch section {
            case 0:
                return CellHight.minHight
            case 3:
                return 12
            default:
                return 38
            }
            
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        switch OrderDetailNewaType {
        case .payMent:
            let titles = [" ","收货人","商品清单","","支付方式"]
            let heights = [CellHight.minHight,38,38,12,38]
            return headerSectionView(titles[section], headetHeight: heights[section])

        case .forGoods,.noForGoods,.finish:
            let titles = [" ","收货人","商品清单",""]
            let heights = [CellHight.minHight,38,38,12]
            return headerSectionView(titles[section], headetHeight: heights[section])
        case .someFinishForGoods:
            
            switch section {
            case 0:
                return headerSectionView(" ", headetHeight: CellHight.minHight)
            case 1:
                return headerSectionView("收货人", headetHeight: 38)
            case 2:
                if isSomeForGoodsType == true {
                    return headerSectionView("已发货商品清单", headetHeight: 38)
                }else{
                    return headerSectionView("商品清单", headetHeight: 38)
                }
                
            case goodsArray.count + 2:
                
                switch goodsNoArray.count {
                case 0:
                    return headerSectionView(" ", headetHeight: CellHight.minHight)
                default:
                    return headerSectionView("未发货商品清单", headetHeight: 38)
                }
                
                
            default:
                return headerSectionView(" ", headetHeight: 12)
            }
            
            
        }
        

    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        
        switch OrderDetailNewaType {
        case .someFinishForGoods:

            return CellHight.minHight
            
            
        default:
            if let orderNewDetailModel = orderNewDetailModel {
                switch OrderDetailNewaType {
                case .payMent,.noForGoods:
                    guard orderNewDetailModel.unShipOutOrderItems!.count > 3 else {
                        return CellHight.minHight
                    }
                    
                case .forGoods,.finish:
                    
                    guard orderNewDetailModel.packages![0].orderItems!.count > 3 else {
                        return CellHight.minHight
                    }
                    
                default:
                    break
                }
                
                if section == 2 {
                    return CellHight.fooderHight
                }
                return CellHight.minHight
            }else{
                return CellHight.minHight
            }
        }
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        switch OrderDetailNewaType {
        case .someFinishForGoods:
           
            return nil
            
        default:
            if let orderNewDetailModel = orderNewDetailModel {
                switch OrderDetailNewaType {
                case .payMent,.noForGoods:
                    guard orderNewDetailModel.unShipOutOrderItems!.count > 3 else {
                        return nil
                    }
                    
                case .forGoods,.finish:
                    
                    guard orderNewDetailModel.packages![0].orderItems!.count > 3 else {
                        return nil
                    }
                    
                default:
                    break
                }

                if section == 2 {
                    return footSectionView(section)
                }
                return nil
                
            }else{
                return nil
            }
            
        }
        
    }
    // 页眉View
    func headerSectionView(_ headerTitle:String,headetHeight:CGFloat) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: MGScreenWidth, height: headetHeight)
        view.backgroundColor = GrayColorLevel5
        let lbTitle = UILabel()
        lbTitle.backgroundColor = GrayColorLevel5
        lbTitle.frame = CGRect(x: 15, y: 0, width: MGScreenWidth, height: headetHeight)
        lbTitle.textColor = GrayColorlevel3
        lbTitle.text = headerTitle
        lbTitle.font = UIFont.systemFont(ofSize: 12)
        
        view.addSubview(lbTitle)
        
        return view
    }
     // 页脚View
    func footSectionView(_ indexPathSetion:Int) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: MGScreenWidth, height: 40)
        view.backgroundColor = UIColor.white
        let viewTopLine = UIView()
        viewTopLine.backgroundColor = BorderMColor
        viewTopLine.frame = CGRect(x: 0, y: 0, width: MGScreenWidth, height: 0.5)
        view.addSubview(viewTopLine)
        
        let likeButton = UIButton(type: .system)
        likeButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        likeButton.center = view.center
        likeButton.centerX = view.centerX - 10
        likeButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        likeButton.setTitleColor(GrayColorlevel3, for: .normal)
        var totalNum : String?
        
        switch OrderDetailNewaType {
        case .payMent,.noForGoods: // 相对应的取的数组不一样
            if  let noForGoodsArr = self.orderNewDetailModel?.unShipOutOrderItems {
                
                totalNum = "共" + noForGoodsArr.count.toString + "件"
                
            }
            
        case .forGoods,.finish:
            if  let forGoodsArr = self.orderNewDetailModel?.packages![0].orderItems {
                
                totalNum = "共" + forGoodsArr.count.toString + "件"
                
            }

        default:
            break
            
        }
        
        likeButton.setTitle(totalNum, for: UIControlState())
        
        if isOpen == true {
            likeButton.setImage(UIImage(named: "downOrder")?.withRenderingMode(.alwaysOriginal), for: UIControlState())
        }else{
            likeButton.setImage(UIImage(named: "topOrder")?.withRenderingMode(.alwaysOriginal), for: UIControlState())
        }
        
        likeButton.imageEdgeInsets = UIEdgeInsetsMake(10, 70, 10, 10)
        likeButton.addTarget(self, action: #selector(clickAction(_:)), for: .touchUpInside)
        likeButton.tag = indexPathSetion
        view.addSubview(likeButton)
        
        
        return view
        
    }
     func clickAction(_ sender:UIButton)  {
        
        
        switch OrderDetailNewaType {
        case .someFinishForGoods:
            print("")
            
        case .payMent,.noForGoods:
            
            if isOpen == true {
                
                if  let noForGoodsArr = self.orderNewDetailModel?.unShipOutOrderItems {
                    self.orderNoNumber = noForGoodsArr.count
                }
                
                isOpen = false
            }else{
                
                if  let noForGoodsArr = self.orderNewDetailModel?.unShipOutOrderItems {
                    self.orderNoNumber = noForGoodsArr.count > 3 ? 3 : noForGoodsArr.count
                }
                
                isOpen = true
            }
            
            
            
        case .forGoods,.finish:
            if isOpen == true {
                if  let forGoodsArr = self.orderNewDetailModel?.packages![0].orderItems {
                    self.orderGoodsNumber = forGoodsArr.count
                }
                
                isOpen = false
            }else{
                if  let forGoodsArr = self.orderNewDetailModel?.packages![0].orderItems {
                    self.orderGoodsNumber = forGoodsArr.count > 3 ? 3 : forGoodsArr.count
                }
                
                isOpen = true
            }

        }
        
        // 刷新单独一组
        let indexSet = IndexSet.init(integer: sender.tag)
        
        tableView.reloadSections(indexSet, with: UITableViewRowAnimation.automatic)

        
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = MGRgb(109, g: 109, b: 114)
            headerView.textLabel?.font = Fontlevel003
        }
    }
}
