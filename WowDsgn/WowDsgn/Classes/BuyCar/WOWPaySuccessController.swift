//
//  WOWPaySuccessController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/18.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWPaySuccessController: WOWBaseTableViewController {
    var orderid     = "  "
    var totalPrice  = ""
    var payMethod   = "支付宝"
    @IBOutlet weak var orderIdLabel: UILabel!
    
    @IBOutlet weak var payMethodLabel: UILabel!
    @IBOutlet weak var orderCountLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "支付成功"
        orderIdLabel.text = orderid
        orderCountLabel.text = totalPrice.priceFormat()
        payMethodLabel.text = payMethod
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

extension WOWPaySuccessController{
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.01
        case 1,20:
            return 20
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section {
        case 2:
            if indexPath.row == 0 {//订单
                let vc = UIStoryboard.initialViewController("User", identifier:String(WOWOrderController)) as! WOWOrderController
                vc.selectIndex = 0
                vc.entrance = OrderEntrance.PaySuccess
                navigationController?.pushViewController(vc, animated: true)
            }else{
                navigationController?.popToRootViewControllerAnimated(true)
            }
        default:
            break
        }
    }
}
