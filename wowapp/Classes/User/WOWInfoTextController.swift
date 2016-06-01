//
//  WOWInfoTextController.swift
//  wowapp
//
//  Created by 小黑 on 16/6/1.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

enum InfoTextEntrance{
    case NickEntrance(value:String)
    case DescEntrance(value:String)
    case JobEntrance(value:String)
}

class WOWInfoTextController: WOWBaseTableViewController {
    var entrance : InfoTextEntrance = InfoTextEntrance.NickEntrance(value: "昵称")
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setUI() {
        makeCustomerNavigationItem("保存", left: false) {[weak self] in
            if let strongSelf = self{
                strongSelf.saveInfo()
            }
        }
        
        super.setUI()
        switch entrance {
        case let .NickEntrance(value):
            navigationItem.title = value
        case let .DescEntrance(value):
            navigationItem.title = value
        case let .JobEntrance(value):
            navigationItem.title = value
        }
    }
    
    private func saveInfo(){
        DLog("保存信息")
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
}
