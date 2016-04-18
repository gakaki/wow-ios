//
//  WOWSureOrderController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/14.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWSureOrderController: WOWBaseViewController {

    @IBOutlet weak var goodsCountLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK:Private Method
    override func setUI() {
        makeBackButton("购物车")
        navigationItem.title = "确认订单"
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = GrayColorLevel5
        tableView.registerNib(UINib.nibName(String(WOWAddressCell)), forCellReuseIdentifier:String(WOWAddressCell))
        tableView.registerNib(UINib.nibName(String(WOWValue1Cell)), forCellReuseIdentifier:String(WOWValue1Cell))
        tableView.registerNib(UINib.nibName(String(WOWSenceLikeCell)), forCellReuseIdentifier:String(WOWSenceLikeCell))
        tableView.registerNib(UINib.nibName(String(WOWTipsCell)), forCellReuseIdentifier:String(WOWTipsCell))
        tableView.registerNib(UINib.nibName(String(WOWValue2Cell)), forCellReuseIdentifier:String(WOWValue2Cell))
        tableView.keyboardDismissMode = .OnDrag
    }
    
    
//MARK:Actions
    
    @IBAction func payButtonClick(sender: UIButton) {
        DLog("结算")
        let vc = UIStoryboard.initialViewController("BuyCar", identifier:"WOWPaySuccessController") as! WOWPaySuccessController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension WOWSureOrderController:UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:     //地址
            return 2
        case 1:     //支付方式
            return 2
        case 2,3:   //商品清单,订单备注
            return 1
        case 4:     //订单汇总
            return 3
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var returnCell:UITableViewCell?
        switch indexPath.section {
        case 0: //地址
            let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWAddressCell), forIndexPath: indexPath) as! WOWAddressCell
            returnCell = cell
        case 1: //支付方式
            let type = ["支付宝","微信支付"]
            let titles = ["支","微"]
            let colors = [MGRgb(84, g: 199, b: 252),MGRgb(68, g: 219, b: 94)]
            let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWValue1Cell), forIndexPath: indexPath) as! WOWValue1Cell
            cell.leftButton.borderRadius(6)
            cell.leftButton.backgroundColor = colors[indexPath.row]
            cell.leftLabel?.text = type[indexPath.row]
            cell.leftButton.setTitle(titles[indexPath.row], forState:.Normal)
            returnCell = cell
        case 2: //商品清单
            let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWSenceLikeCell), forIndexPath: indexPath) as! WOWSenceLikeCell
            cell.orderTag = true
            cell.rightTitleLabel.text = "共xx件"
            cell.rightBackView.addAction({ [weak self] in
                if let strongSelf = self{
                    let vc = UIStoryboard.initialViewController("BuyCar", identifier:"WOWCarGoodsListController") as! WOWCarGoodsListController
                    strongSelf.navigationController?.pushViewController(vc, animated: true)
                }
            })
            returnCell = cell
        case 3: //订单备注
            let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWTipsCell), forIndexPath:indexPath) as! WOWTipsCell
            returnCell = cell
        case 4: //订单汇总
            let titles = ["订单合计","运费","实付金额"]
            let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWValue2Cell), forIndexPath:indexPath) as! WOWValue2Cell
            cell.leftViseLabel.hidden = indexPath.row == 0 ? false : true
            cell.leftLabel.text = titles[indexPath.row]
            //FIXME:测试数据
            cell.rightLabel.text = "¥ 00000"
            cell.leftViseLabel.text = "(共多少件)"
            if indexPath.row == 2 {
                cell.leftLabel.font = FontMediumlevel003
            }
            returnCell = cell
        default:
            break
        }
        return returnCell!
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let titles = ["收货信息","支付方式","商品清单","订单备注","订单汇总"]
        return titles[section]
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = MGRgb(109, g: 109, b: 114)
            headerView.textLabel?.font = Fontlevel003
        }
    }
    
    
    //尾视图  只有地址栏需要
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 { //地址
            let footerView = WOWMenuTopView(leftTitle: "其他收货地址", rightHiden:false, topLineHiden: true, bottomLineHiden: false)
            footerView.leftLabel.textColor = GrayColorlevel1
            footerView.addAction({[weak self] in
                if let strongSelf = self{
                    let addvc = UIStoryboard.initialViewController("User", identifier:String(WOWAddressController)) as! WOWAddressController
                    addvc.entrance = .SureOrder
                    strongSelf.navigationController?.pushViewController(addvc, animated: true)
                }
            })
            return footerView
        }
        return nil
    }
    
   
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 41
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 44
        }else{
            return 0.01
        }
    }
}

