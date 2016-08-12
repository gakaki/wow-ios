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
    
    case noForGoods          //= "待发货" ／"订单关闭" /= "已完成" /= "已经取消"
    
    case someFinishForGoods  //= "部分完成"
}

protocol OrderDetailDelegate:class{
    func orderStatusChange()
}

struct CellHight {
    static var ProductCellHight :CGFloat = 70
    static var PayCellHight :CGFloat     = 60
    static var CourceHight :CGFloat      = 50
}
class WOWOrderDetailController: WOWBaseViewController{
    var orderModel                  : WOWOrderListModel!
    var orderNewModel               : WOWNewOrderListModel?
    
    var orderNewDetailModel         : WOWNewOrderDetailModel?
    
    var orderProductModel           : WOWNewProductModel?
    
    
    var OrderDetailNewaType         : OrderNewType = .someFinishForGoods
    ///  Test: 存放包裹的数组
    var goodsArray = [[String:Int]]()
    ///  包裹名称  包裹内商品数量
    var airports: Dictionary<String, Int> = [:]
    //    let orderNewType : String!
    ///  Test: 总共几个包裹
    //    var goodsNumber                 : Int! // 测试数据
    
    ///  Test: 以发货清单的包裹1商品个数
    var orderNumber                 : Int! // 测试数据 以发货清单的包裹1商品个数
    ///  Test: 以发货清单的的包裹2商品个数
    var orderNumber2                 : Int! // 测试数据 以发货清单的的包裹2商品个数
    ///  Test: 未发货清单的的包裹商品个数
    var orderNoNumber                 : Int! // 测试数据 未发货清单的的包裹商品个数
    
    
    var isOpen                      : Bool!
    @IBOutlet weak var tableView    : UITableView!
    @IBOutlet weak var countLabel   : UILabel!
    @IBOutlet weak var priceLabel   : UILabel!
    @IBOutlet weak var rightButton  : UIButton!
    @IBOutlet weak var clooseOrderButton  : UIButton!
    var statusLabel                 : UILabel!
    
    
    var dataArr =  [WOWNewForGoodsModel]() // 数组里存放字典 ，字典里存放model
    
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
        let dic1  = ["baoguo":4]
        let dic2  = ["baoguo":2]
        let dic3  = ["baoguo":3]
        
        goodsArray = [dic1,dic2,dic3]
        
        orderNumber          = 4
        orderNumber2         = 4
        orderNoNumber        = 4
        
        isOpen               = true
        request()
        WOWBorderColor(rightButton)
        navigationItem.title = "订单详情"
        configTableView()
        
        //        configBottomView()
    }
    
    private func configTableView(){
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
                self.rightButton.titleLabel?.text = "立即支付"
                self.priceLabel.text              = "¥"+((orderNewModel.orderAmount)?.toString)!
                
            case 1,4,5,6:
                self.OrderDetailNewaType = OrderNewType.noForGoods
                hideRightBtn()
                
                
            case 2:
                self.OrderDetailNewaType = OrderNewType.someFinishForGoods
                hideRightBtn()
                
                
            case 3:
                self.OrderDetailNewaType          = OrderNewType.forGoods
                self.clooseOrderButton.hidden     = true
                self.rightButton.titleLabel?.text = "确认收货"
                self.priceLabel.text              = "¥"+((orderNewModel.orderAmount)?.toString)!
                
            default:
                break
            }
        }
    }
    
    //MARK:Network
    override func request() {
        
        
        super.request()
        
        /**
         *  区分订单类型 UI
         */
        
        orderType()
        
        if let orderNewModel = orderNewModel {
            
            WOWNetManager.sharedManager.requestWithTarget(.Api_OrderDetail(OrderCode:orderNewModel.orderCode!), successClosure: { [weak self](result) in
                
                if let strongSelf = self{
                    
                    strongSelf.orderNewDetailModel = Mapper<WOWNewOrderDetailModel>().map(result)
                    
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
        case .forGoods,.noForGoods:
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
            case 2: //商品清单
                if let orderNewDetailModel = orderNewDetailModel {
                    return orderNewDetailModel.unShipOutOrderItems!.count > 3 ? 3 : orderNewDetailModel.unShipOutOrderItems!.count
                }else{
                    return 0
                }
                
            case 3: //运费
                return 2
            case 4: //支付方式
                return 2
            default:
                return 1
            }
        case .forGoods:
            switch section {
            case 0: //订单
                
                return 2
                
            case 1: //收货人
                return 1
            case 2: //商品清单
                if let orderNewDetailModel = orderNewDetailModel {
                    return orderNewDetailModel.unShipOutOrderItems!.count > 3 ? 3 : orderNewDetailModel.unShipOutOrderItems!.count
                }else{
                    return 0
                }
                
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
            case 2: //商品清单
                if let orderNewDetailModel = orderNewDetailModel {
                    return orderNewDetailModel.unShipOutOrderItems!.count > 3 ? 3 : orderNewDetailModel.unShipOutOrderItems!.count
                }else{
                    return 0
                }
                
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
                return (orderNoNumber > 3 ? 3 : orderNoNumber)
            case goodsArray.count + 3 :
                return 2
            default:
                
                let goods = goodsArray[section - 2]
                
                return (goods["baoguo"]! + 1) > 3 ? 4 : (goods["baoguo"]! + 1)
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
            
        case .forGoods,.noForGoods:
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
                    
                    cell.showData(orderNewDetailModel)
                    
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
            
        case .forGoods,.noForGoods:
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
                    cell.personNameLabel.text = "由 顺丰快递 派送中"
                    cell.addressLabel.text    = "运单号： 120999393939339"
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
                    
                    cell.showData(orderNewDetailModel)
                    
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
                returnCell = cell
            case 1:
                let cell   = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailSThreeCell", forIndexPath: indexPath) as! WOWOrderDetailSThreeCell
                returnCell = cell
            case goodsArray.count + 2 :
                let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailNewCell", forIndexPath: indexPath) as! WOWOrderDetailNewCell
                returnCell = cell
            case goodsArray.count + 3 :
                let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailCostCell", forIndexPath: indexPath) as! WOWOrderDetailCostCell
                
                returnCell = cell
                
                
            default:
                let cellID = "MenuCell1"
                var cell   = tableView.dequeueReusableCellWithIdentifier(cellID)
                //                if cell == nil {
                cell  = WOWOrderDetailNewCell(style: .Default, reuseIdentifier:cellID)
                //                }
                
                if indexPath.row == 0 {
                    cell!.contentView.removeSubviews()
                    //                    cell?.detailTextLabel?.hidden = true
                    //                    cell
                    
                    //                     cell!.contentView.titleImageView.hidden = true
                    //                    cell .titleLabel.hidden = true
                    //                    cell .colorLabel.hidden = true
                    //                     cell .contentLabel.hidden = true
                    //                    cell .priceLabel.hidden = true
                    //                     cell .goodsNumber.hidden = true
                    
                    let deliveryName = UILabel()
                    deliveryName.text        = "包裹1： 顺丰快递"
                    deliveryName.frame       = CGRectMake(15, 10, 200, 20)
                    deliveryName.textColor   = UIColor.blackColor()
                    deliveryName.font        = UIFont.systemFontOfSize(14)
                    cell!.contentView.addSubview(deliveryName)
                    
                    let deliveryNumber       = UILabel()
                    deliveryNumber.text      = "运单号： 2223232323323"
                    deliveryNumber.frame     = CGRectMake(15, 35, 200, 20)
                    //                    deliveryNumber.textColor = UIColor.init(rgba: "")
                    deliveryNumber.textColor = UIColor.init(hexString: "808080")
                    deliveryNumber.font      = UIFont.systemFontOfSize(12)
                    cell!.contentView.addSubview(deliveryNumber)
                    
                }
                returnCell = cell
            }
            
        }
        
        
        
        
        //        returnCell.selectionStyle = .None
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
                return 0.01
            case 1:
                return 38
                
            case goodsArray.count + 2 ,2:
                return 38
                
            case goodsArray.count + 3 :
                return 12
            default:
                return 12
            }
            
            
        default:
            switch section {
            case 0:
                return 0.01
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
        case .forGoods,.noForGoods:
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
            switch section {
            case 0:
                return 0.01
            case 1:
                return 0.01
            case goodsArray.count + 2:
                
                return orderNoNumber > 3 ? 40 : 0.01
                
            case goodsArray.count + 3:
                
                return 0.01
                
            default:
                let goods = goodsArray[section - 2]
                
                return (goods["baoguo"]! + 1) > 3 ? 40 : 0.01
                
                
            }
            
            
            
        default:
            if let orderNewDetailModel = orderNewDetailModel {
                
                guard orderNewDetailModel.unShipOutOrderItems!.count > 3 else {
                    return 0.01
                }
                
                if section == 2 {
                    return 40
                }
                return 0.01
            }else{
                return 0.01
            }
        }
        
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        switch OrderDetailNewaType {
        case .someFinishForGoods:
            switch section {
            case 0:
                return nil
            case 1:
                return nil
                
            case goodsArray.count + 3:
                return nil
            case goodsArray.count + 2:
                return orderNoNumber > 3 ? footSectionView() : nil
            // FIXME:
            default:
                let goods = goodsArray[section - 2]
                
                return (goods["baoguo"]! + 1) > 3 ? footSectionView() : nil
                
                
            }
            
            
            
        default:
            if let orderNewDetailModel = orderNewDetailModel {
                guard orderNewDetailModel.unShipOutOrderItems!.count > 3 else {
                    return nil
                }
                
                if section == 2 {
                    return footSectionView()
                }
                return nil
                
            }else{
                return nil
            }
            
        }
        
        //        return nil
    }
    func footSectionView() -> UIView {
        let view = UIView()
        view.frame = CGRectMake(0, 0, MGScreenWidth, 40)
        view.backgroundColor = UIColor.whiteColor()
        
        let likeButton = UIButton(type: .System)
        likeButton.frame = CGRectMake(0, 0, 100, 40)
        likeButton.center = view.center
        likeButton.centerX = view.centerX - 10
        likeButton.titleLabel?.font = UIFont.systemFontOfSize(12)
        likeButton.setTitleColor(GrayColorlevel3, forState: .Normal)
        likeButton.setTitle("共7件", forState: .Normal)
        
        likeButton.setImage(UIImage(named: "downOrder")?.imageWithRenderingMode(.AlwaysOriginal), forState: .Normal)
        likeButton.imageEdgeInsets = UIEdgeInsetsMake(10, 70, 10, 10)
        likeButton.addTarget(self, action: #selector(clickAction(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(likeButton)
        
        
        return view
        
    }
    
    func clickAction(sender:UIButton)  {
        
        if isOpen == true {
            orderNumber = 7
            isOpen = false
        }else{
            orderNumber = 3
            isOpen = true
        }
        
        tableView.reloadData()
        
    }
    func tableView(tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = MGRgb(109, g: 109, b: 114)
            headerView.textLabel?.font = Fontlevel003
        }
    }
}
