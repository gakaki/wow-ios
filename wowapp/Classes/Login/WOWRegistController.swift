//
//  WOWRegistController.swift
//  Wow
//
//  Created by 小黑 on 16/4/10.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWRegistController: WOWBaseViewController {
    var isPresent      :Bool = false
    var byWechat            :Bool = false
    var userInfoFromWechat  :NSDictionary?
    
    
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
        
//        navigationItem.title = "绑定手机"
        registButton.setTitle( "确定" , forState: .Normal)

    }
    
    private func configNavItem(){
        makeCustomerNavigationItem("已有账号 登录", left: false) {[weak self] in
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
        let Api_Code = byWechat ? RequestApi.Api_Captcha :RequestApi.Api_Sms_Code
        
        WOWNetManager.sharedManager.requestWithTarget(Api_Code(mobile:mobile), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                WOWHud.showMsg("验证码发送成功")
                strongSelf.msgCodeButton.startTimer(60, title: "重新获取", mainBGColor: UIColor.whiteColor(), mainTitleColor: UIColor.blackColor(), countBGColor:UIColor.whiteColor(), countTitleColor:GrayColorlevel3, handle: nil)
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
        if passwdTextField.text?.length > 20 {
            WOWHud.showMsg("密码不能大于20位")
            tipsLabel.text = "密码不能大于20位"
            return
        }
        
        
        if agreeProtocol == false{
            WOWHud.showMsg("请阅读并同意用户协议")
            tipsLabel.text = "请阅读并同意用户协议"
            return
        }
        //FIXME:这个接口应该扩充一个字段 wechattoken 不带的话就是注册，带的话就是绑定 wowusermanager.wechatoken
        //注册时的信息
        var registerTarget = RequestApi.Api_Register(account:phoneTextField.text!,password:passwdTextField.text!,captcha:msgCodeTextField.text!)
        //如果是通过微信就走微信绑定的接口，如果是注册的话就走注册的接口
        if let userInfoFromWechat = userInfoFromWechat {
            //微信的用户信息
            let param = ["openId":userInfoFromWechat["openid"] as! String ,"wechatNickName":userInfoFromWechat["nickname"] as! String,"wechatAvatar":userInfoFromWechat["headimgurl"] as! String,"sex":userInfoFromWechat["sex"]! ]
             registerTarget = RequestApi.Api_WechatBind(mobile: phoneTextField.text!, captcha: msgCodeTextField.text!, password: passwdTextField.text!, userInfoFromWechat: param)
        }

        
            WOWNetManager.sharedManager.requestWithTarget(registerTarget, successClosure: { [weak self](result) in
                if let strongSelf = self{
                let model = Mapper<WOWUserModel>().map(result)
                    WOWUserManager.saveUserInfo(model)
                    //暂时保存一下手机号
                    WOWUserManager.userMobile = strongSelf.phoneTextField.text!
                    
                let newUser = JSON(result)["newUser"].int
                    //判断如果是新用户的话就去填写资料，如果不是的话就登录成功
                    if newUser == 0 {
                        strongSelf.toLoginSuccess(strongSelf.isPresent)
                    }else {
                        strongSelf.toRegInfo(strongSelf.isPresent)
                    }
                    
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
