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
    var productArr                      :[WOWCarProductModel]!
    var addressArr                      = [WOWAddressListModel]()
    
    //post的参数
    fileprivate var tipsTextField           : HolderTextView!
    fileprivate var addressID               : String?
    fileprivate var payType                 = "ali"
    
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
        tableView.register(UINib.nibName(String(describing: WOWAddressCell())), forCellReuseIdentifier:String(describing: WOWAddressCell()))
        tableView.register(UINib.nibName(String(describing: WOWValue1Cell())), forCellReuseIdentifier:String(describing:WOWValue1Cell()))
        tableView.register(UINib.nibName(String(describing: WOWSenceLikeCell())), forCellReuseIdentifier:String(describing:WOWSenceLikeCell()))
        tableView.register(UINib.nibName(String(describing: WOWTipsCell())), forCellReuseIdentifier:String(describing:WOWTipsCell()))
        tableView.register(UINib.nibName(String(describing: WOWValue2Cell())), forCellReuseIdentifier:String(describing:WOWValue2Cell()))
        tableView.keyboardDismissMode = .onDrag
        tableView.selectRow(at: IndexPath(row: 0, section: 1), animated: true, scrollPosition: .none)
    }
    
    
//MARK:Actions
    
    @IBAction func payButtonClick(_ sender: UIButton) {
        guard let addressid = addressID else{
            WOWHud.showMsg("请先选择收货地址")
            return
        }
        let tips = tipsTextField.text ?? ""
        let uid  = WOWUserManager.userID
        var productParam = [AnyObject]()
//        for item in productArr {
//            let dict = ["skuid":item.skuID,"count":item.skuProductCount,"productid":item.productID]
//            productParam.append(dict)
//        }
        let requestParam  = ["cart":productParam,"uid":uid,"pay_method":payType,"tips":tips,"address_id":addressid] as [String : Any]
        let requestString = JSONStringify(requestParam as AnyObject)
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_CartCommit(car:requestString), successClosure: { [weak self](result) in
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
                    strongSelf.goPay(charge.object as AnyObject,totalPrice: totalPrice,orderid: orderid)
                }
            }
        }) { (errorMsg) in
                
        }
    }
    
    fileprivate func updateCarCountBadge(){
        WOWBuyCarMananger.updateBadge()
        NotificationCenter.postNotificationNameOnMainThread(WOWUpdateCarBadgeNotificationKey, object: nil)
    }
    
    
    fileprivate func goPay(_ charge:AnyObject,totalPrice:String,orderid:String){
        DispatchQueue.main.async { 
            Pingpp.createPayment(charge as! NSObject, appURLScheme:WOWDSGNSCHEME) {[weak self] (ret, error) in
                if let strongSelf = self,let ret_str = ret as! String {
                    switch ret_str{
                    case "success":
                        let vc = UIStoryboard.initialViewController("BuyCar", identifier:"WOWPaySuccessController") as! WOWPaySuccessController
                        vc.payMethod = (strongSelf.payType == "ali" ? "支付宝":"微信")
                        vc.orderid = orderid
                        
                        vc.totalPrice = "¥ " + String(format: "%@",totalPrice ?? "")
                        
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
    
    fileprivate func resolveOrderRet(){
//        let vc = UIStoryboard.initialViewController("User", identifier:String(WOWOrderController)) as! WOWOrderController
//        vc.selectIndex = 0
        let vc = WOWOrderListViewController()
//        vc.entrance = OrderEntrance.PaySuccess
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
//MARK:Network
    override func request() {
        super.request()
        //请求地址数据
//        let uid =  WOWUserManager.userID
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_Addresslist, successClosure: { [weak self](result) in
            if let strongSelf = self{
                let arr = Mapper<WOWAddressListModel>().mapArray(JSONObject:result)
                if let array = arr{
                    strongSelf.addressArr = []
                    strongSelf.addressArr.append(contentsOf: array)
                    strongSelf.tableView.reloadData()
                    strongSelf.tableView.selectRow(at: IndexPath(row: 0, section: 1), animated: true, scrollPosition: .none)
                }
            }
        }) { (errorMsg) in
                
        }
    }
    
}


extension WOWSureOrderController:UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell:UITableViewCell?
        switch (indexPath as NSIndexPath).section {
        case 0: //地址
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WOWAddressCell()), for: indexPath) as! WOWAddressCell
            cell.isUserInteractionEnabled = false
            cell.checkButton.isSelected = true
            cell.showData(addressArr[(indexPath as NSIndexPath).row])
            addressID = String(describing: addressArr[(indexPath as NSIndexPath).row].id)
            returnCell = cell
        case 1: //支付方式
            let type = ["支付宝","微信支付"]
            let titles = ["支","微"]
            let colors = [MGRgb(84, g: 199, b: 252),MGRgb(68, g: 219, b: 94)]
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WOWValue1Cell()), for: indexPath) as! WOWValue1Cell
            cell.leftButton.borderRadius(6)
            cell.leftButton.backgroundColor = colors[indexPath.row]
            cell.leftLabel?.text = type[(indexPath as NSIndexPath).row]
            cell.leftButton.setTitle(titles[(indexPath as NSIndexPath).row], for:UIControlState())
            returnCell = cell
        case 2: //商品清单
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WOWSenceLikeCell()), for: indexPath) as! WOWSenceLikeCell
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
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WOWTipsCell()), for:indexPath) as! WOWTipsCell
            tipsTextField = cell.textView
            returnCell = cell
        case 4: //订单汇总
            let titles = ["订单合计","运费","实付金额"]
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WOWValue2Cell()), for:indexPath) as! WOWValue2Cell
            cell.isUserInteractionEnabled = false
            cell.leftViseLabel.isHidden = (indexPath as NSIndexPath).row == 0 ? false : true
            cell.leftLabel.text = titles[(indexPath as NSIndexPath).row]
            switch (indexPath as NSIndexPath).row {
            case 0,2:
                cell.rightLabel.text = "¥" + (totalPrice ?? "")
            default:
                cell.rightLabel.text = "¥ 0.0"
            }
            cell.leftViseLabel.text = "(共\(productArr.count)件)"
            if (indexPath as NSIndexPath).row == 2 {
                cell.leftLabel.font = FontMediumlevel003
            }
            returnCell = cell
        default:
            break
        }
        return returnCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).section {
        case 1:
            if (indexPath as NSIndexPath).row == 0 {
                payType = "ali"
            }else{
                payType = "wx"
            }
        default:
            break
        }
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let titles = ["收货信息","支付方式","商品清单","订单备注","订单汇总"]
        return titles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = MGRgb(109, g: 109, b: 114)
            headerView.textLabel?.font = Fontlevel003
        }
    }
    
    //尾视图  只有地址栏需要
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 { //地址
            let footerView = WOWMenuTopView(leftTitle: "", rightHiden:false, topLineHiden: true, bottomLineHiden: false)
            if addressArr.isEmpty {
                footerView.leftLabel.text = "增加收货地址"
                footerView.addAction({[weak self] in
                    if let strongSelf = self{
                        let addvc = UIStoryboard.initialViewController("User", identifier:String(describing: WOWAddAddressController)) as! WOWAddAddressController
                        addvc.entrance = .sureOrder
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
                        let addvc = UIStoryboard.initialViewController("User", identifier:String(describing: WOWAddressController)) as! WOWAddressController
                        addvc.entrance = .sureOrder
                        addvc.selectModel = strongSelf.addressArr.first
                        addvc.action = {(model:AnyObject) in
                            let m = model as! WOWAddressListModel
                            strongSelf.addressID = String(describing: m.id)
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
    
   
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 41
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 44
        }else{
            return 0.01
        }
    }
}

