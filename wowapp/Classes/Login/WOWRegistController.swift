//
//  WOWRegistController.swift
//  Wow
//
//  Created by 小黑 on 16/4/10.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWRegistController: WOWBaseViewController {
    var fromUserCenter:Bool = false
    var byWechat      :Bool = false
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var msgCodeTextField: UITextField!
    @IBOutlet weak var registButton: UIButton!
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
        configNavItem()
        navigationItem.title = byWechat ? "绑定手机" :"注册"
        registButton.setTitle(byWechat ? "绑定" :"注册", forState: .Normal)
    }
    
    private func configNavItem(){
        makeCustomerNavigationItem("已有账号?登录", left: false) {[weak self] in
            if let strongSelf = self{
                strongSelf.navBack()
            }
        }
    }
    
    private func validatePhone(phoneNumber:String?,tips:String,is_phone:Bool = false) -> Bool{
        guard let phone = phoneNumber where !phone.isEmpty else{
            WOWHud.showMsg(tips)
            tipsLabel.text = tips
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

    
//MARK:Actions
    @IBAction func msgCodeButtonClick(sender: AnyObject) {
        if !validatePhone(phoneTextField.text,tips:"请输入正确的手机号",is_phone:true){
            return
        }
        let mobile = phoneTextField.text ?? ""
        self.msgCodeButton.startTimer(60, title: "重新获取", mainBGColor: UIColor.whiteColor(), mainTitleColor: UIColor.blackColor(), countBGColor:UIColor.whiteColor(), countTitleColor:GrayColorlevel3, handle: nil)
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
        
        if passwdTextField.text?.length < 6 {
            WOWHud.showMsg("密码不能少于6位")
            tipsLabel.text = "密码不能少于6位"
            return
        }
        
        
        if agreeProtocol == false{
            WOWHud.showMsg("请阅读并同意用户协议")
            tipsLabel.text = "请阅读并同意用户协议"
            return
        }
        //FIXME:这个接口应该扩充一个字段 wechattoken 不带的话就是注册，带的话就是绑定 wowusermanager.wechatoken
        WOWNetManager.sharedManager.requestWithTarget(.Api_Register(account:phoneTextField.text!,password:passwdTextField.text!,code:msgCodeTextField.text!), successClosure: { [weak self](result) in
            if let strongSelf = self{
            let model = Mapper<WOWUserModel>().map(result)
            WOWUserManager.saveUserInfo(model)
            NSNotificationCenter.postNotificationNameOnMainThread(WOWLoginSuccessNotificationKey, object: nil)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64( 1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                let vc = UIStoryboard.initialViewController("Login", identifier:"WOWRegistInfoFirstController") as! WOWRegistInfoFirstController
                vc.fromUserCenter = strongSelf.fromUserCenter
                strongSelf.navigationController?.pushViewController(vc, animated: true)
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
        let vc = UIStoryboard.initialViewController("Login", identifier:String(WOWRegistProtocolController)) as! WOWRegistProtocolController
        vc.agreeAction = {[weak self] in
            if let strongSelf = self{
                strongSelf.protocolCheckButton.selected = true
                strongSelf.agreeProtocol = true
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
