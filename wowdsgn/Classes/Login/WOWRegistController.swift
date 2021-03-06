
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
        navigationItem.title = "注册"
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
    @IBAction func msgCodeButtonClick(_ sender: UIButton) {
        
        MobClick.e(UMengEvent.Bind_Mobile_Validate)

        if !validatePhone(phoneTextField.text,tips:"请输入手机号",is_phone:true){
            return
        }
        let mobile = phoneTextField.text ?? ""
        let Api_Code = RequestApi.api_Sms_Code
        WOWNetManager.sharedManager.requestWithTarget(Api_Code(mobile:mobile), successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                WOWHud.showMsg("验证码发送成功")
                
                strongSelf.msgCodeButton.startTimer(60, title: "重新获取", mainBGColor: UIColor.white, mainTitleColor: UIColor.black, countBGColor:UIColor.white, countTitleColor:GrayColorlevel3, handle: nil)
            }
        }) { (errorMsg) in
            WOWHud.showWarnMsg(errorMsg)

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
            return
        }
        if (passwdTextField.text?.length)! > 20 {
            WOWHud.showMsg("密码不能大于20位")
            return
        }
        
        
        if agreeProtocol == false{
            WOWHud.showMsg("请阅读并同意用户协议")
            return
        }
        //FIXME:这个接口应该扩充一个字段 wechattoken 不带的话就是注册，带的话就是绑定 wowusermanager.wechatoken
        //注册时的信息
        var registerTarget = RequestApi.api_Register(account:phoneTextField.text ?? "",
                                                     password:passwdTextField.text ?? "",
                                                     captcha:msgCodeTextField.text ?? "")


        
            WOWNetManager.sharedManager.requestWithTarget(registerTarget, successClosure: { [weak self](result, code)in
                if let strongSelf = self{
                    let model = Mapper<WOWUserModel>().map(JSONObject:result)
                    WOWUserManager.saveUserInfo(model)
                    //暂时保存一下手机号
                    MobClick.e(.Registration_Successful)

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
                        VCRedirect.toRegInfo(strongSelf.isPresent)
                    }
                    
        }
        }) {[weak self](errorMsg) in
            if let strongSelf = self{
                WOWHud.showWarnMsg(errorMsg)
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
