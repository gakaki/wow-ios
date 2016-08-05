//
//  WOWEditOrderController.swift
//  wowapp
//
//  Created by 安永超 on 16/8/3.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWEditOrderController: WOWBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var productArr                      :[WOWCarProductModel]?
    var orderSettle                     :WOWEditOrderModel?
    var totalPrice                      : String?
    var addressInfo                     :WOWAddressListModel?
    var orderCode                       : String? //订单号
    private var tipsTextField           : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        request()
        requestProduct()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - lazy
    lazy var backView:WOWPayBackView = {
        let v = WOWPayBackView(frame:CGRectMake(0,0,self.view.w,self.view.h + 64))
        v.payView.delegate = self
        return v
    }()
    
    //MARK: - 弹出选择支付窗口
    func chooseStyle() {
        let window = UIApplication.sharedApplication().windows.last
        
        window?.addSubview(backView)
        window?.bringSubviewToFront(backView)
        backView.show()
    }

    
    //MARK:Private Method
    override func setUI() {
        navigationItem.title = "填写订单"
        totalPriceLabel.text = "¥ " + (totalPrice ?? "")
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = GrayColorLevel5
        tableView.registerNib(UINib.nibName(String(WOWOrderAddressCell)), forCellReuseIdentifier:String(WOWOrderAddressCell))
        tableView.registerNib(UINib.nibName(String(WOWOrderCell)), forCellReuseIdentifier:String(WOWOrderCell))
        tableView.registerNib(UINib.nibName(String(WOWOrderFreightCell)), forCellReuseIdentifier:String(WOWOrderFreightCell))
        tableView.registerNib(UINib.nibName(String(WOWTipsCell)), forCellReuseIdentifier:String(WOWTipsCell))
        tableView.keyboardDismissMode = .OnDrag
 
    }
    
    //MARK: - Action
    @IBAction func sureClick(sender: UIButton) {
        chooseStyle()
       
        guard let orderCode = orderCode else {
            requestOrderCreat()
            return
        }

    }
    
    
    //MARK:Network
    override func request() {
        super.request()
        //请求地址数据
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_AddressDefault, successClosure: { [weak self](result) in
            if let strongSelf = self{
                strongSelf.addressInfo = Mapper<WOWAddressListModel>().map(result)
                let section = NSIndexSet(index: 0)
                strongSelf.tableView.reloadSections(section, withRowAnimation: .None)
            
            }
        }) { (errorMsg) in
            
        }
    }
    
    //请求商品列表
    func requestProduct() -> Void {
        WOWNetManager.sharedManager.requestWithTarget(.Api_OrderSettle, successClosure: { [weak self](result) in
            if let strongSelf = self {
                strongSelf.orderSettle = Mapper<WOWEditOrderModel>().map(result)
                strongSelf.productArr = strongSelf.orderSettle?.orderSettles ?? [WOWCarProductModel]()
                strongSelf.totalPriceLabel.text = String(format:"%.2f",(strongSelf.orderSettle?.totalAmount) ?? 0)
                let section = NSIndexSet(index: 1)
                strongSelf.tableView.reloadSections(section, withRowAnimation: .None)
            }
            
            }) { (errorMsg) in
                
        }
    }
    
    //请求创建订单
    func requestOrderCreat() -> Void {
        var params = [String: AnyObject]?()
        params = ["shippingInfoId": (addressInfo?.id)!, "orderSource": 2, "orderAmount": (orderSettle?.totalAmount)!, "remark": tipsTextField.text ?? ""]
        WOWNetManager.sharedManager.requestWithTarget(.Api_OrderCreate(params: params), successClosure: { [weak self](result) in
            if let strongSelf = self {
                strongSelf.orderCode = JSON(result)["orderCode"].string
            }
            
            }) { (errorMsg) in
                
        }
    }
    
    //去支付
    private func goPay(charge:AnyObject,totalPrice:String,orderid:String){
        dispatch_async(dispatch_get_main_queue()) {
            Pingpp.createPayment(charge as! NSObject, appURLScheme:WOWDSGNSCHEME) {[weak self] (ret, error) in
                if let strongSelf = self{
                    switch ret{
                    case "success":
                        let vc = UIStoryboard.initialViewController("BuyCar", identifier:"WOWPaySuccessController") as! WOWPaySuccessController
//                        vc.payMethod = (strongSelf.payType == "ali" ? "支付宝":"微信")
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
    
}

extension WOWEditOrderController:UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:     //地址
            return 1
        case 1:     //商品清单
            return productArr?.count ?? 0
        case 2:   //运费，优惠券
            return 2
        case 3:     //订单备注
            return 1
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var returnCell:UITableViewCell?
        switch indexPath.section {
        case 0: //地址
            let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWOrderAddressCell), forIndexPath: indexPath) as! WOWOrderAddressCell
            cell.showData(addressInfo)
            returnCell = cell
        case 1: //商品清单
            let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWOrderCell), forIndexPath: indexPath) as! WOWOrderCell
            if let productArr = productArr {
                cell.showData(productArr[indexPath.row])
            }
            returnCell = cell
        case 2: //运费及优惠券信息
            let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWOrderFreightCell), forIndexPath: indexPath) as! WOWOrderFreightCell
            if indexPath.row == 0 {
                cell.leftLabel.text = "运费"
                cell.freightPriceLabel.text = String(format:"%.2f",(self.orderSettle?.deliveryFee) ?? 0)
                cell.couponLabel.hidden = true
                cell.nextImage.hidden = true
                cell.freightPriceLabel.hidden = false
                cell.freightInfoImage.hidden = false
                cell.lineView.hidden = false
            }else {
                cell.leftLabel.text = "优惠券"
                cell.freightPriceLabel.hidden = true
                cell.freightInfoImage.hidden = true
                cell.nextImage.hidden = false
                cell.couponLabel.hidden = false
                cell.lineView.hidden = true
                cell.couponLabel.text = String(format:"-¥ %.0f",(self.orderSettle?.deliveryFee) ?? 0)
            }
            returnCell = cell
        case 3: //订单备注
            let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWTipsCell), forIndexPath:indexPath) as! WOWTipsCell
            tipsTextField = cell.textField
            returnCell = cell
        default:
            break
        }
        return returnCell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            print("跳到收货地址")
            
            let vc = UIStoryboard.initialViewController("User", identifier:String(WOWAddressController)) as! WOWAddressController
            vc.entrance = WOWAddressEntrance.SureOrder
            vc.action = {(model:AnyObject) in
                self.addressInfo = model as? WOWAddressListModel
                self.tableView.reloadData()
                
            }
            navigationController?.pushViewController(vc, animated: true)
            

        default:
            break
        }
    }
    

    
    //尾视图  只有地址栏需要
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 { //地址
            let footerView = NSBundle.mainBundle().loadNibNamed(String(WOWOrderFooterView), owner: self, options: nil).last as!WOWOrderFooterView
            footerView.countLabel.text = "共\(self.productArr?.count ?? 0)件"
            footerView.totalPriceLabel.text = String(format:"%.2f",(self.orderSettle?.productTotalAmount) ?? 0)
            return footerView
        }
        return nil
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 1 ,3:
            return 50
        default:
            return 0.01
        }
    }
}

//MARK: - selectPayDelegate
extension WOWEditOrderController: selectPayDelegate {
    func surePay(channel: String) {
        backView.hidePayView()
        guard let orderCode = orderCode else {
            print("订单生成失败")
            return
        }
        WOWNetManager.sharedManager.requestWithTarget(.Api_OrderCharge(orderNo: orderCode ?? "", channel: channel, clientIp: "192.168.1.1"), successClosure: { [weak self](result) in
            if let strongSelf = self {
                let json = JSON(result)
                let charge = json["charge"]
                strongSelf.goPay(charge.object, totalPrice: strongSelf.totalPrice ?? "", orderid: orderCode)
            }
            
            }) { (errorMsg) in
                
        }
        print("确定支付",channel)
    }
}

