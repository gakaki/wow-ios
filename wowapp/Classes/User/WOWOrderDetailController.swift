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
    
    var isSomeForGoodsType          : Bool!
    
    
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
    private func configBarItem(){
        
        
        makeCustomerImageNavigationItem("telephonekefu", left:false) {[weak self] () -> () in
//            if let strongSelf = self{

                WOWTool.callPhone()
                print("你点击了客服")
//            }
        }
    }
    override func navBack() {
        switch entrance {
        case .orderPay:
            let vc = UIStoryboard.initialViewController("User", identifier: "WOWOrderController") as! WOWOrderController
            vc.entrance = orderDetailEntrance.orderPay
            navigationController?.pushViewController(vc, animated: true)
        default:
            popVC()
        }
    }
    
    private func configTableView(){
        tableView.clearRestCell()
        tableView.backgroundColor = DefaultBackColor
        tableView.estimatedRowHeight = 70
        tableView.registerNib(UINib.nibName("WOWOrderDetailNewCell"), forCellReuseIdentifier: "WOWOrderDetailNewCell")
        tableView.registerNib(UINib.nibName("WOWOrderDetailTwoCell"), forCellReuseIdentifier: "WOWOrderDetailTwoCell")
        tableView.registerNib(UINib.nibName("WOWOrderDetailSThreeCell"), forCellReuseIdentifier: "WOWOrderDetailSThreeCell")
        tableView.registerNib(UINib.nibName("WOWOrderDetailCostCell"), forCellReuseIdentifier: "WOWOrderDetailCostCell")
        tableView.registerNib(UINib.nibName("WOWOrderDetailPayCell"), forCellReuseIdentifier: "WOWOrderDetailPayCell")
        tableView.clearRestCell()
    }
    
    @IBAction func clooseOrderButtonClick(sender: UIButton) {
        func clooseOrder(){
            WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_OrderCancel(orderCode: orderCode), successClosure: { [weak self](result) in
                if let strongSelf = self{
                    //取消订单成功后重新请求下网络刷新列表
                    strongSelf.request()
                }
            }) { (errorMsg) in
                
            }
        }

        let alert = UIAlertController(title:"确定取消订单吗？", message:nil, preferredStyle:.ActionSheet)
        let cancel = UIAlertAction(title: "再看看", style: .Cancel, handler: nil)
        let sure = UIAlertAction(title: "确定取消", style: .Default) { (action) in

           clooseOrder()
            
        }
        alert.addAction(cancel)
        alert.addAction(sure)
        presentViewController(alert, animated: true, completion: nil)


    }
    @IBAction func rightButtonClick(sender: UIButton) {
        
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
        self.rightButton.hidden       = true
        self.clooseOrderButton.hidden = true
        if let orderNewModel          = orderNewDetailModel {
            
            let result = WOWCalPrice.calTotalPrice([orderNewModel.orderAmount ?? 0],counts:[1])
            self.priceLabel.text          = result
        }
        
    }
    /**
     *  区分订单类型 UI
     */
    func orderType(OrderDetailModel:WOWNewOrderDetailModel?) {
        if let orderNewModel = OrderDetailModel {
            
           
            switch orderNewModel.orderStatus!  {
            case 0:
                self.OrderDetailNewaType          = OrderNewType.payMent
                self.rightButton.setTitle("立即支付", forState: UIControlState.Normal)
                
                let result = WOWCalPrice.calTotalPrice([orderNewModel.orderAmount ?? 0],counts:[1])
                self.priceLabel.text          = result
                
            case 1,5,6:
                self.OrderDetailNewaType = OrderNewType.noForGoods
                hideRightBtn()
            case 4:
                self.OrderDetailNewaType = OrderNewType.finish
                if orderNewModel.packages?.count > 1 {
                    self.OrderDetailNewaType          = OrderNewType.someFinishForGoods
                    isSomeForGoodsType = false
                }
                hideRightBtn()
                
            case 2:
                self.OrderDetailNewaType = OrderNewType.someFinishForGoods
                
                hideRightBtn()
                
                
            case 3:
                self.OrderDetailNewaType          = OrderNewType.forGoods
                self.clooseOrderButton.hidden     = true
                self.rightButton.setTitle("确认收货", forState: UIControlState.Normal)
                let result = WOWCalPrice.calTotalPrice([orderNewModel.orderAmount ?? 0],counts:[1])
                self.priceLabel.text          = result

                if orderNewModel.packages?.count > 1 {
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
    private func confirmReceive(orderCode:String){
        func confirm(){
            WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_OrderConfirm(orderCode: orderCode), successClosure: { [weak self](result) in
                if let strongSelf = self{
                    //确认收货成功后重新请求下网络刷新列表
                    strongSelf.request()
                    strongSelf.delegate?.orderStatusChange()
                }
            }) { (errorMsg) in
                
            }
        }
        
        let alert = UIAlertController(title:"确认收货", message:nil, preferredStyle:.Alert)
        let cancel = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let sure = UIAlertAction(title: "确定", style: .Default) { (action) in
            confirm()
        }
        
        alert.addAction(cancel)
        alert.addAction(sure)
        presentViewController(alert, animated: true, completion: nil)
    }

    //MARK:Network
    override func request() {
        
        
        super.request()
        
//        orderType()
        
        isOpen = true
        
//        if let orderNewModel = orderNewModel {
        
            WOWNetManager.sharedManager.requestWithTarget(.Api_OrderDetail(OrderCode:self.orderCode!), successClosure: { [weak self](result) in
                
                if let strongSelf = self{
                    
                    strongSelf.orderNewDetailModel = Mapper<WOWNewOrderDetailModel>().map(result)
                    strongSelf.orderCode =  strongSelf.orderNewDetailModel!.orderCode
                    
                    strongSelf.orderType(strongSelf.orderNewDetailModel)
                    
                    strongSelf.getOrderData()
                
                    strongSelf.tableView.reloadData()
                }
            }) { (errorMsg) in
                
            }
            
        }
//    }
}
// MARK: - 订单支付相关
extension WOWOrderDetailController{
    
    func sureOrderPay(channl: String){
        if let orderNewModel = self.orderNewDetailModel {
            
            //    backView.hidePayView()
            if  orderNewModel.orderCode!.isEmpty {
                WOWHud.showMsg("订单不存在")
                return
            }
            WOWNetManager.sharedManager.requestWithTarget(.Api_OrderCharge(orderNo: self.orderCode ?? "", channel: channl, clientIp: IPManager.sharedInstance.ip_public), successClosure: { [weak self](result) in
                if let strongSelf = self {
                    let json = JSON(result)
                    let charge = json["charge"]
                    strongSelf.goPay(charge.object)
                }
                
            }) { (errorMsg) in
                
            }
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
        WOWNetManager.sharedManager.requestWithTarget(.Api_PayResult(orderCode: orderCode), successClosure: { [weak self](result) in
            if let strongSelf = self {
                strongSelf.request() // 更新最新状态
                strongSelf.delegate?.orderStatusChange()
                let json = JSON(result)
                let orderCode = json["orderCode"].string
                let payAmount = json["payAmount"].double
                let paymentChannelName = json["paymentChannelName"].string
                let vc = UIStoryboard.initialViewController("BuyCar", identifier:"WOWPaySuccessController") as! WOWPaySuccessController
                vc.payMethod = paymentChannelName ?? ""
                vc.orderid = orderCode ?? ""
                vc.totalPrice = String(format: "%.2f",payAmount ?? 0)
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
            
        }) { (errorMsg) in
            
        }
    }
    

}

// MARK: - UITableViewDelegate,UITableViewDataSource
extension WOWOrderDetailController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch OrderDetailNewaType {
        case .payMent:
            switch indexPath.section {
            case 3:
                return CellHight.CourceHight
            case 4:
                return CellHight.PayCellHight
            default:
                return CellHight.ProductCellHight
            }
            
        case .forGoods,.noForGoods,.finish:
            switch indexPath.section {
                
            case 3:
                return CellHight.CourceHight
            default:
                return CellHight.ProductCellHight
            }
        case .someFinishForGoods:
            switch indexPath.section {
                
            case goodsArray.count + 3 :
                return CellHight.CourceHight
            default:
                
                return CellHight.ProductCellHight
            }
            
        }
        
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var returnCell:UITableViewCell!
        switch OrderDetailNewaType {
        case .payMent:
            switch indexPath.section {
            case 0:
                
                let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailTwoCell", forIndexPath: indexPath) as! WOWOrderDetailTwoCell
                
                if let orderNewDetailModel = orderNewDetailModel{
                    
                    cell.showData(orderNewDetailModel)
                    
                    
                }
                
                returnCell = cell
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailSThreeCell", forIndexPath: indexPath) as! WOWOrderDetailSThreeCell
                if let orderNewDetailModel = orderNewDetailModel{
                    
                    cell.showData(orderNewDetailModel)
                    
                }
                
                returnCell = cell
                
            case 2:
                
                let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailNewCell", forIndexPath: indexPath) as! WOWOrderDetailNewCell
                if let orderNewDetailModel = orderNewDetailModel {
                    
                    cell.showData(orderNewDetailModel,indexRow: indexPath.row)
                    
                }
                
                
                returnCell = cell
                
            case 3:
                
                let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailCostCell", forIndexPath: indexPath) as! WOWOrderDetailCostCell
                if let orderNewDetailModel = orderNewDetailModel {
                    if indexPath.row == 0 {
                        let result = WOWCalPrice.calTotalPrice([orderNewDetailModel.deliveryFee ?? 0],counts:[1])

                        cell.priceLabel.text       = result
                        cell.saidImageView.hidden  = false
                        cell.freightTypeLabel.text = "运费"
                    }
                    if indexPath.row == 1 {
                         let result = WOWCalPrice.calTotalPrice([orderNewDetailModel.couponAmount ?? 0],counts:[1])
                        cell.priceLabel.text       = result
                        cell.saidImageView.hidden  = true
                        cell.freightTypeLabel.text = "优惠券"
                    }
                    
                    
                }
                returnCell = cell
            case 4:
                
                let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailPayCell", forIndexPath: indexPath) as! WOWOrderDetailPayCell
                if indexPath.row == 0 {
                    cell.payTypeImageView.image  = UIImage(named: "alipay")

                    cell.payTypeLabel.text       = "支付宝"
                    switch surePayType {
                        
                    case PayType.payAli:
                        cell.isClooseImageView.image = UIImage(named: "select")
                    default:
                        cell.isClooseImageView.image = UIImage(named: "car_check")
                    }

                }
                if indexPath.row == 1 {
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
            switch indexPath.section {
            case 0:
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailTwoCell", forIndexPath: indexPath) as! WOWOrderDetailTwoCell
                    
                    if let orderNewDetailModel = orderNewDetailModel{
                        
                        cell.showData(orderNewDetailModel)
                        
                    }
                    
                    returnCell = cell
                }else{
                    let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailSThreeCell", forIndexPath: indexPath) as! WOWOrderDetailSThreeCell
                    if let orderNewDetailModel = orderNewDetailModel {
                        
                        cell.personNameLabel.text = "由 " + orderNewDetailModel.packages![indexPath.section].deliveryCompanyName! + " 派送中"
                        cell.addressLabel.text    = "运单号：" + orderNewDetailModel.packages![indexPath.section].deliveryOrderNo!
                        
                    }
                    returnCell = cell
                    
                }
                
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailSThreeCell", forIndexPath: indexPath) as! WOWOrderDetailSThreeCell
                
                if let orderNewDetailModel = orderNewDetailModel{
                    
                    cell.showData(orderNewDetailModel)
                    
                }
                

                returnCell = cell
                
            case 2:
                
                let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailNewCell", forIndexPath: indexPath) as! WOWOrderDetailNewCell
                if let orderNewDetailModel = orderNewDetailModel {
                    
                    
                    switch OrderDetailNewaType {
                    case .forGoods,.finish:
                        cell.showPackages(orderNewDetailModel, indexSection: indexPath.section - 2, indexRow: indexPath.row)
                        
                    default:
                        cell.showData(orderNewDetailModel,indexRow: indexPath.row)
                    }
                    
                }
                
                returnCell = cell
                
            case 3:
                
                let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailCostCell", forIndexPath: indexPath) as! WOWOrderDetailCostCell
                if let orderNewDetailModel = orderNewDetailModel {
                    if indexPath.row == 0 {
                        let result = WOWCalPrice.calTotalPrice([orderNewDetailModel.deliveryFee ?? 0],counts:[1])
            
                        cell.priceLabel.text       = result

                        cell.saidImageView.hidden  = false
                        cell.freightTypeLabel.text = "运费"
                    }
                    if indexPath.row == 1 {
                        let result = WOWCalPrice.calTotalPrice([orderNewDetailModel.couponAmount ?? 0],counts:[1])
                        cell.priceLabel.text       = result

                        cell.saidImageView.hidden  = true
                        cell.freightTypeLabel.text = "优惠券"
                    }
                    
                    
                }
                
                returnCell = cell
                
            default:
                break
            }
        case .someFinishForGoods:
            
            
            switch indexPath.section {
            case 0:
                let cell   = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailTwoCell", forIndexPath: indexPath) as! WOWOrderDetailTwoCell
                
                if let orderNewDetailModel = orderNewDetailModel{
                    
                    cell.showData(orderNewDetailModel)
                    
                    
                }
                
                returnCell = cell
            case 1:
                let cell   = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailSThreeCell", forIndexPath: indexPath) as! WOWOrderDetailSThreeCell
                if let orderNewDetailModel = orderNewDetailModel{
                    
                    cell.showData(orderNewDetailModel)
                    
                }
                
                returnCell = cell
            case goodsArray.count + 2 :
                let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailNewCell", forIndexPath: indexPath) as! WOWOrderDetailNewCell
                if let orderNewDetailModel = orderNewDetailModel {
                    
                    cell.showData(orderNewDetailModel,indexRow: indexPath.row)
                    
                }
                
                returnCell = cell
            case goodsArray.count + 3 :
                let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailCostCell", forIndexPath: indexPath) as! WOWOrderDetailCostCell
                if let orderNewDetailModel = orderNewDetailModel {
                    if indexPath.row == 0 {
                        let result = WOWCalPrice.calTotalPrice([orderNewDetailModel.deliveryFee ?? 0],counts:[1])
                        cell.priceLabel.text       = result

                        cell.saidImageView.hidden  = false
                        cell.freightTypeLabel.text = "运费"
                    }
                    if indexPath.row == 1 {
                        let result = WOWCalPrice.calTotalPrice([orderNewDetailModel.couponAmount ?? 0],counts:[1])
                        cell.priceLabel.text       = result

                        cell.saidImageView.hidden  = true
                        cell.freightTypeLabel.text = "优惠券"
                    }
                    
                    
                }
                
                returnCell = cell
                
                
            default:
                
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailSThreeCell", forIndexPath: indexPath) as! WOWOrderDetailSThreeCell
                    if let orderNewDetailModel = orderNewDetailModel {
                        
                        cell.personNameLabel.text = "包裹" + (indexPath.section - 1).toString + "：" + orderNewDetailModel.packages![indexPath.section - 2].deliveryCompanyName!
                        cell.addressLabel.text    = "运单号：" + orderNewDetailModel.packages![indexPath.section - 2].deliveryOrderNo!
                        
                    }
                    
                    returnCell = cell
                    
                }else{
                    let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailNewCell", forIndexPath: indexPath) as! WOWOrderDetailNewCell
                    
                    if let orderNewDetailModel = orderNewDetailModel {
                        
                        cell.showPackages(orderNewDetailModel,indexSection:indexPath.section - 2 , indexRow:indexPath.row - 1)
                        
                    }
                    
                    returnCell = cell
                }
            }
            
        }
        
        returnCell.selectionStyle = .None
        return returnCell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        switch indexPath.section {
        case 4:
            switch indexPath.row {
            case 0:
                
                print("支付宝")
                 self.surePayType = PayType.payAli

            case 1:
                
                print("微信")
                self.surePayType = PayType.payWiXin
                
            default:
                break
            }
            tableView.reloadData()
        default:
            break
        }
    }
     func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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

//                return 38
                
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
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch OrderDetailNewaType {
        case .payMent:
            let titles = [" ","收货人","商品清单","","支付方式"]
            return titles[section]
        case .forGoods,.noForGoods,.finish:
            let titles = [" ","收货人","商品清单",""]
            return titles[section]
        case .someFinishForGoods:
            
            switch section {
            case 0:
                return " "
            case 1:
                return "收货人"
            case 2:
                if isSomeForGoodsType == true {
                        return "已发货商品清单"
                }else{
                        return "商品清单"
                }
                
            case goodsArray.count + 2:
                
                switch goodsNoArray.count {
                case 0:
                    return " "
                default:
                    return "未发货商品清单"
                }

                
            default:
                return " "
            }
            
            
        }
        
        
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        
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
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
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
    func footSectionView(indexPathSetion:Int) -> UIView {
        let view = UIView()
        view.frame = CGRectMake(0, 0, MGScreenWidth, 40)
        view.backgroundColor = UIColor.whiteColor()
        
        let likeButton = UIButton(type: .System)
        likeButton.frame = CGRectMake(0, 0, 100, 40)
        likeButton.center = view.center
        likeButton.centerX = view.centerX - 10
        likeButton.titleLabel?.font = UIFont.systemFontOfSize(12)
        likeButton.setTitleColor(GrayColorlevel3, forState: .Normal)
        var totalNum : String?
        
        switch OrderDetailNewaType {
        case .payMent,.noForGoods:
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
        
        likeButton.setTitle(totalNum, forState: .Normal)
        
        if isOpen == true {
            likeButton.setImage(UIImage(named: "downOrder")?.imageWithRenderingMode(.AlwaysOriginal), forState: UIControlState.Normal)
        }else{
            likeButton.setImage(UIImage(named: "topOrder")?.imageWithRenderingMode(.AlwaysOriginal), forState: UIControlState.Normal)
        }
        
        likeButton.imageEdgeInsets = UIEdgeInsetsMake(10, 70, 10, 10)
        likeButton.addTarget(self, action: #selector(clickAction(_:)), forControlEvents: .TouchUpInside)
        likeButton.tag = indexPathSetion
        view.addSubview(likeButton)
        
        
        return view
        
    }
    
    // 关闭页眉页脚的停留
//        func scrollViewDidScroll(scrollView: UIScrollView) {
//            let sectionHeaderHeight:CGFloat = 38
//    
//            let sectionFooterHeight:CGFloat = 40
//            let offsetY:CGFloat = scrollView.contentOffset.y;
//            if offsetY >= 0 && offsetY <= sectionHeaderHeight
//            {
//                scrollView.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0)
//            }else if offsetY >= sectionHeaderHeight && offsetY <= scrollView.contentSize.height - scrollView.frame.size.height - sectionFooterHeight
//            {
//                scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0)
//            }else if offsetY >= scrollView.contentSize.height - scrollView.frame.size.height - sectionFooterHeight && offsetY <= scrollView.contentSize.height - scrollView.frame.size.height
//            {
//                scrollView.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(scrollView.contentSize.height - scrollView.frame.size.height - sectionFooterHeight), 0)
//            }
//    
//            }
    func clickAction(sender:UIButton)  {
        
        
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
        let indexSet = NSIndexSet.init(index: sender.tag)
        
        tableView.reloadSections(indexSet, withRowAnimation: UITableViewRowAnimation.Automatic)

        
    }
    func tableView(tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = MGRgb(109, g: 109, b: 114)
            headerView.textLabel?.font = Fontlevel003
        }
    }
}
