//
//  WOWPaySuccessController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/18.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWPaySuccessController: WOWBaseTableViewController {

    @IBOutlet weak var orderIdLabel: UILabel!
    
    @IBOutlet weak var payMethodLabel: UILabel!
    @IBOutlet weak var orderCountLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "支付成功"
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
        switch indexPath {
        case 2:
            if indexPath.row == 0 {
                DLog("查看订单")
            }else{
                DLog("返回首页")
            }
        default:
            break
        }
    }
}
