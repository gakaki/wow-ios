//
//  WOWOrderController.swift
//  Wow
//
//  Created by 小黑 on 16/4/11.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

enum OrderEntrance {
    case PaySuccess
    case User
}

class WOWOrderController: WOWBaseViewController {
    var entrance = OrderEntrance.User
    var dataArr  = [WOWOrderListModel]()
    var type = "100"  //100代表全部
    var selectIndex:Int = 0{
        didSet{
            switch selectIndex {
            case 0: //全部
                type = "100"
            case 1: //待付款
                type = "0"
            case 2: //待发货
                type = "1"
            case 3: //待收货
                type = "2"
            case 4: //待评价
                type = "3"
            default:
                type = "100" //全部
            }
        }
    }
    @IBOutlet weak var tableView: UITableView!
    var menuView:WOWTopMenuTitleView!
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if entrance == .PaySuccess{
            self.navigationController?.interactivePopGestureRecognizer?.enabled = false;
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.enabled = true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//MARK:Private Method
    override func setUI() {
        super.setUI()
        navigationItem.title = "订单"
        configCheckView()
        configTable()
        
    }
    private func configTable(){
        tableView.clearRestCell()
        tableView.backgroundColor = GrayColorLevel5
        tableView.registerNib(UINib.nibName(String(WOWOrderListCell)), forCellReuseIdentifier:"WOWOrderListCell")
    }
    
    private func configCheckView(){
        WOWCheckMenuSetting.defaultSetUp()
        WOWCheckMenuSetting.fill = true
        WOWCheckMenuSetting.selectedIndex = selectIndex
        menuView = WOWTopMenuTitleView(frame:CGRectMake(0, 0, self.view.w, 40), titles: ["全部","待付款","待发货","待收货","待评价"])
        menuView.delegate = self
        WOWBorderColor(menuView)
        self.view.addSubview(menuView)
    }
    
    override func backButtonClick() {
        if entrance == .PaySuccess {
            navigationController?.dismissViewControllerAnimated(true, completion: nil)
        }else{
            navigationController?.popViewControllerAnimated(true)
        }
    }

//MARK:Network
    override func request() {
        super.request()
        let uid = WOWUserManager.userID
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_OrderList(uid: uid, type: type), successClosure: { [weak self](result) in
            let json = JSON(result)
            DLog(json)
            if let strongSelf = self{
                let arr = Mapper<WOWOrderListModel>().mapArray(result)
                strongSelf.dataArr = []
                if let array = arr{
                    strongSelf.dataArr.appendContentsOf(array)
                }
                strongSelf.tableView.reloadData()
            }
        }) { (errorMsg) in
                
        }
    }

}


extension WOWOrderController:TopMenuProtocol{
    func topMenuItemClick(index: Int) {
        selectIndex = index
        request()
    }
}

extension WOWOrderController:OrderCellDelegate{
    func OrderCellClick(type: OrderCellAction,model:WOWOrderListModel,cell:WOWOrderListCell) {
        switch type {
        case .Comment:
            commentOrder(model.id ?? "")
        case .Delete:
            deleteOrder(model,cell: cell)
        case .Pay:
            payOrder(model.id ?? "",model: model)
        case .ShowTrans:
            DLog("查看物流")
        case .SureReceive:
            confirmReceive(model.id ?? "",cell: cell)
        }
    }
    
    //支付
    private func payOrder(orderID:String,model:WOWOrderListModel){
        if let charge = model.charge {
            Pingpp.createPayment(charge as! NSObject, appURLScheme: WOWDSGNSCHEME, withCompletion: {[weak self] (ret, error) in
                if let strongSelf = self{
                    if ret == "success"{ //支付成功
                        strongSelf.request()
                    }else{//订单支付取消或者失败
                        if ret == "fail"{
                            WOWHud.showMsg("支付失败")
                        }
                    }
                }
            })
        }
    }
    
    //评价订单
    private func commentOrder(orderID:String){
        let vc = UIStoryboard.initialViewController("User", identifier:"WOWOrderCommentController") as! WOWOrderCommentController
        vc.orderID = orderID
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //确认收货
    private func confirmReceive(orderid:String,cell:WOWOrderListCell){
        func confirm(){
            let uid = WOWUserManager.userID
            WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_OrderStatus(uid: uid, order_id: orderid, status:"3"), successClosure: { [weak self](result) in
                if let strongSelf = self{
                    let ret = JSON(result).int ?? 0
                    if ret == 1{
                        strongSelf.request()
                    }
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
    
    private func deleteOrder(model:WOWOrderListModel,cell:WOWOrderListCell){
        let uid      = WOWUserManager.userID
        let order_id = model.id ?? ""
        let status   = "20" //删除被回收
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_OrderStatus(uid:uid, order_id:order_id, status:status), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                let ret = JSON(result).int ?? 0
                if ret == 1{
                     strongSelf.request()
                }
            }
        }) { (errorMsg) in
                
        }
    }
}

extension WOWOrderController:OrderCommentDelegate{
    func orderCommentSuccess() {
        request()
    }
}

extension WOWOrderController:OrderDetailDelegate{
    func orderStatusChange() {
        request()
    }
}


extension WOWOrderController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 184
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderListCell", forIndexPath: indexPath) as! WOWOrderListCell
        cell.delegate = self
        cell.showData(dataArr[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = UIStoryboard.initialViewController("User", identifier: "WOWOrderDetailController") as! WOWOrderDetailController
        vc.orderModel = dataArr[indexPath.row]
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
    
    override func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "暂无订单哦"
        let attri = NSAttributedString(string: text, attributes:[NSForegroundColorAttributeName:MGRgb(170, g: 170, b: 170),NSFontAttributeName:UIFont.mediumScaleFontSize(17)])
        return attri
    }
    
    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return -40
    }
}