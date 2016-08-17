//
//  WOWOrderDetailController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/16.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit


enum OrderNewType {
    case payMent             //= "待付款"
    
    case forGoods            //= "待收货"
    
    case noForGoods          //= "待发货" ／"订单关闭" / "已经取消"
    
    case finish              //= "已完成"
    
    case someFinishForGoods  //= "部分完成"
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
    var orderModel                  : WOWOrderListModel!
    var orderNewModel               : WOWNewOrderListModel?
    
    var orderNewDetailModel         : WOWNewOrderDetailModel?
    
    
    
    var OrderDetailNewaType         : OrderNewType = .someFinishForGoods
    ///  : 存放包裹的数组
    var goodsArray = [WOWNewForGoodsModel]()
    
    
    ///  : 部分发货：发货清单的 产品 的数量
    var orderGoodsNumber                 : Int!
    
    
    ///  Test: 未发货清单的的包裹商品个数
    var orderNoNumber                 : Int! // 测试数据 未发货清单的的包裹商品个数
    
    
    var isOpen                      : Bool!
    @IBOutlet weak var tableView    : UITableView!
    @IBOutlet weak var countLabel   : UILabel!
    @IBOutlet weak var priceLabel   : UILabel!
    @IBOutlet weak var rightButton  : UIButton!
    @IBOutlet weak var clooseOrderButton  : UIButton!
    var statusLabel                 : UILabel!
    
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
        
        isOpen               = true
        request()
        WOWBorderColor(rightButton)
        navigationItem.title = "订单详情"
        configTableView()
        
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
    
    private func configBottomView(){
        countLabel.text    = "共\(orderModel.products?.count ?? 0)件商品"
        priceLabel.text    = orderModel.total?.priceFormat()
        var buttonTtile    = ""
        switch orderModel.status ?? 2{
        case 0:
            buttonTtile        = "立即支付"
        case 2: //待收货
            buttonTtile        = "确认收货"
        case 3: //待评价
            buttonTtile        = "立即评价"
        case 1,4,5: //完成订单 待发货,已关闭
            rightButton.hidden = true
        default:
            break
        }
        rightButton.setTitle(buttonTtile, forState:.Normal)
    }
    
    
    @IBAction func rightButtonClick(sender: UIButton) {
        switch orderModel.status ?? 0 {
        case 0:
            payOrder()
        case 1,2: //为2d的时候确定收货
            changeStatus()
        case 3: //评价
            commentOrder()
        default:
            break
        }
    }
    
    //MARK:Network
    private func payOrder(){
        if let charge = orderModel.charge {
            Pingpp.createPayment(charge as! NSObject, appURLScheme:WOWDSGNSCHEME, withCompletion: { [weak self](ret, error) in
                if let strongSelf = self{
                    if ret == "success"{ //支付成功
                        strongSelf.orderModel.status  = 1
                        strongSelf.rightButton.hidden = true
                        strongSelf.statusLabel.text   = "待发货"
                        strongSelf.callBack()
                    }else{//订单支付取消或者失败
                        if ret == "fail"{
                            WOWHud.showMsg("支付失败")
                        }
                    }
                }
            })
        }
    }
    
    func hideRightBtn() {
        self.rightButton.hidden       = true
        self.clooseOrderButton.hidden = true
        if let orderNewModel          = orderNewModel {
            self.priceLabel.text          = "¥"+((orderNewModel.orderAmount)?.toString)!
        }
        
    }
    
    func orderType() {
        if let orderNewModel = orderNewModel {
            
            /**
             *  区分订单类型 UI
             */
            switch orderNewModel.orderStatus!  {
            case 0:
                self.OrderDetailNewaType          = OrderNewType.payMent
                self.rightButton.setTitle("立即支付", forState: UIControlState.Normal)
                self.priceLabel.text              = "¥"+((orderNewModel.orderAmount)?.toString)!
                
            case 1,5,6:
                self.OrderDetailNewaType = OrderNewType.noForGoods
                hideRightBtn()
            case 4:
                self.OrderDetailNewaType = OrderNewType.finish
                hideRightBtn()
                
            case 2:
                self.OrderDetailNewaType = OrderNewType.someFinishForGoods
                hideRightBtn()
                
                
            case 3:
                self.OrderDetailNewaType          = OrderNewType.forGoods
                self.clooseOrderButton.hidden     = true
                self.rightButton.setTitle("确认收货", forState: UIControlState.Normal)
                self.priceLabel.text              = "¥"+((orderNewModel.orderAmount)?.toString)!
                
            default:
                break
            }
        }
    }
    /**
     拿到定制tableView 所需要的数据
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
                //                self.orderNoNumber = noForGoodsArr.count > 3 ? 3 : noForGoodsArr.count
                self.orderNoNumber = noForGoodsArr.count
                
            }
            
        }
        
    }
    
    //确认收货
    private func confirmReceive(orderCode:String,cell:WOWOrderListCell){
        func confirm(){
            WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_OrderConfirm(orderCode: orderCode), successClosure: { [weak self](result) in
                if let strongSelf = self{
                    //确认收货成功后重新请求下网络刷新列表
                    strongSelf.request()
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
        
        /**
         *  区分订单类型 UI
         */
        
        orderType()
        
        isOpen = true
        
        if let orderNewModel = orderNewModel {
            
            WOWNetManager.sharedManager.requestWithTarget(.Api_OrderDetail(OrderCode:orderNewModel.orderCode!), successClosure: { [weak self](result) in
                
                if let strongSelf = self{
                    
                    strongSelf.orderNewDetailModel = Mapper<WOWNewOrderDetailModel>().map(result)
                    
                    strongSelf.getOrderData()
                    
                    strongSelf.tableView.reloadData()
                }
            }) { (errorMsg) in
                
            }
            
        }
    }
    
    
    
    
    private func commentOrder(){
        let vc = UIStoryboard.initialViewController("User", identifier:"WOWOrderCommentController") as! WOWOrderCommentController
        //        vc.orderID = orderModel.id ?? ""
        //        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //更改状态
    private func changeStatus(){
        let uid      = WOWUserManager.userID
        let order_id = orderModel.id ?? ""
        var status   = "2"
        switch orderModel.status ?? 2 {
        case 2: //目前为待收货
            status       = "3"//待评价
        default:
            break
        }
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_OrderStatus(uid:uid, order_id:order_id, status:status), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                let ret = JSON(result).int ?? 0
                if ret == 1{
                    strongSelf.orderModel.status = 3
                    strongSelf.statusLabel.text = "待评价"
                    strongSelf.rightButton.setTitle("待评价", forState:.Normal)
                    strongSelf.callBack()
                }
            }
        }) { (errorMsg) in
            
        }
    }
    
    private func callBack(){
        if let del = delegate{
            del.orderStatusChange()
        }
    }
}

extension WOWOrderDetailController:OrderCommentDelegate{
    func orderCommentSuccess() {
        self.orderModel.status  = 4//已完成
        self.rightButton.hidden = true
        statusLabel.text        = "已完成"
        callBack()
    }
}


extension WOWOrderDetailController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        switch OrderDetailNewaType {
        case .payMent:
            return 5
        case .forGoods,.noForGoods,.finish:
            return 4
        case .someFinishForGoods:
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
                //                if let orderNewDetailModel = orderNewDetailModel {
                return orderNoNumber
                //                }else{
                //                    return 0
                //                }
                
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
                //                if let orderNewDetailModel = orderNewDetailModel {
                //                    return orderNewDetailModel.packages![0].orderItems!.count > 3 ? 3 : orderNewDetailModel.packages![0].orderItems!.count
                //                }else{
                return self.orderGoodsNumber
                //                }
                
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
                //                if let orderNewDetailModel = orderNewDetailModel {
                //                    return orderNewDetailModel.unShipOutOrderItems!.count > 3 ? 3 : orderNewDetailModel.unShipOutOrderItems!.count
                //                }else{
                return orderNoNumber
                //                }
                
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
                //                if let orderNewDetailModel = orderNewDetailModel {
                //                    return orderNewDetailModel.packages![0].orderItems!.count > 3 ? 3 : orderNewDetailModel.packages![0].orderItems!.count
                //                }else{
                return self.orderGoodsNumber
                //                }
            //
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
                return orderNoNumber
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
                        cell.priceLabel.text       = "¥" + (orderNewDetailModel.deliveryFee)!.toString
                        cell.saidImageView.hidden  = false
                        cell.freightTypeLabel.text = "运费"
                    }
                    if indexPath.row == 1 {
                        cell.priceLabel.text       = "¥" + (orderNewDetailModel.couponAmount)!.toString
                        cell.saidImageView.hidden  = true
                        cell.freightTypeLabel.text = "优惠券"
                    }
                    
                    
                }
                returnCell = cell
            case 4:
                
                let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailPayCell", forIndexPath: indexPath) as! WOWOrderDetailPayCell
                if indexPath.row == 0 {
                    cell.payTypeImageView.image = UIImage(named: "alipay")
                    cell.payTypeLabel.text      = "支付宝"
                }
                if indexPath.row == 1 {
                    cell.payTypeImageView.image = UIImage(named: "weixin")
                    cell.payTypeLabel.text      = "微信支付"
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
                        cell.priceLabel.text       = "¥" + (orderNewDetailModel.deliveryFee)!.toString
                        cell.saidImageView.hidden  = false
                        cell.freightTypeLabel.text = "运费"
                    }
                    if indexPath.row == 1 {
                        cell.priceLabel.text       = "¥" + (orderNewDetailModel.couponAmount)!.toString
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
                        cell.priceLabel.text       = "¥" + (orderNewDetailModel.deliveryFee)!.toString
                        cell.saidImageView.hidden  = false
                        cell.freightTypeLabel.text = "运费"
                    }
                    if indexPath.row == 1 {
                        cell.priceLabel.text       = "¥" + (orderNewDetailModel.couponAmount)!.toString
                        cell.saidImageView.hidden  = true
                        cell.freightTypeLabel.text = "优惠券"
                    }
                    
                    
                }
                
                returnCell = cell
                
                
            default:
                
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailSThreeCell", forIndexPath: indexPath) as! WOWOrderDetailSThreeCell
                    if let orderNewDetailModel = orderNewDetailModel {
                        
                        cell.personNameLabel.text = "包裹1：" + orderNewDetailModel.packages![indexPath.section - 2].deliveryCompanyName!
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
    
    /* FIXME:查看物流暂时放这里
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     switch indexPath.section {
     case 0:
     if indexPath.row == 1{//物流
     let vc = UIStoryboard.initialViewController("User", identifier:"WOWOrderTransController") as! WOWOrderTransController
     navigationController?.pushViewController(vc, animated: true)
     }
     default:
     break
     }
     }
     */
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch OrderDetailNewaType {
        case .someFinishForGoods:
            
            switch section {
            case 0:
                return CellHight.minHight
            case 1:
                return 38
                
            case goodsArray.count + 2 , 2:
                return 38
                
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
                return "已发货商品清单"
            case goodsArray.count + 2:
                return "未发货商品清单"
                
            default:
                return " "
            }
            
            
        }
        
        
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        
        switch OrderDetailNewaType {
        case .someFinishForGoods:
            //            switch section {
            //            case 0 , 1:
            return CellHight.minHight
            //            case goodsArray.count + 2:
            //
            //                return orderNoNumber > 3 ? CellHight.fooderHight : CellHight.minHight
            //
            //            case goodsArray.count + 3:
            //
            //                return CellHight.minHight
            //
            //            default:
            //                let goods = goodsArray[section - 2]
            //
            //                return (goods.orderItems!.count + 1) > 3 ? CellHight.fooderHight : CellHight.minHight
            //
            //
            //            }
            //
            
            
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
                //                guard orderNewDetailModel.unShipOutOrderItems!.count > 3 else {
                //                    return CellHight.minHight
                //                }
                
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
            //            switch section {
            //            case 0 , 1:
            return nil
            
            //            case goodsArray.count + 3:
            //                return nil
            //            case goodsArray.count + 2:
            //                return orderNoNumber > 3 ? footSectionView(section) : nil
            //            // FIXME:
            //            default:
            //                let goods = goodsArray[section - 2]
            //
            //                return (goods.orderItems!.count + 1) > 3 ? footSectionView(section) : nil
            //
            //
            //            }
            //
            
            
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
            //            switch sender.tag {
            //            case 0 , 1:
            //                print("0,1")
            //            case goodsArray.count + 2:
            //
            //                if isOpen == true {
            //
            //                    if  let noForGoodsArr = self.orderNewDetailModel?.unShipOutOrderItems {
            //                        self.orderNoNumber = noForGoodsArr.count
            //                    }
            //
            //                    isOpen = false
            //                }else{
            //
            //                    if  let noForGoodsArr = self.orderNewDetailModel?.unShipOutOrderItems {
            //                        self.orderNoNumber = noForGoodsArr.count > 3 ? 3 : noForGoodsArr.count
            //                    }
            //
            //                    isOpen = true
            //                }
            //
            //            case goodsArray.count + 3:
            //
            //                print("last")
            //
            //            default:
            //                sender.selected = true
            //
            //                isOpen = true
            //
            //            }
            
            
            
            
        case .payMent,.noForGoods:
            
            if isOpen == true {
                
                if  let noForGoodsArr = self.orderNewDetailModel?.unShipOutOrderItems {
                    self.orderNoNumber = noForGoodsArr.count
                }
                //                sender.selected = true
                
                
                
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
        
        //        // 刷新单独一组
        let indexSet = NSIndexSet.init(index: sender.tag)
        
        tableView.reloadSections(indexSet, withRowAnimation: UITableViewRowAnimation.Automatic)
        
        
        //        tableView.reloadData()
        
    }
    func tableView(tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = MGRgb(109, g: 109, b: 114)
            headerView.textLabel?.font = Fontlevel003
        }
    }
}
