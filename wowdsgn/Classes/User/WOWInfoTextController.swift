//
//  WOWInfoTextController.swift
//  wowapp
//
//  Created by 小黑 on 16/6/1.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
typealias ChangeInfo = (String) ->Void
enum InfoTextEntrance{
    case nickEntrance()
    case descEntrance()
    case jobEntrance()
}

class WOWInfoTextController: WOWBaseTableViewController {
    var userInfo:String = ""
    var vcTitle: String?
    var changeInfotext :ChangeInfo?
    
    @IBOutlet weak var textField: UITextField!
    var entrance : InfoTextEntrance = InfoTextEntrance.nickEntrance()
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
        if userInfo.isEmpty {
            switch entrance {
            case .nickEntrance:
                 textField.placeholder = "请输入昵称"
            case .descEntrance:
                 textField.placeholder = "请输入个性签名"
            case .jobEntrance:
                 textField.placeholder = "请输入职业"
            }
        }else{
                textField.text = userInfo
        }
        switch entrance {
        case .nickEntrance:
            navigationItem.title = "昵称"
            vcTitle              = "昵称"
        case .descEntrance:
            navigationItem.title = "个性签名"
            vcTitle              = "个性签名"
        case .jobEntrance:
            navigationItem.title = "职业"
            vcTitle              = "职业"
        }

    }
    
    fileprivate func saveInfo(){
        DLog("保存信息")
//        guard let info = textField.text where !info.isEmpty else{
//            WOWHud.showMsg("请输入" + vcTitle!)
//            return
//        }
        let info = textField.text
        var params = [String : String]()
        switch entrance {
        case .nickEntrance:
            
           params = ["nickName":info ?? ""]
        case .descEntrance:
            params = ["selfIntroduction":info ?? ""]
        case .jobEntrance:
            params = ["industry":info ?? ""]
        }

//        switch entrance {
//        case .NickEntrance(_):
//            
//        case .DescEntrance(_):
//            
//        case .JobEntrance(_):
//            
//        }
        WOWNetManager.sharedManager.requestWithTarget(.api_Change(param:params), successClosure: { [weak self](result, code) in
            if let strongSelf = self{
                let json = JSON(result)
                DLog(json)
                //保存一些用户信息
                switch strongSelf.entrance {
                case .nickEntrance:
                WOWUserManager.userName = info ?? ""
                case .descEntrance:
                WOWUserManager.userDes = info ?? ""
                case .jobEntrance:
                WOWUserManager.userIndustry = info ?? ""
                }
                NotificationCenter.postNotificationNameOnMainThread(WOWChangeUserInfoNotificationKey, object: nil)

                strongSelf.changeInfotext!(info ?? "")
                strongSelf.popVC()
            
                
            }
        }) { (errorMsg) in
            WOWHud.dismiss()
            WOWHud.showMsgNoNetWrok(message: errorMsg)
            DLog(errorMsg)

        }
    }
    //闭包变量的Seter方法
    func setBackMyClosure(_ tempClosure:@escaping ChangeInfo) {
        self.changeInfotext = tempClosure
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
}
