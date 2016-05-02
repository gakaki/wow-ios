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
            case 0:
                type = "100" //全部
            case 1: //待付款
                type = "0"
            case 2: //待收货
                type = "2"
            case 3: //待评价
                type = "3"
            default:
                type = "100"
            }
        }
    }
    @IBOutlet weak var tableView: UITableView!
    var menuView:WOWTopMenuTitleView!
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
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
        menuView = WOWTopMenuTitleView(frame:CGRectMake(0, 0, MGScreenWidth, 40), titles: ["全部","待付款","待收货","待评价"])
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
        DLog(type)
        let uid = WOWUserManager.userID
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_OrderList(uid: uid, type: type), successClosure: { [weak self](result) in
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
        cell.showData(dataArr[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = UIStoryboard.initialViewController("User", identifier: "WOWOrderDetailController") as! WOWOrderDetailController
        vc.orderModel = dataArr[indexPath.row]
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