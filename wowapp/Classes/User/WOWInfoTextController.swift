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
    var userInfo:String = ""
    @IBOutlet weak var textField: UITextField!
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
        textField.text = userInfo
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
        guard let info = textField.text where !info.isEmpty else{
            WOWHud.showMsg("请输入" + self.title!)
            return
        }
        var params = [String : String]()
        switch entrance {
        case .NickEntrance:
            params = ["nickName":info]
        case .DescEntrance:
            params = ["selfIntroduction":info]
        case .JobEntrance:
            params = ["industry":info]
        }
        WOWNetManager.sharedManager.requestWithTarget(.Api_Change(param:params), successClosure: { [weak self](result) in
            if let strongSelf = self{
                let json = JSON(result)
                DLog(json)
                //保存一些用户信息
                switch strongSelf.entrance {
                case .NickEntrance:
                WOWUserManager.userName = info
                case .DescEntrance:
                WOWUserManager.userDes = info
                case .JobEntrance:
                WOWUserManager.userIndustry = info
                }
                strongSelf.popVC()
            
                
            }
        }) { (errorMsg) in
            WOWHud.dismiss()
            DLog(errorMsg)
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
}
