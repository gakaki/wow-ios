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
    var dataArr  = [WOWNewOrderListModel]()
    
//    var currentPage = 1
    
    var type = ""  //100代表全部
    var selectIndex:Int = 0{
        didSet{
            switch selectIndex {
            case 0: //全部
                type = ""
            case 1: //待付款
                type = "0"
            case 2: //待发货
                type = "1"
            case 3: //待收货
                type = "3"
            case 4: //待评价
                type = "4"
            default:
                type = "" //全部
            }
        }
    }
    @IBOutlet weak var tableView: UITableView!
    var menuView:WOWTopMenuTitleView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.mj_header = self.mj_header
        
        tableView.mj_footer = self.mj_footer
        
        request()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationShadowImageView?.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if entrance == .PaySuccess{
            self.navigationController?.interactivePopGestureRecognizer?.enabled = false;
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.enabled = true;
        self.navigationShadowImageView?.hidden = false
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
        tableView.backgroundColor = DefaultBackColor
        tableView.registerNib(UINib.nibName(String(WOWOrderListCell)), forCellReuseIdentifier:"WOWOrderListCell")
    }
    
    private func configCheckView(){
        WOWCheckMenuSetting.defaultSetUp()
        WOWCheckMenuSetting.fill = true
        WOWCheckMenuSetting.selectedIndex = selectIndex
        menuView = WOWTopMenuTitleView(frame:CGRectMake(0, 0, self.view.w, 40), titles: ["全部","待付款","待发货","待收货","已完成"])
        menuView.delegate = self
        menuView.addBorderBottom(size:0.5, color:BorderColor)
        self.view.addSubview(menuView)
    }
    
    override func navBack() {
        if entrance == .PaySuccess {
            navigationController?.dismissViewControllerAnimated(true, completion: nil)
        }else{
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
    //MARK:Network
    override func request() {
        
        
        super.request()
        
        let totalPage = 10
        WOWNetManager.sharedManager.requestWithTarget(.Api_OrderList(orderStatus: type, currentPage: pageIndex,pageSize:totalPage), successClosure: { [weak self](result) in
            
            let json = JSON(result)["orderLists"].arrayObject
            DLog(json)
            
            if let strongSelf = self{
                
                strongSelf.endRefresh()
                
                let arr = Mapper<WOWNewOrderListModel>().mapArray(json)
                
                if let array = arr{
    
                    if strongSelf.pageIndex == 1{
                        strongSelf.dataArr = []
                    }
                    strongSelf.dataArr.appendContentsOf(array)
                    //如果请求的数据条数小于totalPage，说明没有数据了，隐藏mj_footer
                    if array.count < totalPage {
                        strongSelf.tableView.mj_footer = nil

                    }else {
                        strongSelf.tableView.mj_footer = strongSelf.mj_footer
                    }

                }else {
                    strongSelf.tableView.mj_footer = nil

                }

                strongSelf.tableView.reloadData()
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self {
                strongSelf.tableView.mj_footer = nil
                strongSelf.endRefresh()

            }

        }
    }
    
}


extension WOWOrderController:TopMenuProtocol{
    func topMenuItemClick(index: Int) {
        selectIndex = index
        self.dataArr  = [WOWNewOrderListModel]()
        self.pageIndex = 1
        request()
    }
}

extension WOWOrderController:OrderCellDelegate{
    func OrderCellClick(type: OrderCellAction,model:WOWNewOrderListModel,cell:WOWOrderListCell) {
        switch type {
        case .Comment:
            print("评价")
//            commentOrder(model.id ?? "")
        case .Delete:
            print("删除")
//            deleteOrder(model,cell: cell)
        case .Pay:
            print("支付")
//            payOrder(model.id ?? "",model: model)
            goOrderDetailAction(model)
        case .ShowTrans:
            DLog("查看物流")
        case .SureReceive:
            print("确认收货")
            confirmReceive(model.orderCode ?? "",cell: cell)
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
        vc.orderID = orderID.toInt()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
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
        return self.dataArr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 164
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WOWOrderListCell", forIndexPath: indexPath) as! WOWOrderListCell
                let orderModel = self.dataArr[indexPath.section]
        cell.delegate = self
        cell.showData(dataArr[indexPath.section])
        if orderModel.orderStatus == 0 {
            cell.rightButton.hidden = false
            cell.rightButton.setTitle("立即支付", forState: .Normal)
        }else if orderModel.orderStatus == 3{
            cell.rightButton.hidden = false
            cell.rightButton.setTitle("确认收货", forState: .Normal)
        }else{
            cell.rightButton.hidden = true
        }

        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            DLog("删除订单");
        }
    }
    
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "删除"
    }
    
    //    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    //        let model = dataArr[indexPath.row]
    //        return model.status == 0 //待付款的是可以取消的
    //    }
    func goOrderDetailAction(model:WOWNewOrderListModel) {
        let vc = UIStoryboard.initialViewController("User", identifier: "WOWOrderDetailController") as! WOWOrderDetailController
        vc.orderNewModel = model
        vc.delegate = self
        navigationController!.pushViewController(vc, animated: true)

    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = UIStoryboard.initialViewController("User", identifier: "WOWOrderDetailController") as! WOWOrderDetailController
                vc.orderNewModel = dataArr[indexPath.section]
                vc.delegate = self
        navigationController!.pushViewController(vc, animated: true)
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    override func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "暂无订单哦"
        let attri = NSAttributedString(string: text, attributes:[NSForegroundColorAttributeName:MGRgb(170, g: 170, b: 170),NSFontAttributeName:UIFont.mediumScaleFontSize(17)])
        return attri
    }
    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return -40
    }
}