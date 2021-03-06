//
//  WOWMsgCodeController.swift
//  Wow
//
//  Created by 小黑 on 16/4/10.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

enum msgCodeEntrance {
    case loginEntrance
    case userEntrance
}

class WOWMsgCodeController: WOWBaseViewController {
    
//    @IBOutlet weak var tipsLabel: UILabel!

    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var newPwdTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var msgCodeButton: UIButton!

    var entrance = msgCodeEntrance.loginEntrance
    var mobile:String!
//MARK:Life
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
//MARK:Lazy
    
//MARK:Private Method
    override func setUI() {
        switch entrance {
        case .loginEntrance:
            navigationItem.title = "忘记密码"
            phoneTextField.isUserInteractionEnabled = true
            
        default:
            navigationItem.title = "修改密码"
            phoneTextField.isUserInteractionEnabled = false
            phoneTextField.text = WOWUserManager.userMobile.get_formted_xxPhone()
        }
       
    }

//MARK:Actions
    @IBAction func msgCodeButtonClick(_ sender: UIButton) {
        switch entrance {
        case .loginEntrance:
            mobile = phoneTextField.text ?? ""
            
        default:
            mobile = WOWUserManager.userMobile
        }
        if !validatePhone(mobile, tips: "请输入手机号", is_phone: true){
            return
        }
        WOWNetManager.sharedManager.requestWithTarget(.api_PwdResetCode(mobile:mobile), successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                WOWHud.showMsg("验证码发送成功")
                strongSelf.msgCodeButton.startTimer(60, title: "重新获取", mainBGColor: UIColor.white, mainTitleColor: UIColor.black, countBGColor:UIColor.white, countTitleColor:GrayColorlevel3, handle: nil)
            }
        }) { (errorMsg) in
            WOWHud.showWarnMsg(errorMsg)
        }

    
    }

    @IBAction func sureClick(_ sender: UIButton) {
        switch entrance {
        case .loginEntrance:
            mobile = phoneTextField.text ?? ""
            
        default:
            mobile = WOWUserManager.userMobile
        }
        //手机号验证成功才进去验证码界面
        if !validatePhone(mobile, tips: "请输入手机号", is_phone: true){
            return
        }
        if !validatePhone(codeTextField.text, tips: "请输入验证码"){

            return
        }
        if !validatePhone(newPwdTextField.text, tips: "请输入密码"){

            return
        }
        if !validatePhone(pwdTextField.text, tips: "请输入确认密码"){

            return
        }

        guard newPwdTextField.text == pwdTextField.text else{
            WOWHud.showMsg("两次输入密码不一致")
            return
        }
        if (pwdTextField.text?.length)! < 6 {
            WOWHud.showMsg("密码不能少于6位")
            return
        }
        if (pwdTextField.text?.length)! > 20 {
            WOWHud.showMsg("密码不能大于20位")
            return
        }
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_ResetPwd(mobile:mobile, captcha:codeTextField.text!, newPwd:newPwdTextField.text!), successClosure: {[weak self](result, code) in
            if let strongSelf = self{
                switch strongSelf.entrance {
                case .loginEntrance:
                  _ =  strongSelf.navigationController?.popViewController(animated: true)
                default:
                    strongSelf.reLogin()
                }
                
            }
        }) {[weak self](errorMsg) in
            if self != nil{
//                strongSelf.tipsLabel.text = errorMsg
                WOWHud.showWarnMsg(errorMsg)
            }
        }
    }
    
    func reLogin()  {
        WOWUserManager.exitLogin()
        NotificationCenter.postNotificationNameOnMainThread(WOWExitLoginNotificationKey, object: nil)
        self.toLoginVC(true)
        _ =  self.navigationController?.popToRootViewController(animated: false)
        
    }
    
    fileprivate func validatePhone(_ phoneNumber:String?,tips:String,is_phone:Bool = false) -> Bool{
        guard let phone = phoneNumber , !phone.isEmpty else{
            WOWHud.showMsg(tips)
            return false
        }
        
        if is_phone {
            guard phone.validateMobile() else{
                WOWHud.showMsg("请输入正确的手机号")
                return false
            }
        }
        return true
    }
    

//MARK:Network
  

}


//MARK:Delegate
extension WOWMsgCodeController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
