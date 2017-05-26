//
//  WOWRefundListController.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/5/16.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWRefundListController: WOWApplyAfterBaseController {
    var dataArr = [WOWRefundListModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "退换货"
        request()
    }
    override func setUI() {
        super.setUI()
        tableView.cellId_register("WOWRefundListCell")
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
    override func request() {
        super.request()
        
        var params = [String: Any]()
        let totalPage = 10
        params = ["currentPage": pageIndex,"pageSize":totalPage]
      
        
        WOWNetManager.sharedManager.requestWithTarget(.api_GetRefundList(params: params as [String : AnyObject]), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            let json = JSON(result)
            DLog(json)
            
            if let strongSelf = self{
                
                let bannerList = Mapper<WOWRefundListModel>().mapArray(JSONObject:JSON(result)["refundOrderList"].arrayObject)
                
                if let bannerList = bannerList{
                    
                    if strongSelf.pageIndex == 1{
                        strongSelf.dataArr = []
                    }
                    strongSelf.dataArr.append(contentsOf: bannerList)
                    //如果请求的数据条数小于totalPage，说明没有数据了，隐藏mj_footer
                    if bannerList.count < totalPage {
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
                strongSelf.endRefresh()
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                WOWHud.showMsg(errorMsg ?? "")
                strongSelf.endRefresh()

            }
        }
        

    }
    override func navBack() {
        
        if let nav = self.navigationController {
            if nav.viewControllers.count > 3 {
                _ = navigationController?.popToViewController((navigationController?.viewControllers[2])!, animated: true)
            }else{
                _ = navigationController?.popViewController(animated: true)
            }
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWRefundListCell", for: indexPath) as! WOWRefundListCell
        cell.productData(dataArr[indexPath.section])
        return cell

    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return 10
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArr[indexPath.section]
        let vc = WOWAfterDetailController()
        
        vc.saleOrderItemRefundId = model.saleOrderItemRefundId ?? 0
        vc.action = {[weak self] in // 撤销成功，更新状态
            if let strongSelf = self {
                
                strongSelf.pageIndex = 1
                strongSelf.request()
                
            }
        }
       _ = self.navigationController?.pushViewController(vc, animated: true)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
