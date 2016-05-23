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
        super.setUI()
        navigationItem.title = "忘记密码"
        switch entrance {
        case .ForgetPasswordCode:
            leftLabel.text = "验证码"
            codeTextField.placeholder = "请输入6位验证码"
            codeTextField.keyboardType = .NumbersAndPunctuation
        case .ForgetPasswordHome:
            leftLabel.text = "注册手机号"
            codeTextField.keyboardType = .NumberPad
            codeTextField.placeholder = "请输入11位手机号码"
        default:
            break
        }
    }
    
    
//MARK:Actions

    @IBAction func nextClick(sender: UIButton) {
        switch entrance { //从第一页进去
        case .ForgetPasswordHome:
            entranceSmsCode()
        default: //第二页进去
            let code = codeTextField.text ?? ""
            if code.isEmpty {
                WOWHud.showMsg("请输入验证码")
                return
            }
            let vc = UIStoryboard.initialViewController("Login", identifier:String(WOWPasswordController)) as! WOWPasswordController
            vc.mobile = self.mobile
            vc.code = code
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func entranceSmsCode(){
        //手机号验证成功才进去验证码界面
        if !validatePhone(codeTextField.text){
            return
        }
        let mobile = codeTextField.text ?? ""
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Sms(type:"2", mobile:mobile), successClosure: { [weak self](result) in
            if let strongSelf = self{
                let vc = UIStoryboard.initialViewController("Login", identifier:String(WOWMsgCodeController)) as! WOWMsgCodeController
                vc.entrance  = .ForgetPasswordCode
                vc.mobile = strongSelf.codeTextField.text
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        }) { (errorMsg) in
            
        }
    }
    
    private func validatePhone(phoneNumber:String?) -> Bool{
        guard let phone = phoneNumber where !phone.isEmpty else{
            WOWHud.showMsg("请输入手机号")
            return false
        }
        
        guard phone.validateMobile() else{
            WOWHud.showMsg("请输入正确的手机号")
            return false
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
