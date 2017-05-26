//
//  WOWOrderDetailController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/16.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
import AdSupport


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
    
    case payCmbWallet            //= 招行一网通
    
    case payUnionPay            //= 银联手机支付
    
    case payApplePay            //= ApplePay

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
    /// hight : 38 标注 “收货人，商品清单”之类的
    static var headerHight      : CGFloat        = 38
}
class WOWOrderDetailController: WOWBaseViewController{

    var orderNewModel               : WOWNewOrderListModel?

    var orderNewDetailModel         : WOWNewOrderDetailModel?{
        didSet{
            switch orderNewDetailModel?.changedAmountType ?? 0 {
            case 0:
                cellNumber = 2
            default:
                cellNumber = 3
            }
        }
    }
    var cellNumber  : Int = 2
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
    
    var myQueueTimer1: DispatchQueue?
    var myTimer1: DispatchSourceTimer?
    
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        request()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if entrance == .orderPay{
            
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false;
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false;

            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    lazy var timerView: OrderTimerView = {
        let view = OrderTimerView()
        return view
    }()
    // 倒计时 ，实时更新Model层数据
    func timerCount(detailModel: WOWNewOrderDetailModel){
        myQueueTimer1 = DispatchQueue(label: "myQueueTimer")
        myTimer1 = DispatchSource.makeTimerSource(flags: [], queue: myQueueTimer1!)
        myTimer1?.scheduleRepeating(deadline: .now(), interval: .seconds(1) ,leeway:.milliseconds(10))
        myTimer1?.setEventHandler {[weak self] in
            if let strongSelf = self {
                if detailModel.leftPaySeconds > 0 {
                    
                    detailModel.leftPaySeconds = detailModel.leftPaySeconds! - 1
                    
                    DispatchQueue.main.async {
                        
                        strongSelf.timerView.timeStamp = strongSelf.orderNewDetailModel?.leftPaySeconds ?? 0
                        
                    }
                    
                }else {
                    strongSelf.myTimer1        = nil
                    strongSelf.myQueueTimer1   = nil
                    
                    strongSelf.request()//拉取服务器状态， 状态改变，则就会更新UI
                    
                    
                }
            }
    
        }
        myTimer1?.resume()
        
    }
    //MARK:Private Method
    override func setUI() {
        super.setUI()
        
        orderNoNumber        = 0
        orderGoodsNumber     = 0
        isSomeForGoodsType   = true
        isOpen               = true

    
        WOWBorderColor(rightButton)
        navigationItem.title = "订单详情"
        configTableView()
  
        
    }

    override func navBack() {
        switch entrance {
        case .orderPay:
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
        tableView.mj_header = mj_header
        tableView.register(UINib.nibName("WOWOrderDetailNewCell"), forCellReuseIdentifier: "WOWOrderDetailNewCell")
        tableView.register(UINib.nibName("WOWOrderDetailTwoCell"), forCellReuseIdentifier: "WOWOrderDetailTwoCell")
        tableView.register(UINib.nibName("WOWOrderDetailSThreeCell"), forCellReuseIdentifier: "WOWOrderDetailSThreeCell")
        tableView.register(UINib.nibName("WOWOrderDetailCostCell"), forCellReuseIdentifier: "WOWOrderDetailCostCell")
        tableView.register(UINib.nibName("WOWOrderDetailPayCell"), forCellReuseIdentifier: "WOWOrderDetailPayCell")
        tableView.register(UINib.nibName("WOWTelCell"), forCellReuseIdentifier: "WOWTelCell")
        
        tableView.clearRestCell()
    }
    // 取消订单
    @IBAction func clooseOrderButtonClick(_ sender: UIButton) {
        func clooseOrder(){
            WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_OrderCancel(orderCode: orderCode), successClosure: { [weak self](result, code) in
                if let strongSelf = self{
                    //取消订单成功后重新请求下网络刷新列表
                    strongSelf.request()
                    strongSelf.delegate?.orderStatusChange()
                    NotificationCenter.postNotificationNameOnMainThread(WOWUpdateOrderListAllNotificationKey, object: nil)
                }
            }) { (errorMsg) in
                WOWHud.showWarnMsg(errorMsg)
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
    func goCommentVC(_ orderCode:String) {
        
        let vc = UIStoryboard.initialViewController("User", identifier:String(describing: WOWUserCommentVC.self)) as! WOWUserCommentVC
        vc.orderCode = orderCode
        vc.delegate  = self
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    // 右边点击按钮
    @IBAction func rightButtonClick(_ sender: UIButton) {
        
        if let orderNewModel = orderNewDetailModel {
        switch orderNewModel.orderStatus ?? 0  {
            case 0:// 立即支付
                
                switch surePayType {
                case .payAli:
                    sureOrderPay("alipay")
                case .payWiXin:
                    sureOrderPay("wx")
                case .payCmbWallet:
                    sureOrderPay("cmb_wallet")
                default:
                    WOWHud.showMsg("请选择支付方式")
                    break
                }
            
            case 3:// 确认收货
                
                confirmReceive(orderNewModel.orderCode ?? "")
            case 4:
                goCommentVC(orderNewModel.orderCode ?? "")
                DLog("待评价")
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
    
    }
    /**
     *  区分订单类型 UI
     */
    func orderType(_ OrderDetailModel:WOWNewOrderDetailModel?) {
        if let orderNewModel = OrderDetailModel {
            
           
            switch orderNewModel.orderStatus ?? 0  {
            case 0:
                self.OrderDetailNewaType          = OrderNewType.payMent

                self.timerCount(detailModel: orderNewModel) // 更新Model层时间戳
                
                self.rightButton.setTitle("立即支付", for: UIControlState())
        
            case 1,5,6:
                self.OrderDetailNewaType = OrderNewType.noForGoods
                hideRightBtn()
            case 4:
                self.OrderDetailNewaType = OrderNewType.finish
                if orderNewModel.packages?.count > 1 { // 如果大于1， 说明有不多个包裹的订单 则 换UI界面
                    self.OrderDetailNewaType          = OrderNewType.someFinishForGoods
                    isSomeForGoodsType = false
                }
                if let isComment = orderNewModel.isComment{// 判断是否评论
                    if isComment == true {
                        hideRightBtn()
                    }else{
                        self.clooseOrderButton.isHidden = true
                        self.rightButton.setTitle("去评论", for: UIControlState())
                    }
                }else{
                        hideRightBtn()
                }
            case 2:
                self.OrderDetailNewaType = OrderNewType.someFinishForGoods
                
                hideRightBtn()
                
            case 3:
                self.OrderDetailNewaType          = OrderNewType.forGoods
                self.clooseOrderButton.isHidden     = true
                self.rightButton.setTitle("确认收货", for: UIControlState())

                if orderNewModel.packages?.count > 1 {// 如果大于1， 说明有不多个包裹的订单 则 换UI界面
                     self.OrderDetailNewaType          = OrderNewType.someFinishForGoods
                    isSomeForGoodsType = false
                }
            default:
                break
            }
            let result = WOWCalPrice.calTotalPrice([orderNewModel.orderAmount ?? 0],counts:[1])
            self.priceLabel.text          = result
            
        }
    }
    // MARK: 获取已经发货清单的商品的总数
    func getOrderGoodsNumber(packages : [WOWNewForGoodsModel]?){
        if let forGoodsArr = packages {
            self.goodsArray = forGoodsArr
            if forGoodsArr.count > 0 {
                self.orderGoodsNumber = forGoodsArr[0].orderItems?.count > 3 ? 3 : forGoodsArr[0].orderItems?.count
                
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
            self.getOrderGoodsNumber(packages: self.orderNewDetailModel?.packages)
            
        case .payMent,.noForGoods:
            /// 拿出未发货的商品数组
            if  let noForGoodsArr = self.orderNewDetailModel?.unShipOutOrderItems {
                
                self.orderNoNumber = noForGoodsArr.count > 3 ? 3 : noForGoodsArr.count
                
            }
        default:
            /// 拿出发货的商品数组
            self.getOrderGoodsNumber(packages: self.orderNewDetailModel?.packages)
            
            /// 拿出未发货的商品数组
            if  let noForGoodsArr = self.orderNewDetailModel?.unShipOutOrderItems {
            
                self.goodsNoArray   = noForGoodsArr
                
                self.orderNoNumber  = noForGoodsArr.count
                
            }
            
        }
        
    }
    //确认收货
    fileprivate func confirmReceive(_ orderCode:String){
        func confirm(){
            WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_OrderConfirm(orderCode: orderCode), successClosure: { [weak self](result, code) in
                if let strongSelf = self{
                    //确认收货成功后重新请求下网络刷新列表
                    strongSelf.request()
                    strongSelf.delegate?.orderStatusChange()
                     NotificationCenter.postNotificationNameOnMainThread(WOWUpdateOrderListAllNotificationKey, object: nil)
                }
            }) { (errorMsg) in
                WOWHud.showWarnMsg(errorMsg)
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
            isOpen = true // 默认 不展开
            WOWNetManager.sharedManager.requestWithTarget(.api_OrderDetail(OrderCode:self.orderCode ?? ""), successClosure: { [weak self](result, code) in
                let json = JSON(result)
                DLog(json)
                if let strongSelf = self{
                    strongSelf.endRefresh()
                    strongSelf.orderNewDetailModel = Mapper<WOWNewOrderDetailModel>().map(JSONObject:result)
                    strongSelf.orderCode =  strongSelf.orderNewDetailModel!.orderCode
                    
                    
                    strongSelf.orderType(strongSelf.orderNewDetailModel)
                    
                    strongSelf.getOrderData()
                
                    strongSelf.tableView.reloadData()
                }
            }) {[weak self] (errorMsg) in
                 if let strongSelf = self{
                  strongSelf.endRefresh()
                    WOWHud.showMsgNoNetWrok(message: errorMsg)
                }
            }
            
        }
}
// MARK: - 订单支付相关
extension WOWOrderDetailController{
    
    func sureOrderPay(_ channel: String){
        if let orderNewModel = self.orderNewDetailModel {
            if  (orderNewModel.orderCode ?? "").isEmpty {
                WOWHud.showMsg("订单不存在")
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
                WOWHud.showWarnMsg(errorMsg)
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
        WOWNetManager.sharedManager.requestWithTarget(.api_PayResult(orderCode: orderCode), successClosure: { [weak self](result, code) in
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
                let result = WOWCalPrice.calTotalPrice([payAmount ?? 0],counts:[1])
                vc.totalPrice = result
                
                //TalkingData 支付成功
                var sum = payAmount ?? 0
                sum                  = sum * 100
                let order_id             = orderCode ?? ""
                AnalyaticEvent.e2(.PaySuccess,["totalAmount":sum ,"OrderCode":order_id ])
                
                
                strongSelf.navigationController?.pushViewController(vc, animated: true)

            }
            
        }) { (errorMsg) in
            WOWHud.showWarnMsg(errorMsg)
        }
    }
}
// MARK: - UITableViewDelegate,UITableViewDataSource
extension WOWOrderDetailController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        switch OrderDetailNewaType {
        case .payMent:
            return 5 + 1
        case .forGoods,.noForGoods,.finish:
            return 4 + 1
        case .someFinishForGoods:
            return 4 + goodsArray.count + 1
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
                return cellNumber
            case 4: //支付方式
                return 3
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
                return cellNumber
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
                return cellNumber
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
                return cellNumber
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
                return cellNumber
            case goodsArray.count + 4 :
                return 1
            default:
                
                let goods : WOWNewForGoodsModel = goodsArray[section - 2]
                
                return ((goods.orderItems?.count) ?? 0) + 1
                
            }
            
        }
        
    }
    // 获取未发货数组中的 商品信息，
    func configUnShipOutGoodsUI(cell:WOWOrderDetailNewCell,indexRow : Int) {
        
        if let unShipOutItems = orderNewDetailModel?.unShipOutOrderItems { // 判断是否为空
            if unShipOutItems.count > indexRow { // 判断时否越界
                
                let orderProductModel = unShipOutItems[indexRow]
                cell.orderCode = self.orderCode
                cell.productData(model: orderProductModel)

            }
        }
    }
    // 获取 发货数组中的 商品信息，
    func configShipOutGoodsUI(cell:WOWOrderDetailNewCell,indexRow : Int,indexSection : Int) {
        
        if let packages = orderNewDetailModel?.packages { // 判断是否为空
            if packages.count > indexSection {
                
                if let orderItems = packages[indexSection].orderItems {
                    if orderItems.count > indexRow {
                        cell.orderCode = self.orderCode
                        cell.productData(model: orderItems[indexRow])
                    }
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell:UITableViewCell!
        let indexRow        = indexPath.row
        let indexSection    = indexPath.section
        switch OrderDetailNewaType {
        case .payMent:
            switch (indexPath as NSIndexPath).section {
            case 0:
                
                returnCell = getOrderTimeCell(indexPath: indexPath)
                
            case 1:
                
                returnCell = getSubTitleAndTitle(indexPath: indexPath)
                
            case 2:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "WOWOrderDetailNewCell", for: indexPath) as! WOWOrderDetailNewCell
                if orderNewDetailModel != nil {
                    
                    cell.delegeta = self
                    self.configUnShipOutGoodsUI(cell: cell, indexRow: indexRow)
                    
                }
                returnCell = cell
                
            case 3:
                returnCell =  getCostCell(indexPath: indexPath)
            case 4:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "WOWOrderDetailPayCell", for: indexPath) as! WOWOrderDetailPayCell
                if (indexPath as NSIndexPath).row == 0 {
                    cell.payTypeImageView.image  = UIImage(named: "alipay")

                    cell.payTypeLabel.text       = "支付宝"
                    switch surePayType {
                        
                    case PayType.payAli:
                        cell.isClooseImageView.image = UIImage(named: "selectBig")
                    default:
                        cell.isClooseImageView.image = UIImage(named: "unselectBig")
                    }

                }
                if (indexPath as NSIndexPath).row == 1 {
                    cell.payTypeImageView.image = UIImage(named: "weixin")
                    cell.payTypeLabel.text      = "微信支付"
                    switch surePayType {
                    case PayType.payWiXin:
                        cell.isClooseImageView.image = UIImage(named: "selectBig")
                    default:
                        cell.isClooseImageView.image = UIImage(named: "unselectBig")
        
                    }

                }
                if (indexPath as NSIndexPath).row == 2 {
                    cell.payTypeImageView.image = UIImage(named: "cmb_wallet")
                    cell.payTypeLabel.text      = "招行支付"
                    switch surePayType {
                    case PayType.payCmbWallet:
                        cell.isClooseImageView.image = UIImage(named: "selectBig")

                    default:
                        cell.isClooseImageView.image = UIImage(named: "unselectBig")
                        
                    }
                    
                }
                returnCell =  cell
            case 5:
                
                returnCell = getCustomerPhoneCell(indexPath: indexPath)
                
            default:
                break
            }
            
        case .forGoods,.noForGoods,.finish:
            switch (indexPath as NSIndexPath).section {
            case 0:
                if (indexPath as NSIndexPath).row == 0 {
                    
                    returnCell = getOrderTimeCell(indexPath: indexPath)
                    
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "WOWOrderDetailSThreeCell", for: indexPath) as! WOWOrderDetailSThreeCell
                   
                    if let orderNewDetailModel = orderNewDetailModel {
                        if let packages = orderNewDetailModel.packages { // 取出发货的清单数据
                            if let deliveryCompanyName = packages[indexPath.section].deliveryCompanyName { // 取出发货的快递公司
                                cell.personNameLabel.text = "由 " + deliveryCompanyName  + " 派送中"
                            }
                            if let deliveryOrderNo = packages[indexPath.section].deliveryOrderNo { // 取出发货的快递单号
                                cell.addressLabel.text    = "运单号：" + deliveryOrderNo

                            }

                        }
                        
                    }
                    returnCell = cell
                    
                }
                
            case 1:
              
                returnCell =  getSubTitleAndTitle(indexPath: indexPath)
                
            case 2:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "WOWOrderDetailNewCell", for: indexPath) as! WOWOrderDetailNewCell
                if orderNewDetailModel != nil {
                    
                    cell.delegeta = self

                    switch OrderDetailNewaType {
                    case .forGoods,.finish:

                        self.configShipOutGoodsUI(cell: cell, indexRow: indexRow, indexSection: indexSection - 2)


                    default:
                        
                        self.configUnShipOutGoodsUI(cell: cell, indexRow: indexRow)
                      

                    }
                    
                }
                
                returnCell = cell
                
            case 3:
                returnCell = getCostCell(indexPath: indexPath)
            case 4:
                returnCell = getCustomerPhoneCell(indexPath: indexPath)
            default:
                break
            }
        case .someFinishForGoods:
            
            
            switch (indexPath as NSIndexPath).section {
            case 0:

                returnCell = getOrderTimeCell(indexPath: indexPath)
                
            case 1:
                
                returnCell = getSubTitleAndTitle(indexPath: indexPath)
                
            case goodsArray.count + 2 :
                let cell = tableView.dequeueReusableCell(withIdentifier: "WOWOrderDetailNewCell", for: indexPath) as! WOWOrderDetailNewCell
                if orderNewDetailModel != nil {
                    cell.delegeta = self
                    self.configUnShipOutGoodsUI(cell: cell, indexRow: indexRow)
                }
                
                returnCell = cell
            case goodsArray.count + 3 :
              
                
                returnCell =   getCostCell(indexPath: indexPath)
                
            case goodsArray.count + 4 :
                
                returnCell = getCustomerPhoneCell(indexPath: indexPath)
                
            default:
                
                if (indexPath as NSIndexPath).row == 0 {

                returnCell = getSubTitleAndTitle(indexPath: indexPath,isNameAndPhone: false)
                    
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "WOWOrderDetailNewCell", for: indexPath) as! WOWOrderDetailNewCell
                    
                    if orderNewDetailModel != nil {
                        cell.delegeta = self
                        self.configShipOutGoodsUI(cell: cell, indexRow: indexRow - 1, indexSection: indexSection - 2)
                    }
                    returnCell = cell
                }
            }
            
        }
        
        returnCell.selectionStyle = .none
        return returnCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let section = indexPath.section
        switch OrderDetailNewaType {
        case .payMent:
            switch section {
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
                case 2:
                    switch surePayType {
                    case .payCmbWallet:
                        self.surePayType = PayType.none
                    default:
                        self.surePayType = PayType.payCmbWallet
                    }
                default:
                    break
                }
                tableView.reloadData()
            case 5:break

            default:
                break
            }

        case .forGoods,.noForGoods,.finish:
            if section == 4 {
                
            }
        case .someFinishForGoods:
//            return 4 + goodsArray.count + 1
            if section == 4 + goodsArray.count {
            }
        }

    }
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch OrderDetailNewaType {
        case .someFinishForGoods:
            
            switch section {
            case 0:
                return CellHight.minHight
            case 1 , 2:
                return CellHight.headerHight
                
            case goodsArray.count + 2:
                switch goodsNoArray.count {
                case 0:
                    return 0.01
                default:
                    return CellHight.headerHight
                }
                
            case goodsArray.count + 3 :
                return 12
            default:
                return 12
            }
            
            
        default:
            switch section {
            case 0:
                if OrderDetailNewaType == .payMent {
                    return CellHight.headerHight
                }else{
                    return CellHight.minHight
                }
                
            case 3,5: // 运费 客服电话 cell 页眉高度
                return 12
            case 4:
                if OrderDetailNewaType == .payMent {
                    return CellHight.headerHight
                }else{
                    return 12
                }

            default:
                return CellHight.headerHight
            }
            
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        switch OrderDetailNewaType {
        case .payMent:
            let titles = ["Timer","收货人","商品清单","","支付方式",""]
            let heights = [CellHight.headerHight,CellHight.headerHight,CellHight.headerHight,12,CellHight.headerHight,12]
            return headerSectionView(titles[section], headetHeight: CGFloat(heights[section]))

        case .forGoods,.noForGoods,.finish:
            let titles = [" ","收货人","商品清单","",""]
            let heights = [CellHight.minHight,CellHight.headerHight,CellHight.headerHight,12,12]
            return headerSectionView(titles[section], headetHeight: heights[section])
        case .someFinishForGoods:
            
            switch section {
            case 0:
                return headerSectionView(" ", headetHeight: CellHight.minHight)
            case 1:
                return headerSectionView("收货人", headetHeight: CellHight.headerHight)
            case 2:
                if isSomeForGoodsType == true {
                    return headerSectionView("已发货商品清单", headetHeight: CellHight.headerHight)
                }else{
                    return headerSectionView("商品清单", headetHeight: CellHight.headerHight)
                }
                
            case goodsArray.count + 2:
                
                switch goodsNoArray.count {
                case 0:
                    return headerSectionView(" ", headetHeight: CellHight.minHight)
                default:
                    return headerSectionView("未发货商品清单", headetHeight: CellHight.headerHight)
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

                if let unShipOutItems = orderNewDetailModel.unShipOutOrderItems { // 判断小与3 时 底部 “共几条” 不展示
                    if unShipOutItems.count <= 3 {
                        return CellHight.minHight
                    }
                }

                    
                case .forGoods,.finish:

                    if let packages = orderNewDetailModel.packages { // 判断小与3 时 底部 “共几条” 不展示
                        if packages.count > 0 {
                            if let orderItems =  packages[0].orderItems {
                                if orderItems.count <= 3 {
                                    return CellHight.minHight
                                }
                            }
                        }
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

                    if let unShipOutItems = orderNewDetailModel.unShipOutOrderItems { // 判断小与3 时 底部 “共几条” 不展示
                        if unShipOutItems.count <= 3 {
                            return nil
                        }
                    }
                    
                case .forGoods,.finish:

                    if let packages = orderNewDetailModel.packages { // 判断小与3 时 底部 “共几条” 不展示
                        if packages.count > 0 {
                            if let orderItems =  packages[0].orderItems {
                                if orderItems.count <= 3 {
                                    return nil
                                }
                            }
                        }
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
    func headerSectionView(_ headerTitle:String,headetHeight:CGFloat,isTimerView:Bool = false) -> UIView {
        guard headerTitle != "Timer" else { // 倒计时view
            
            return timerView
        }
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
            
            if  let forGoodsArr = self.orderNewDetailModel?.packages {
                if forGoodsArr.count > 0 {
                    if let goodsArr = forGoodsArr[0].orderItems {
                        
                          totalNum = "共" + goodsArr.count.toString + "件"
                    }
                  
                }
                
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
        
        likeButton.imageEdgeInsets = UIEdgeInsetsMake(10, 75, 10, 10)
        likeButton.addTarget(self, action: #selector(clickAction(_:)), for: .touchUpInside)
        likeButton.tag = indexPathSetion
        view.addSubview(likeButton)
        return view
        
    }
     func clickAction(_ sender:UIButton)  {
        
        
        switch OrderDetailNewaType {
        case .someFinishForGoods:
            DLog("")
            
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
                if  let forGoodsArr = self.orderNewDetailModel?.packages?[0].orderItems {
                    self.orderGoodsNumber = forGoodsArr.count
                }
                
                isOpen = false
            }else{
                if  let forGoodsArr = self.orderNewDetailModel?.packages?[0].orderItems {
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
extension WOWOrderDetailController {
    // 需要帮助 UI
    func getCustomerPhoneCell(indexPath:IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: String(describing: WOWTelCell.self), for: indexPath) as! WOWTelCell
        cell.titleLabel.text = "需要帮助"
        cell.contentView.addTapGesture {[unowned self] (sender) in
            MobClick.e(.contact_customer_service_order_detail)
            WOWCustomerNeedHelp.show(self.orderNewDetailModel?.orderCode ?? "")
        }
        
        return cell
    }
    
    //  运费 和 邮费 的 UI
    func getCostCell(indexPath:IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WOWOrderDetailCostCell", for: indexPath) as! WOWOrderDetailCostCell
        if let orderNewDetailModel = orderNewDetailModel {
            
            cell.showUI(orderNewDetailModel, indexPath: indexPath)
            
        }
        return cell
    }
    // 订单状态， 订单编号， 订单下单时间
    func getOrderTimeCell(indexPath:IndexPath) -> UITableViewCell {
        let cell   = tableView.dequeueReusableCell(withIdentifier: "WOWOrderDetailTwoCell", for: indexPath) as! WOWOrderDetailTwoCell
        
        if let orderNewDetailModel = orderNewDetailModel{
            
            cell.showData(orderNewDetailModel)

        }
        return cell
    }

    // 收货人姓名和手机号 or 包裹和运单号的 布局UI
    func getSubTitleAndTitle(indexPath:IndexPath,isNameAndPhone:Bool = true) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WOWOrderDetailSThreeCell", for: indexPath) as! WOWOrderDetailSThreeCell
        if let orderNewDetailModel = orderNewDetailModel{
            if isNameAndPhone {
                
                cell.showData(orderNewDetailModel)
                
            }else {
                if let packages = orderNewDetailModel.packages { // 取出发货的清单数据
                    if let deliveryCompanyName = packages[indexPath.section - 2].deliveryCompanyName { // 取出发货的快递公司
                        
                        cell.personNameLabel.text = "包裹" + (indexPath.section - 1).toString + "：" + deliveryCompanyName
                        
                    }
                    if let deliveryOrderNo = packages[indexPath.section - 2].deliveryOrderNo { // 取出发货的快递单号
                        
                        cell.addressLabel.text    = "运单号：" + deliveryOrderNo
                        
                    }
                    
                }

            }
         
        }
        return cell
    }

}
extension WOWOrderDetailController:UserCommentSuccesDelegate, WOWOrderDetailNewCellDelegate {
    
    func reloadTableViewCommentStatus() {
        request()
        NotificationCenter.postNotificationNameOnMainThread(WOWUpdateOrderListAllNotificationKey, object: nil)
    }
    
    func orderGoProductDetail(_ productId: Int?) {
        VCRedirect.toVCProduct(productId)
    }
}
