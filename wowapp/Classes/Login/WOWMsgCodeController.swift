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
    
    @IBOutlet weak var tipsLabel: UILabel!

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

        default:
            navigationItem.title = "修改密码"

        }
       
    }

//MARK:Actions
    @IBAction func msgCodeButtonClick(sender: UIButton) {
        if !validatePhone(phoneTextField.text,tips:"请输入正确的手机号",is_phone:true){
            return
        }
        let mobile = phoneTextField.text ?? ""
        
        WOWNetManager.sharedManager.requestWithTarget(.Api_PwdResetCode(mobile:mobile), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                WOWHud.showMsg("验证码发送成功")
                strongSelf.msgCodeButton.startTimer(60, title: "重新获取", mainBGColor: UIColor.whiteColor(), mainTitleColor: UIColor.blackColor(), countBGColor:UIColor.whiteColor(), countTitleColor:GrayColorlevel3, handle: nil)
            }
        }) { (errorMsg) in
            
        }

    
    }

    @IBAction func sureClick(sender: UIButton) {
        
        //手机号验证成功才进去验证码界面
        if !validatePhone(phoneTextField.text){
            return
        }
        guard let code = codeTextField.text where !code.isEmpty else{
            WOWHud.showMsg("请输入验证码")
            tipsLabel.text = "请输入验证码"
            return
        }
        guard let newPwd = newPwdTextField.text where !newPwd.isEmpty else{
            WOWHud.showMsg("请输入密码")
            tipsLabel.text = "请输入密码"
            return
        }
        guard let passwd = pwdTextField.text where !passwd.isEmpty else{
            WOWHud.showMsg("请输入确认密码")
            tipsLabel.text = "请输入确认密码"
            return
        }

        guard newPwd == passwd else{
            WOWHud.showMsg("两次输入密码不一致")
            tipsLabel.text = "两次输入密码不一致"
            return
        }
        if pwdTextField.text?.length < 6 {
            WOWHud.showMsg("密码不能少于6位")
            tipsLabel.text = "密码不能少于6位"
            return
        }
        if pwdTextField.text?.length > 20 {
            WOWHud.showMsg("密码不能大于20位")
            tipsLabel.text = "密码不能大于20位"
            return
        }
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_ResetPwd(mobile:phoneTextField.text!, captcha:code, newPwd:newPwd), successClosure: {[weak self](result) in
            if let strongSelf = self{
                switch strongSelf.entrance {
                case .loginEntrance:
                    strongSelf.navigationController?.popViewControllerAnimated(true)
                default:
                    WOWUserManager.exitLogin()
                    NSNotificationCenter.postNotificationNameOnMainThread(WOWExitLoginNotificationKey, object: nil)
                    strongSelf.navigationController?.popToRootViewControllerAnimated(false)
                    strongSelf.toLoginVC(true)
                }
                
            }
        }) {[weak self](errorMsg) in
            if let strongSelf = self{
                strongSelf.tipsLabel.text = errorMsg
            }
        }
    }
    
    
    private func entranceSmsCode(){
        //手机号验证成功才进去验证码界面
        if !validatePhone(codeTextField.text){
            return
        }
        let mobile = codeTextField.text ?? ""
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_PwdResetCode(mobile: mobile), successClosure: { [weak self](result) in
            if let strongSelf = self{
                let vc = UIStoryboard.initialViewController("Login", identifier:String(WOWMsgCodeController)) as! WOWMsgCodeController
                vc.mobile = strongSelf.codeTextField.text
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        }) {[weak self](errorMsg) in
            if let strongSelf = self{
                strongSelf.tipsLabel.text = errorMsg
            }
        }
    }
    
    private func validatePhone(phoneNumber:String?) -> Bool{
        guard let phone = phoneNumber where !phone.isEmpty else{
            WOWHud.showMsg("请输入手机号")
            tipsLabel.text = "请输入手机号"
            return false
        }
        
        guard phone.validateMobile() else{
            WOWHud.showMsg("请输入正确的手机号")
            tipsLabel.text = "请输入正确的手机号"
            return false
        }
        return true
    }
    
    private func validatePhone(phoneNumber:String?,tips:String,is_phone:Bool = false) -> Bool{
        guard let phone = phoneNumber where !phone.isEmpty else{
            WOWHud.showMsg("请输入手机号")
            tipsLabel.text = "请输入手机号"
            return false
        }
        
        if is_phone {
            guard phone.validateMobile() else{
                WOWHud.showMsg(tips)
                tipsLabel.text = tips
                return false
            }
        }
        return true
    }
    

//MARK:Network
  

}


//MARK:Delegate
extension WOWMsgCodeController:UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
