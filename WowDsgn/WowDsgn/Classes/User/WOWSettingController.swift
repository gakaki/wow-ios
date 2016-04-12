//
//  WOWSettingController.swift
//  Wow
//
//  Created by 小黑 on 16/4/10.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWSettingController: WOWBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setUI() {
        super.setUI()
        navigationItem.title  = "设置"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        switch WOWLoginManager.status {
        case .Logined:
            return 3
        default:
            return 2
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //研究下switch高级用法的再写
//        switch indexPath.section {
//        case 0: //绑定账号
//            DLog("绑定账号")
//        case 1:
//            
//        default:
//            
//        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 15
        default:
            return 25
        }
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}


