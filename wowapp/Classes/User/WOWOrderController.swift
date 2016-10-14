//
//  WOWOrderController.swift
//  Wow
//
//  Created by 小黑 on 16/4/11.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit


class WOWOrderController: WOWBaseViewController {
    var entrance = orderDetailEntrance.orderList
    var dataArr  = [WOWNewOrderListModel]()
    var parentNavigationController : UINavigationController?
    var isRequest :Bool = false// 判断此页面是不是第一次网络请求
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
        // 默认进入0 下标， 请求网络
        if selectIndex == 0 {
             request()
            NotificationCenter.default.addObserver(self, selector:#selector(updateOrderListAllInfo), name:NSNotification.Name(rawValue: WOWUpdateOrderListAllNotificationKey), object:nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationShadowImageView?.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if entrance == .orderPay{
            self.parentNavigationController?.interactivePopGestureRecognizer?.isEnabled = false;
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.parentNavigationController?.interactivePopGestureRecognizer?.isEnabled = true;
        self.navigationShadowImageView?.isHidden = false
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:Private Method
    override func setUI() {
        super.setUI()
        navigationItem.title = "我的订单"
//        configCheckView()
        configTable()
        
    }
    fileprivate func configTable(){
        tableView.clearRestCell()
        tableView.backgroundColor = DefaultBackColor
        tableView.register(UINib.nibName(String(describing: WOWOrderListCell.self)), forCellReuseIdentifier:"WOWOrderListCell")
    }
    func updateOrderListAllInfo() {
        request()
    }
    //MARK:Network
    override func request() {
        
        
        super.request()
        
        let totalPage = 10
        
        var params = [String: AnyObject]()
        if selectIndex == 2 { // 待发货 要 显示 部分发货

            params = (["orderStatusList": [1,2], "currentPage": pageIndex,"pageSize":totalPage] as AnyObject) as! [String : AnyObject]
        }else{
            params = ["orderStatus": type as AnyObject, "currentPage": pageIndex as AnyObject,"pageSize":totalPage as AnyObject]
        }

        WOWNetManager.sharedManager.requestWithTarget(.api_OrderList(params:params), successClosure: { [weak self](result) in
            
            let json = JSON(result)["orderLists"].arrayObject
            DLog(json)
            
            if let strongSelf = self{
                strongSelf.isRequest = true
                strongSelf.endRefresh()
                
                let arr = Mapper<WOWNewOrderListModel>().mapArray(JSONObject:json)
                
                if let array = arr{
    
                    if strongSelf.pageIndex == 1{
                        strongSelf.dataArr = []
                    }
                    strongSelf.dataArr.append(contentsOf: array)
                    //如果请求的数据条数小于totalPage，说明没有数据了，隐藏mj_footer
                    if array.count < totalPage {
                        strongSelf.tableView.mj_footer = nil

                    }else {
                        strongSelf.tableView.mj_footer = strongSelf.mj_footer
                    }

                }else {
                    if strongSelf.pageIndex == 1{
                        strongSelf.dataArr = []
                    }

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
    func topMenuItemClick(_ index: Int) {
        selectIndex = index
        self.dataArr  = [WOWNewOrderListModel]()
        self.pageIndex = 1
        request()
    }
}

extension WOWOrderController:OrderCellDelegate{
    func clickGoToDetail(orderCoder: String) {
        
        gotoOrderDatailVC(orderCode: orderCoder)
        
    }
    func OrderCellClick(_ type: OrderCellAction,model:WOWNewOrderListModel,cell:WOWOrderListCell) {
        switch type {
        case .comment:
            print("评价")
//            commentOrder(model.id ?? "")
        case .delete:
            print("删除")
//            deleteOrder(model,cell: cell)
        case .pay:
            print("支付")
//            payOrder(model.id ?? "",model: model)
            goOrderDetailAction(model.orderCode ?? "")
        case .showTrans:
            DLog("查看物流")
        case .sureReceive:
            confirmReceive(model.orderCode ?? "",cell: cell)
        }
    }
    
    //支付
    fileprivate func payOrder(_ orderID:String,model:WOWOrderListModel){
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
    fileprivate func commentOrder(_ orderID:String){
        let vc = UIStoryboard.initialViewController("User", identifier:"WOWOrderCommentController") as! WOWOrderCommentController
        vc.orderID = orderID.toInt()
        vc.delegate = self
        parentNavigationController?.pushViewController(vc, animated: true)
    }
    
    //确认收货
    fileprivate func confirmReceive(_ orderCode:String,cell:WOWOrderListCell){
        func confirm(){
            WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_OrderConfirm(orderCode: orderCode), successClosure: { [weak self](result) in
                if let strongSelf = self{
                    //确认收货成功后重新请求下网络刷新列表
                    strongSelf.request()
                }
            }) { (errorMsg) in
                
            }
        }
        
        let alert = UIAlertController(title:"确认收货", message:nil, preferredStyle:.alert)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let sure = UIAlertAction(title: "确定", style: .default) { (action) in
            confirm()
        }
        
        alert.addAction(cancel)
        alert.addAction(sure)
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func deleteOrder(_ model:WOWOrderListModel,cell:WOWOrderListCell){
        let uid      = WOWUserManager.userID
        let order_id = model.id ?? ""
        let status   = "20" //删除被回收
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_OrderStatus(uid:uid, order_id:order_id, status:status), successClosure: {[weak self] (result) in
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 164
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WOWOrderListCell", for: indexPath) as! WOWOrderListCell
        let orderModel = self.dataArr[(indexPath as NSIndexPath).section]
        cell.delegate = self
        cell.showData(dataArr[(indexPath as NSIndexPath).section])
        if orderModel.orderStatus == 0 {
            cell.rightButton.isHidden = false
            cell.rightButton.setTitle("立即支付", for: UIControlState())
        }else if orderModel.orderStatus == 3{
            cell.rightButton.isHidden = false
            cell.rightButton.setTitle("确认收货", for: UIControlState())
        }else{
            cell.rightButton.isHidden = true
        }
       
        return cell
    }
    
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            DLog("删除订单");
//        }
//    }
//    
//    
//    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
//        return "删除"
//    }
//    
    //    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    //        let model = dataArr[indexPath.row]
    //        return model.status == 0 //待付款的是可以取消的
    //    }
    func goOrderDetailAction(_ orderCode:String) {
        let vc = UIStoryboard.initialViewController("User", identifier: "WOWOrderDetailController") as! WOWOrderDetailController
        vc.orderCode = orderCode
        vc.delegate = self
        parentNavigationController!.pushViewController(vc, animated: true)

    }
    func gotoOrderDatailVC(orderCode:String) {
        let vc = UIStoryboard.initialViewController("User", identifier: "WOWOrderDetailController") as! WOWOrderDetailController
        vc.orderCode = orderCode
        vc.delegate = self
        parentNavigationController!.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        gotoOrderDatailVC(orderCode: dataArr[(indexPath as NSIndexPath).section].orderCode ?? "")
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func customViewForEmptyDataSet(_ scrollView: UIScrollView!) -> UIView! {
        let view = Bundle.main.loadNibNamed(String(describing: WOWOrderEmptyView.self), owner: self, options: nil)?.last as! WOWOrderEmptyView
//        view.center = self.view.center
        view.backgroundColor = DefaultBackColor
        return view
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func verticalOffsetForEmptyDataSet(_ scrollView: UIScrollView!) -> CGFloat {
        return -40
    }
}
