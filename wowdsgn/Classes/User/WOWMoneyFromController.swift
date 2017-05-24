//
//  WOWMoneyFromController.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/5/9.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit


class WOWMoneyFromController: WOWApplyAfterBaseController {
    var actualRefundAmount:String?
    var dataArr  = [WOWRufundProcessModel]()
    let data : [(TimelinePoint, UIColor, UIColor)]
        = [(TimelinePoint(color: YellowColor, filled: true),UIColor.clear,YellowColor),
           (TimelinePoint(color: YellowColor, filled: true),YellowColor,YellowColor),
           (TimelinePoint(color: SeprateColor, filled: true),SeprateColor,UIColor.clear)]
    var saleOrderItemRefundId        : Int!      // 单个商品 在订单中Id
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "钱款去向"
        // Do any additional setup after loading the view.
    
  
    }
    override func setUI() {
        super.setUI()
        tableView.cellId_register("WOWTimerLineCell")
        tableView.cellId_register("WOWMoneyTopCell")
        request()
    }
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(.api_GetRefundProcess(saleOrderItemRefundId: saleOrderItemRefundId), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            let json = JSON(result)
            DLog(json)
            if let strongSelf = self{
                strongSelf.endRefresh()
                
                let bannerList = Mapper<WOWRufundProcessModel>().mapArray(JSONObject:JSON(result)["refundProcessList"].arrayObject)
                if let bannerList = bannerList {
                    strongSelf.dataArr = bannerList
                    strongSelf.actualRefundAmount = json["actualRefundAmount"].stringValue
                    strongSelf.tableView.reloadData()
                }
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                WOWHud.dismiss()
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count + 1
    }
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row != 0 else {
            let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWMoneyTopCell", for: indexPath) as! WOWMoneyTopCell
            if let actualRefundAmount = actualRefundAmount {
                cell.lbMoneyNumber.text = "¥" + actualRefundAmount
            }
            return cell
        }
        
        let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWTimerLineCell", for: indexPath) as! WOWTimerLineCell
        let (timelinePoint, timeLineTopColor, timeLineBottomColor) = data[indexPath.row - 1]
        cell.timelinePoint          = timelinePoint
        cell.timeline.frontColor    = timeLineTopColor
        cell.timeline.backColor     = timeLineBottomColor
        let model = dataArr[indexPath.row - 1]
        cell.lbTime.text    = model.createTime ?? ""
        cell.lbApply.text   = model.refundEventTypeName ?? ""
        return cell
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
