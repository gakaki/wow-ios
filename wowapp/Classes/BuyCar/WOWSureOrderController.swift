//
//  WOWSureOrderController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/14.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWSureOrderController: WOWBaseViewController {

    @IBOutlet weak var goodsCountLabel  : UILabel!
    @IBOutlet weak var totalPriceLabel  : UILabel!
    @IBOutlet weak var tableView        : UITableView!
    var totalPrice                      : String?
    var productArr                      :[WOWBuyCarModel]!
    var addressArr                      = [WOWAddressListModel]()
    
    //post的参数
    private var tipsTextField           : UITextField!
    private var addressID               : String?
    private var payType                 = "ali"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//MARK:Private Method
    override func setUI() {
        navigationItem.title = "确认订单"
        goodsCountLabel.text = "共\(productArr.count)件商品"
        totalPriceLabel.text = "¥ " + (totalPrice ?? "")
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = GrayColorLevel5
        tableView.registerNib(UINib.nibName(String(WOWAddressCell)), forCellReuseIdentifier:String(WOWAddressCell))
        tableView.registerNib(UINib.nibName(String(WOWValue1Cell)), forCellReuseIdentifier:String(WOWValue1Cell))
        tableView.registerNib(UINib.nibName(String(WOWSenceLikeCell)), forCellReuseIdentifier:String(WOWSenceLikeCell))
        tableView.registerNib(UINib.nibName(String(WOWTipsCell)), forCellReuseIdentifier:String(WOWTipsCell))
        tableView.registerNib(UINib.nibName(String(WOWValue2Cell)), forCellReuseIdentifier:String(WOWValue2Cell))
        tableView.keyboardDismissMode = .OnDrag
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1), animated: true, scrollPosition: .None)
    }
    
    
//MARK:Actions
    
    @IBAction func payButtonClick(sender: UIButton) {
        guard let addressid = addressID else{
            WOWHud.showMsg("请先选择收货地址")
            return
        }
        let tips = tipsTextField.text ?? ""
        let uid  = WOWUserManager.userID
        var productParam = [AnyObject]()
        for item in productArr {
            let dict = ["skuid":item.skuID,"count":item.skuProductCount,"productid":item.productID]
            productParam.append(dict)
        }
        let requestParam  = ["cart":productParam,"uid":uid,"pay_method":payType,"tips":tips,"address_id":addressid]
        let requestString = JSONStringify(requestParam)
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_CarCommit(car:requestString), successClosure: { [weak self](result) in
            if let strongSelf = self{
                let json = JSON(result)
                DLog(json)
                let productCount = json["productcount"].int ?? 0
                WOWUserManager.userCarCount = productCount
                strongSelf.updateCarCountBadge()
                let charge = json["charge"]
                let totalPrice = json["total"].string ?? ""
                let orderid    = json["order_id"].string ?? ""
                if charge != nil{
                    strongSelf.goPay(charge.object,totalPrice: totalPrice,orderid: orderid)
                }
            }
        }) { (errorMsg) in
                
        }
    }
    
    private func updateCarCountBadge(){
        WOWBuyCarMananger.updateBadge()
        NSNotificationCenter.postNotificationNameOnMainThread(WOWUpdateCarBadgeNotificationKey, object: nil)
    }
    
    
    private func goPay(charge:AnyObject,totalPrice:String,orderid:String){
        dispatch_async(dispatch_get_main_queue()) { 
            Pingpp.createPayment(charge as! NSObject, appURLScheme:WOWDSGNSCHEME) {[weak self] (ret, error) in
                if let strongSelf = self{
                    switch ret{
                    case "success":
                        let vc = UIStoryboard.initialViewController("BuyCar", identifier:"WOWPaySuccessController") as! WOWPaySuccessController
                        vc.payMethod = (strongSelf.payType == "ali" ? "支付宝":"微信")
                        vc.orderid = orderid
                        vc.totalPrice = totalPrice
                        strongSelf.navigationController?.pushViewController(vc, animated: true)
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
    
    private func resolveOrderRet(){
        let vc = UIStoryboard.initialViewController("User", identifier:String(WOWOrderController)) as! WOWOrderController
        vc.selectIndex = 0
        vc.entrance = OrderEntrance.PaySuccess
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
//MARK:Network
    override func request() {
        super.request()
        //请求地址数据
        let uid =  WOWUserManager.userID
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Addresslist(uid:uid), successClosure: { [weak self](result) in
            if let strongSelf = self{
                let arr = Mapper<WOWAddressListModel>().mapArray(result)
                if let array = arr{
                    strongSelf.addressArr = []
                    strongSelf.addressArr.appendContentsOf(array)
                    strongSelf.tableView.reloadData()
                    strongSelf.tableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1), animated: true, scrollPosition: .None)
                }
            }
        }) { (errorMsg) in
                
        }
    }
    
}


extension WOWSureOrderController:UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:     //地址
            return addressArr.count > 1 ? 1 : addressArr.count
        case 1:     //支付方式
            let ret = WXApi.isWXAppInstalled()
            return ret == true ? 2 : 1
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
            cell.userInteractionEnabled = false
            cell.checkButton.selected = true
            cell.showData(addressArr[indexPath.row])
            addressID = addressArr[indexPath.row].id
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
            cell.rightTitleLabel.text = "共\(productArr.count)件"
            cell.orderArr = productArr
            cell.rightBackView.addAction({ [weak self] in
                if let strongSelf = self{
                    let vc = UIStoryboard.initialViewController("BuyCar", identifier:"WOWCarGoodsListController") as! WOWCarGoodsListController
                    vc.productArr = strongSelf.productArr
                    strongSelf.navigationController?.pushViewController(vc, animated: true)
                }
            })
            returnCell = cell
        case 3: //订单备注
            let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWTipsCell), forIndexPath:indexPath) as! WOWTipsCell
            tipsTextField = cell.textField
            returnCell = cell
        case 4: //订单汇总
            let titles = ["订单合计","运费","实付金额"]
            let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWValue2Cell), forIndexPath:indexPath) as! WOWValue2Cell
            cell.userInteractionEnabled = false
            cell.leftViseLabel.hidden = indexPath.row == 0 ? false : true
            cell.leftLabel.text = titles[indexPath.row]
            switch indexPath.row {
            case 0,2:
                cell.rightLabel.text = "¥" + (totalPrice ?? "")
            default:
                cell.rightLabel.text = "¥ 0.0"
            }
            cell.leftViseLabel.text = "(共\(productArr.count)件)"
            if indexPath.row == 2 {
                cell.leftLabel.font = FontMediumlevel003
            }
            returnCell = cell
        default:
            break
        }
        return returnCell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 1:
            if indexPath.row == 0 {
                payType = "ali"
            }else{
                payType = "wx"
            }
        default:
            break
        }
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
            let footerView = WOWMenuTopView(leftTitle: "", rightHiden:false, topLineHiden: true, bottomLineHiden: false)
            if addressArr.isEmpty {
                footerView.leftLabel.text = "增加收货地址"
                footerView.addAction({[weak self] in
                    if let strongSelf = self{
                        let addvc = UIStoryboard.initialViewController("User", identifier:String(WOWAddAddressController)) as! WOWAddAddressController
                        addvc.entrance = .SureOrder
                        addvc.action = {
                            strongSelf.request()
                        }
                        strongSelf.navigationController?.pushViewController(addvc, animated: true)

                    }
                })
            }else{
                footerView.leftLabel.text = "其他收货地址"
                footerView.addAction({[weak self] in
                    if let strongSelf = self{
                        let addvc = UIStoryboard.initialViewController("User", identifier:String(WOWAddressController)) as! WOWAddressController
                        addvc.entrance = .SureOrder
                        addvc.selectModel = strongSelf.addressArr.first
                        addvc.action = {(model:AnyObject) in
                            let m = model as! WOWAddressListModel
                            strongSelf.addressID = m.id
                            strongSelf.addressArr = [m]
                            strongSelf.tableView.reloadData()
                        }
                        strongSelf.navigationController?.pushViewController(addvc, animated: true)
                    }
                })
            }
            footerView.leftLabel.textColor = GrayColorlevel1
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
