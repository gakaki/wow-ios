//
//  WOWMsgCodeController.swift
//  Wow
//
//  Created by 小黑 on 16/4/10.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

enum MsgCodeEntrance {
    case RegistCode,ForgetPasswordCode
    case ForgetPasswordHome //忘记密码流程首页，UI一样，所以共用一个界面
}

class WOWMsgCodeController: WOWBaseViewController {
    var entrance:MsgCodeEntrance = .RegistCode
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var leftLabel: UILabel!
//MARK:Life
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
//MARK:Private Method
    override func setUI() {
        super.setUI()
        switch entrance {
        case .RegistCode:
            navigationItem.title = "注册"
        case .ForgetPasswordCode:
            navigationItem.title = "忘记密码"
        case .ForgetPasswordHome:
            navigationItem.title = "忘记密码"
            leftLabel.text = "注册手机号"
            codeTextField.placeholder = "请输入手机号码"
        }
        makeBackButton("上一步")
    }
    
    
//MARK:Actions

    @IBAction func nextClick(sender: UIButton) {
        switch entrance {
        case .ForgetPasswordHome:
            let vc = UIStoryboard.initialViewController("Login", identifier:String(WOWMsgCodeController)) as! WOWMsgCodeController
            vc.entrance  = .ForgetPasswordCode
            navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = UIStoryboard.initialViewController("Login", identifier:String(WOWPasswordController)) as! WOWPasswordController
            vc.entrance  = entrance
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
//MARK:Lazy
    

}


//MARK:Delegate