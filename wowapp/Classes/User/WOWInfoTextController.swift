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
    case NickEntrance()
    case DescEntrance()
    case JobEntrance()
}

class WOWInfoTextController: WOWBaseTableViewController {
    var userInfo:String = ""
    var vcTitle: String?
    var changeInfotext :ChangeInfo?
    
    @IBOutlet weak var textField: UITextField!
    var entrance : InfoTextEntrance = InfoTextEntrance.NickEntrance()
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
            case .NickEntrance:
                 textField.placeholder = "请输入昵称"
            case .DescEntrance:
                 textField.placeholder = "请输入个性签名"
            case .JobEntrance:
                 textField.placeholder = "请输入职业"
            }
        }else{
                textField.text = userInfo
        }
        switch entrance {
        case .NickEntrance:
            navigationItem.title = "昵称"
            vcTitle              = "昵称"
        case .DescEntrance:
            navigationItem.title = "个性签名"
            vcTitle              = "个性签名"
        case .JobEntrance:
            navigationItem.title = "职业"
            vcTitle              = "职业"
        }

    }
    
    private func saveInfo(){
        DLog("保存信息")
//        guard let info = textField.text where !info.isEmpty else{
//            WOWHud.showMsg("请输入" + vcTitle!)
//            return
//        }
        let info = textField.text
        var params = [String : String]()
        switch entrance {
        case .NickEntrance:
           params = ["nickName":info ?? ""]
        case .DescEntrance:
            params = ["selfIntroduction":info ?? ""]
        case .JobEntrance:
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
        WOWNetManager.sharedManager.requestWithTarget(.Api_Change(param:params), successClosure: { [weak self](result) in
            if let strongSelf = self{
                let json = JSON(result)
                DLog(json)
                //保存一些用户信息
                switch strongSelf.entrance {
                case .NickEntrance:
                WOWUserManager.userName = info ?? ""
                case .DescEntrance:
                WOWUserManager.userDes = info ?? ""
                case .JobEntrance:
                WOWUserManager.userIndustry = info ?? ""
                }
                NSNotificationCenter.postNotificationNameOnMainThread(WOWChangeUserInfoNotificationKey, object: nil)

                strongSelf.changeInfotext!(info!)
                strongSelf.popVC()
            
                
            }
        }) { (errorMsg) in
            WOWHud.dismiss()
            DLog(errorMsg)
        }
    }
    //闭包变量的Seter方法
    func setBackMyClosure(tempClosure:ChangeInfo) {
        self.changeInfotext = tempClosure
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
}
