//
//  WOWAfterDetailController.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/5/5.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWAfterDetailController: WOWBaseViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "售后详情"
     
    }
    override func setUI() {
        super.setUI()
        
        tableView.backgroundColor = GrayColorLevel5
        tableView.delegate      = self
        tableView.dataSource    = self
        tableView.register(UINib.nibName("WOWLineDetaliCell"), forCellReuseIdentifier: "WOWLineDetaliCell")
        tableView.register(UINib.nibName("WOWLineFormatCell"), forCellReuseIdentifier: "WOWLineFormatCell")
        tableView.register(UINib.nibName("WOWReviewCell"), forCellReuseIdentifier: "WOWReviewCell")
        tableView.register(UINib.nibName("WOWTelCell"), forCellReuseIdentifier: "WOWTelCell")
        self.tableView.rowHeight            = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight   = 60
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        switch section {
        case 0:
            let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWLineFormatCell", for: indexPath) as! WOWLineFormatCell
        
            cell.progressType = .unFinished
            cell.lbOneDescribe.text = "1234567890"
            cell.lbTwoDescribe.text = "2017-03-10 15:26:23"
            return cell
        case 1:
            let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWReviewCell", for: indexPath) as! WOWReviewCell
            
            return cell
        case 2:
            let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWLineFormatCell", for: indexPath) as! WOWLineFormatCell
//            cell.lbOne.text  = "退款金额:"
//            cell.lbTwo.text =  "退款时间:"
            cell.progressType = .Finished
            cell.lbOneDescribe.text = "298.00"
            cell.lbTwoDescribe.text = "2017-03-10 15:26:23"
            return cell
        case 3:
            let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWLineDetaliCell", for: indexPath) as! WOWLineDetaliCell
            cell.applyText = "退款退货"
            cell.goodsTypeText = "已收到"
            cell.refundMoneyText = "298.00"
            cell.refundResaonText = "不喜欢"
            
            return cell
        default:
            return getCustomerPhoneCell(indexPath: indexPath)
        }
      
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        VCRedirect.goOnlyRefund()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // 需要帮助 UI
    func getCustomerPhoneCell(indexPath:IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: String(describing: WOWTelCell.self), for: indexPath) as! WOWTelCell
        cell.titleLabel.text = "需要帮助"
        cell.contentView.addTapGesture {[unowned self] (sender) in
//            MobClick.e(.contact_customer_service_order_detail)
            WOWCustomerNeedHelp.show("")
        }
        
        return cell
    }



}
