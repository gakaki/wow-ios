
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
    var userInfoFromWechat  :Dictionary<String, Any>?
    
    
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
//        configNavItem()
        navigationItem.title = byWechat ? "绑定手机" :"注册"
        registButton.setTitle(byWechat ? "绑定" :"注册", for: UIControlState())
        
//        navigationItem.title = "绑定手机"
        registButton.setTitle( "确定" , for: UIControlState())

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

    
//MARK:Actions
    @IBAction func msgCodeButtonClick(_ sender: AnyObject) {
        
        MobClick.e(UMengEvent.Bind_Mobile_Validate)

        if !validatePhone(phoneTextField.text,tips:"请输入手机号",is_phone:true){
            return
        }
        let mobile = phoneTextField.text ?? ""
        let Api_Code = byWechat ? RequestApi.api_Captcha :RequestApi.api_Sms_Code
//        sender.isUserInteractionEnabled = false
        WOWHud.showLoadingSV()
        WOWNetManager.sharedManager.requestWithTarget(Api_Code(mobile:mobile), successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                WOWHud.dismiss()
                WOWHud.showMsg("验证码发送成功")
                
                strongSelf.msgCodeButton.startTimer(60, title: "重新获取", mainBGColor: UIColor.white, mainTitleColor: UIColor.black, countBGColor:UIColor.white, countTitleColor:GrayColorlevel3, handle: nil)
            }
        }) { (errorMsg) in
            WOWHud.dismiss()
//                sender.isUserInteractionEnabled = true
        }
    }
    
    
    @IBAction func registClick(_ sender: UIButton) {
        MobClick.e(UMengEvent.Bind_Mobile_Bind)
        
        if !validatePhone(phoneTextField.text,tips:"请输入手机号",is_phone:true){
            return
        }
        
        if !validatePhone(msgCodeTextField.text,tips:"请输入验证码"){
            return
        }
        
        if !validatePhone(passwdTextField.text,tips:"请输入密码"){
            return
        }
        
        if (passwdTextField.text?.length)! < 6 {
            WOWHud.showMsg("密码不能少于6位")
            tipsLabel.text = "密码不能少于6位"
            return
        }
        if (passwdTextField.text?.length)! > 20 {
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
        var registerTarget = RequestApi.api_Register(account:phoneTextField.text ?? "",
                                                     password:passwdTextField.text ?? "",
                                                     captcha:msgCodeTextField.text ?? "")
        //如果是通过微信就走微信绑定的接口，如果是注册的话就走注册的接口
        if let userInfoFromWechat = userInfoFromWechat {
            //微信的用户信息
            let param = ["openId":userInfoFromWechat["openid"] as! String,
                         "wechatNickName":userInfoFromWechat["nickname"] as! String,
                         "wechatAvatar":userInfoFromWechat["headimgurl"] as! String,
                         "sex":userInfoFromWechat["sex"] ?? "",
                         "unionId": userInfoFromWechat["unionid"] as! String,
                         "country": userInfoFromWechat["country"] ?? "",
                         "province": userInfoFromWechat["province"] ?? "",
                         "city": userInfoFromWechat["city"] ]
             registerTarget = RequestApi.api_WechatBind(mobile: phoneTextField.text ?? "",
                                                        captcha: msgCodeTextField.text ?? "",
                                                        password: passwdTextField.text ?? "",
                                                        userInfoFromWechat: param as AnyObject)
        }

        
            WOWNetManager.sharedManager.requestWithTarget(registerTarget, successClosure: { [weak self](result, code)in
                if let strongSelf = self{
                    let model = Mapper<WOWUserModel>().map(JSONObject:result)
                    WOWUserManager.saveUserInfo(model)
                    //暂时保存一下手机号
                    
                    let user_mobile           = strongSelf.phoneTextField.text!
                    WOWUserManager.userMobile = user_mobile
                    
                    

                let newUser = JSON(result)["newUser"].int
                    //判断如果是新用户的话就去填写资料，如果不是的话就登录成功
                    if newUser == 0 {
                        TalkingDataAppCpa.onLogin(user_mobile)
                        AnalyaticEvent.e2(.Login,["user":user_mobile])

                        VCRedirect.toLoginSuccess(strongSelf.isPresent)
                    }else {
                       
                        TalkingDataAppCpa.onRegister(user_mobile)
                        AnalyaticEvent.e2(.Regist,["user":user_mobile])
                        MobClick.e(.Registration_Successful)
                        VCRedirect.toRegInfo(strongSelf.isPresent)
                    }
                    
        }
        }) {[weak self](errorMsg) in
            if let strongSelf = self{
                strongSelf.tipsLabel.text = errorMsg
            }
        }
    }
    

    @IBAction func protocolCheckButtonClick(_ sender:UIButton) {
        sender.isSelected = !sender.isSelected
        agreeProtocol = sender.isSelected
    }
    
    @IBAction func showProtocol(_ sender: UIButton) {
        let vc = UIStoryboard.initialViewController("Login", identifier:String(describing: WOWRegistProtocolController.self)) as! WOWRegistProtocolController
            vc.agreeAction = {[weak self] in
                if let strongSelf = self{
                    strongSelf.protocolCheckButton.isSelected = true
                    strongSelf.agreeProtocol = true
                }
            }
            navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK:Delegate

extension WOWRegistController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
