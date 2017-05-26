//
//  WOWNogotiateDetailsController.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/5/8.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWNogotiateDetailsController: WOWApplyAfterBaseController {
    
    var orderCode                   : String!   // 订单号
    var saleOrderItemRefundId             : Int!      // 单个商品 在订单中Id
    var dataArr  = [WOWRufundDiscussModel]()
    var afterType:ChooseAfterType   = .SendNo_OnlyRefund {// 默认仅退款
        didSet{
            switch afterType {
            case .SendNo_OnlyRefund:
                break
            case .SendNo_AllOrderRefund:
                break
            default:
                break
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "售后明细"
        // Do any additional setup after loading the view.
    }
    override func setUI() {
        super.setUI()
        
        tableView.cellId_register("WOWNegotiateDetailCell")


        request()
    }
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(.api_GetRefundLog(orderCode: nil, saleOrderItemRefundId: saleOrderItemRefundId), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            let json = JSON(result)
            DLog(json)
            if let strongSelf = self{
                strongSelf.endRefresh()
                
                 let bannerList = Mapper<WOWRufundDiscussModel>().mapArray(JSONObject:JSON(result)["refundLogList"].arrayObject)
                if let bannerList = bannerList {
                    strongSelf.dataArr = bannerList
                    strongSelf.tableView.reloadData()
                }
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                WOWHud.showMsg(errorMsg ?? "")
                strongSelf.endRefresh()
            }
        }
        

    }
   override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWNegotiateDetailCell", for: indexPath) as! WOWNegotiateDetailCell
        let model = dataArr[indexPath.row]
        cell.lbTime.text        = model.createTime ?? ""
        cell.lbTitle.text       = model.operatorContent ?? ""
        cell.lbContent.text     = model.remark ?? ""
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
