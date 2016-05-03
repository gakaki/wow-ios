//
//  WOWOrderDetailController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/16.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWOrderDetailController: WOWBaseViewController {
    var orderModel                  : WOWOrderListModel!
    @IBOutlet weak var tableView    : UITableView!
    @IBOutlet weak var countLabel   : UILabel!
    @IBOutlet weak var priceLabel   : UILabel!
    @IBOutlet weak var rightButton  : UIButton!
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
        //FIXME:按钮状态 上面显示的文字做下配置咯
        var buttonTtile = ""
        switch orderModel.status ?? 0 {
        case 0:
            buttonTtile = "立即支付"
        case 2: //待发货，待收货
            buttonTtile = "确认收货"
        case 3: //待评价
            buttonTtile = "立即评价"
        case 1,4: //完成订单
            rightButton.hidden = true
        default:
            break
        }
        rightButton.setTitle(buttonTtile, forState:.Normal)
    }
    
    
    @IBAction func rightButtonClick(sender: UIButton) {
        switch orderModel.status ?? 0 {
        case 0:
            DLog("去支付吧")
        case 1,2:
            DLog("确认收货")
        case 3:
            DLog("去评价吧")
        default:
            break
        }
    }
}


extension WOWOrderDetailController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: //订单
            if orderModel.status == 1 {//待发货
                return 1
            }
            return 2
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
            cell.accessoryType = indexPath.row == 1 ? .DisclosureIndicator : .None
            cell.statusLabel.hidden = indexPath.row == 1 ? true : false
            if indexPath.row == 0{ //订单
                cell.statusLabel.text = orderModel.status_chs
                cell.topLabel.text = "订单：\(orderModel.id ?? "")"
                cell.leftLabel.text = orderModel.created_at
            }else{ //快递
                //FIXME:快递
                cell.topLabel.text = "物流公司"
                cell.leftLabel.text = "运单号：xxxxxxxxx"
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
            cell.hideLeftCheck()
            cell.checkButton.hidden = true
            let itemModel = self.orderModel.products![indexPath.row]
        cell.goodsImageView.kf_setImageWithURL(NSURL(string:itemModel.imageUrl ?? "")!, placeholderImage: UIImage(named: "placeholder_product"))
            cell.nameLabel.text = itemModel.name
            cell.typeLabel.text = itemModel.sku_title
            cell.perPriceLabel.text = itemModel.price?.priceFormat()
            cell.countLabel.text = "x \(itemModel.count ?? "")"
            returnCell = cell
        default:
            break
        }
        return returnCell
    }
    
    
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
