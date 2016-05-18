//
//  WOWRegistController.swift
//  Wow
//
//  Created by 小黑 on 16/4/10.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWRegistController: WOWBaseViewController {
    

    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var msgCodeTextField: UITextField!
    
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var msgCodeButton: UIButton!
    
    @IBOutlet weak var passwdTextField: UITextField!
    
    @IBOutlet weak var protocolCheckButton: UIButton!
    
    var agreeProtocol = true
//MARK:Life
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK:Lazy
    
//MARK:Private Method
    override func setUI() {
        super.setUI()
        configNavItem()
    }
    
    private func configNavItem(){
        makeCustomerNavigationItem("已有账号?登录", left: false) {[weak self] in
            if let strongSelf = self{
                strongSelf.setCustomerBack()
            }
        }
    }
    
    private func validatePhone(phoneNumber:String?,tips:String,is_phone:Bool = false) -> Bool{
        guard let phone = phoneNumber where !phone.isEmpty else{
            WOWHud.showMsg(tips)
            return false
        }
        
        if is_phone {
            guard phone.validateMobile() else{
                WOWHud.showMsg(tips)
                return false
            }
        }
        return true
    }

    
//MARK:Actions
    @IBAction func msgCodeButtonClick(sender: AnyObject) {
        if !validatePhone(phoneTextField.text,tips:"请输入正确的手机号",is_phone:true){
            return
        }
        let mobile = phoneTextField.text ?? ""
        self.msgCodeButton.startTimer(60, title: "获取验证码", mainBGColor: ThemeColor, mainTitleColor: UIColor.blackColor(), countBGColor: GrayColorlevel3, countTitleColor:UIColor.whiteColor(), handle: nil)
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Sms(type:"1", mobile:mobile), successClosure: {[weak self] (result) in
            if let _ = self{
                
            }
        }) { (errorMsg) in
                
        }
    }
    
    
    
    
    
    
    @IBAction func registClick(sender: UIButton) {
        if !validatePhone(phoneTextField.text,tips:"请输入正确的手机号",is_phone:true){
            return
        }
        
        if !validatePhone(msgCodeTextField.text,tips:"请输入验证码"){
            return
        }
        
        if !validatePhone(passwdTextField.text,tips:"请输入密码"){
            return
        }
        
        if agreeProtocol == false{
            WOWHud.showMsg("请阅读并同意用户协议")
            return
        }
        
        WOWNetManager.sharedManager.requestWithTarget(.Api_Register(account:phoneTextField.text!,password:passwdTextField.text!,code:msgCodeTextField.text!), successClosure: { [weak self](result) in
            if let strongSelf = self{
            let model = Mapper<WOWUserModel>().map(result)
            WOWUserManager.saveUserInfo(model)
            NSNotificationCenter.postNotificationNameOnMainThread(WOWLoginSuccessNotificationKey, object: nil)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64( 1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                strongSelf.dismissViewControllerAnimated(true, completion: nil)
            })
        }
        }) {[weak self](errorMsg) in
            if let strongSelf = self{
                strongSelf.tipsLabel.text = errorMsg
            }
        }
    }
    
    @IBAction func protocolCheckButtonClick(sender:UIButton) {
        sender.selected = !sender.selected
        agreeProtocol = sender.selected
    }
    
    @IBAction func showProtocol(sender: UIButton) {
        DLog("用户协议")
        let vc = UIStoryboard.initialViewController("Login", identifier:String(WOWRegistProtocolController)) as! WOWRegistProtocolController
        vc.agreeAction = {[weak self] in
            if let strongSelf = self{
                strongSelf.protocolCheckButton.selected = true
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK:Delegate

extension WOWRegistController:UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
