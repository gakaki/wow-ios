//
//  WOWOrderDetailController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/16.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit


enum OrderNewType {
    case payMent            //= "待付款"
    case forGoods           //= "待收货"
    case finish             //= "已完成"
    case someFinishForGoods //= "部分完成"
}
protocol OrderDetailDelegate:class{
    func orderStatusChange()
}


class WOWOrderDetailController: WOWBaseViewController{
    var orderModel                  : WOWOrderListModel!
    var orderNewModel               : WOWNewOrderListModel!
    
    
    var forGoods1 : WOWNewForGoodsModel!
    var forProduct1 : WOWNewProductModel!
    var forProduct2 : WOWNewProductModel!
    var forProduct3 : WOWNewProductModel!
    
    var OrderDetailNewaType         : OrderNewType = .someFinishForGoods
    //    let orderNewType : String!
    var orderNumber                 : Int!
    var isOpen                      : Bool!
    @IBOutlet weak var tableView    : UITableView!
    @IBOutlet weak var countLabel   : UILabel!
    @IBOutlet weak var priceLabel   : UILabel!
    @IBOutlet weak var rightButton  : UIButton!
    var statusLabel                 : UILabel!

    
    var dataArr =  [WOWNewForGoodsModel]() // 数组里存放字典 ，字典里存放model
    
    weak var delegate               : OrderDetailDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        forGoods1.deliveryCompanyName = "天天快递"
        forGoods1.deliveryOrderNo = "2323232323"
        
        forProduct1.productName = "1"
        forProduct2.productName = "2"
        forProduct3.productName = "3"
        
        forGoods1.productArray = [forProduct1,forProduct2,forProduct3]
        
        dataArr.append(forGoods1)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK:Private Method
    override func setUI() {
        super.setUI()
        orderNumber = 3
        isOpen = true
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
        tableView.registerNib(UINib.nibName("WOWOrderDetailFourCell"), forCellReuseIdentifier: "WOWOrderDetailFourCell")
        tableView.registerNib(UINib.nibName("WOWOrderDetailPayCell"), forCellReuseIdentifier: "WOWOrderDetailPayCell")
        tableView.clearRestCell()
    }
    
    private func configBottomView(){
        countLabel.text  = "共\(orderModel.products?.count ?? 0)件商品"
        priceLabel.text  = orderModel.total?.priceFormat()
        var buttonTtile = ""
        switch orderModel.status ?? 2{
        case 0:
            buttonTtile = "立即支付"
        case 2: //待收货
            buttonTtile = "确认收货"
        case 3: //待评价
            buttonTtile = "立即评价"
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
                        strongSelf.orderModel.status = 1
                        strongSelf.rightButton.hidden = true
                        strongSelf.statusLabel.text = "待发货"
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
    
    private func commentOrder(){
        let vc = UIStoryboard.initialViewController("User", identifier:"WOWOrderCommentController") as! WOWOrderCommentController
        //        vc.orderID = orderModel.id ?? ""
        //        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //更改状态
    private func changeStatus(){
        let uid = WOWUserManager.userID
        let order_id = orderModel.id ?? ""
        var status = "2"
        switch orderModel.status ?? 2 {
        case 2: //目前为待收货
            status = "3" //待评价
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
        self.orderModel.status = 4 //已完成
        self.rightButton.hidden = true
        statusLabel.text = "已完成"
        callBack()
    }
}


extension WOWOrderDetailController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        switch OrderDetailNewaType {
        case .payMent:
            return 5
        case .forGoods:
            return 4
        case .someFinishForGoods:
            return 6
            
        default:
            break
        }
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch OrderDetailNewaType {
        case .payMent:
            switch section {
            case 0: //订单
                //            switch orderModel.status ?? 2 { //因为后端把为2的改为字符串了。。。唉，不知道什么时候改了
                //            case 0,1,5: //待付款，待发货，已关闭，不需要看物流的
                //                return 1
                //            default:
                //                return 2
                //            }
                return 1
                
            case 1: //收货人
                return 1
            case 2: //商品清单
                //            return orderModel.products?.count ?? 0
                return orderNumber
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
                //            switch orderModel.status ?? 2 { //因为后端把为2的改为字符串了。。。唉，不知道什么时候改了
                //            case 0,1,5: //待付款，待发货，已关闭，不需要看物流的
                //                return 1
                //            default:
                //                return 2
                //            }
                return 2
                
            case 1: //收货人
                return 1
            case 2: //商品清单
                //            return orderModel.products?.count ?? 0
                return orderNumber
            case 3: //运费
                return 2
            default:
                return 1
            }
        case .someFinishForGoods:
            switch section {
            case 0: //订单
                //            switch orderModel.status ?? 2 { //因为后端把为2的改为字符串了。。。唉，不知道什么时候改了
                //            case 0,1,5: //待付款，待发货，已关闭，不需要看物流的
                //                return 1
                //            default:
                //                return 2
                //            }
                return 1
                
            case 1: //收货人
                return 1
            case 2: //商品清单
                //            return orderModel.products?.count ?? 0
                return orderNumber
            case 3: //运费
                return 2
            case 4: //支付方式
                return 2
            default:
                return 2
            }
            
        default:
            return 0
        }
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch OrderDetailNewaType {
        case .payMent:
            switch indexPath.section {
            case 0:
                return 44
            case 1:
                return 70
            case 2:
                return 70
            case 3:
                return 50
            case 4:
                return 60
            default:
                return 0
            }
            
        case .forGoods:
            switch indexPath.section {
            case 0:
                if indexPath.row == 0 {
                    return 44
                }else{
                    return 70
                }
            case 1:
                return 70
            case 2:
                return 70
            case 3:
                return 50
            default:
                return 0
            }
        case .someFinishForGoods:
            switch indexPath.section {
            case 0:
                return 44
            case 1:
                return 70
            case 2:
                return 70
            case 3:
                return 70
            case 4:
                return 70
            case 5:
                return 50
            default:
                return 0
            }
            
            
        default:
            return 0
        }
        
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var returnCell:UITableViewCell!
        switch OrderDetailNewaType {
        case .payMent:
            switch indexPath.section {
            case 0:
                
                let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailTwoCell", forIndexPath: indexPath) as! WOWOrderDetailTwoCell
                returnCell = cell
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailSThreeCell", forIndexPath: indexPath) as! WOWOrderDetailSThreeCell
                returnCell = cell
                
            case 2:
                
                let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailNewCell", forIndexPath: indexPath) as! WOWOrderDetailNewCell
                returnCell = cell
                
            case 3:
                
                let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailFourCell", forIndexPath: indexPath) as! WOWOrderDetailFourCell
                returnCell = cell
            case 4:
                
                let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailPayCell", forIndexPath: indexPath) as! WOWOrderDetailPayCell
                if indexPath.row == 0 {
                    cell.payTypeImageView.image = UIImage(named: "alipay")
                    cell.payTypeLabel.text = "支付宝"
                }
                if indexPath.row == 1 {
                    cell.payTypeImageView.image = UIImage(named: "weixin")
                    cell.payTypeLabel.text = "微信支付"
                }
                
                returnCell = cell
                
            default:
                break
            }
            
        case .forGoods:
            switch indexPath.section {
            case 0:
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailTwoCell", forIndexPath: indexPath) as! WOWOrderDetailTwoCell
                    returnCell = cell
                }else{
                    let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailSThreeCell", forIndexPath: indexPath) as! WOWOrderDetailSThreeCell
                    returnCell = cell
                    
                }
                
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailSThreeCell", forIndexPath: indexPath) as! WOWOrderDetailSThreeCell
                
                returnCell = cell
                
            case 2:
                
                let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailNewCell", forIndexPath: indexPath) as! WOWOrderDetailNewCell
                returnCell = cell
                
            case 3:
                
                let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailFourCell", forIndexPath: indexPath) as! WOWOrderDetailFourCell
                returnCell = cell
                
            default:
                break
            }
        case .someFinishForGoods:
            switch indexPath.section {
            case 0:
                
                
                let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailTwoCell", forIndexPath: indexPath) as! WOWOrderDetailTwoCell
                returnCell = cell
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailSThreeCell", forIndexPath: indexPath) as! WOWOrderDetailSThreeCell
                returnCell = cell
                
            case 2:
                
                let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailNewCell", forIndexPath: indexPath) as! WOWOrderDetailNewCell
                returnCell = cell
                
            case 3:
                
                let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailNewCell", forIndexPath: indexPath) as! WOWOrderDetailNewCell
                returnCell = cell
            case 4:
                
                let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderDetailFourCell", forIndexPath: indexPath) as! WOWOrderDetailFourCell
                
                returnCell = cell
                
            default:
                break
            }
            
        default:
            break
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
                return 0.01
            case 4:
                return 12
            default:
                return 38
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
        case .forGoods:
            let titles = [" ","收货人","商品清单",""]
            return titles[section]
        case .someFinishForGoods:
            let titles = [" ","收货人","已发货商品清单","未商品清单",""]
            return titles[section]
        default:
            return nil
        }
        
        
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        if section == 2 {
            return 40
        }
        return 0.01
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 2 {
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
        
        return nil
    }
    
    func clickAction(sender:UIButton)  {
        print("你点击了")
        
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
