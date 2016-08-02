//
//  WOWOrderDetailController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/16.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

protocol OrderDetailDelegate:class{
    func orderStatusChange()
}


class WOWOrderDetailController: WOWBaseViewController{
    var orderModel                  : WOWOrderListModel!
    @IBOutlet weak var tableView    : UITableView!
    @IBOutlet weak var countLabel   : UILabel!
    @IBOutlet weak var priceLabel   : UILabel!
    @IBOutlet weak var rightButton  : UIButton!
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
        WOWBorderColor(rightButton)
        navigationItem.title = "订单详情"
        configTableView()
        configBottomView()
    }
    
    private func configTableView(){
        tableView.estimatedRowHeight = 80
        tableView.registerNib(UINib.nibName("WOWBuyCarNormalCell"), forCellReuseIdentifier: "WOWBuyCarNormalCell")
        tableView.registerNib(UINib.nibName("WOWAddressCell"), forCellReuseIdentifier: "WOWAddressCell")
        tableView.registerNib(UINib.nibName("WOWOrderTransCell"), forCellReuseIdentifier: "WOWOrderTransCell")
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
        vc.orderID = orderModel.id ?? ""
        vc.delegate = self
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
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: //订单
            switch orderModel.status ?? 2 { //因为后端把为2的改为字符串了。。。唉，不知道什么时候改了
            case 0,1,5: //待付款，待发货，已关闭，不需要看物流的
                return 1
            default:
                return 2
            }
            
        case 1: //收货人
            return 1
        case 2: //商品清单
            return orderModel.products?.count ?? 0
        default:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 56
        case 1:
            return 64
        case 2:
            return 108
        default:
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var returnCell:UITableViewCell!
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderTransCell", forIndexPath: indexPath) as! WOWOrderTransCell
//            cell.accessoryType = indexPath.row == 1 ? .DisclosureIndicator : .None
            cell.statusLabel.hidden = indexPath.row == 1 ? true : false
            if indexPath.row == 0{ //订单
                cell.statusLabel.text = orderModel.status_chs
                cell.topLabel.text = "订单：\(orderModel.id ?? "")"
                cell.leftLabel.text = orderModel.created_at
                statusLabel = cell.statusLabel
            }else{ //快递
                cell.topLabel.text = "物流公司：" + (orderModel.transCompany ?? "暂无信息")
                cell.leftLabel.text = "运单号："  + (orderModel.transNumber ?? "暂无信息")
            }
            returnCell = cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("WOWAddressCell", forIndexPath: indexPath) as! WOWAddressCell
                cell.checkButton.hidden = true
            cell.detailAddressLabel.text = orderModel.address_full
            cell.phoneLabel.text = orderModel.address_mobile
            cell.nameLabel.text  = orderModel.address_username
            returnCell = cell
            
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("WOWBuyCarNormalCell", forIndexPath: indexPath) as! WOWBuyCarNormalCell
//            cell.checkButton.hidden = true
//            cell.hideLeftCheck()

            let itemModel = self.orderModel.products![indexPath.row]
        cell.goodsImageView.kf_setImageWithURL(NSURL(string:itemModel.imageUrl ?? "")!, placeholderImage: UIImage(named: "placeholder_product"))
            cell.nameLabel.text = itemModel.name
//            cell.typeLabel.text = itemModel.sku_title
            cell.perPriceLabel.text = itemModel.price?.priceFormat()
            cell.countLabel.text = "x \(itemModel.count ?? "")"
            returnCell = cell
        default:
            break
        }
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
        switch section {
        case 0:
            return 0.01
        default:
            return 41
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let titles = [" ","收货人","商品清单"]
        return titles[section]
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = MGRgb(109, g: 109, b: 114)
            headerView.textLabel?.font = Fontlevel003
        }
    }
}
