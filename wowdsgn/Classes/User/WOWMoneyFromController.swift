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
    var currentRefundEventTypeName : String?
    var dataArr  = [WOWRufundProcessModel]()
    var data = [(TimelinePoint, UIColor, UIColor)]()
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
                    for item in bannerList.enumerated() {
                        let pointColor      = TimelinePoint(color: YellowColor)
                        let seprateColor    = TimelinePoint(color: SeprateColor)
                        let clearColor        = UIColor.clear
                        let lineColor       = SeprateColor
                        if item.offset == 0 {
                            if item.element.isPass ?? false {
                                strongSelf.data.append((pointColor,clearColor,YellowColor))
                            }else{
                                strongSelf.data.append((seprateColor,clearColor,lineColor))
                            }
                        }else if item.offset == bannerList.count - 1 {
                            if item.element.isPass ?? false {
                                strongSelf.data.append((pointColor,YellowColor,clearColor))
                            }else{
                                strongSelf.data.append((seprateColor,lineColor,clearColor))
                            }
                        }else{
                            if item.element.isPass ?? false {
                                strongSelf.data.append((pointColor,YellowColor,YellowColor))
                            }else{
                                strongSelf.data.append((seprateColor,lineColor,lineColor))
                            }

                        }
                        
                    }
                    strongSelf.currentRefundEventTypeName   = json["currentRefundEventTypeName"].stringValue
                    strongSelf.actualRefundAmount           = json["actualRefundAmount"].stringValue
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
//            if let actualRefundAmount = actualRefundAmount {
                cell.lbMoneyNumber.text = "¥" + (actualRefundAmount ?? "")
//                if let  currentRefundEventTypeName = currentRefundEventTypeName {
                cell.lbRefundType.text = currentRefundEventTypeName ?? ""
//                }
              
//            }
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
