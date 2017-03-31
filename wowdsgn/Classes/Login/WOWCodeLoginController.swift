//
//  WOWCodeLoginController.swift
//  wowdsgn
//
//  Created by 安永超 on 17/2/14.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWCodeLoginController: WOWBaseViewController {
    @IBOutlet weak var wechatButton: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var msgCodeButton: UIButton!
    @IBOutlet weak var codeView: UIView!
    var isPresent:Bool = false
    
    var isPopRootVC:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        phoneTextField.text = ""
        codeTextField.text = ""
    }
    
    //MARK:Private Method
    override func setUI() {
        wechatButton.isHidden = !WXApi.isWXAppInstalled()
//        codeView.borderColor(0.5, borderColor: UIColor.init(hexString: "#EAEAEA")!)
    }
    
    
    
    //MARK:Actions
    @IBAction func regist(_ sender: UIButton) {
        
        VCRedirect.toRegVC(false, isPresent: isPresent, userInfoFromWechat: nil)
        
    }
    
    
    @IBAction func forgetPasswordClick(_ sender: UIButton) {
        if !validatePhone(phoneTextField.text, tips: "请输入手机号", is_phone: true){
            return
        }
        let mobile = phoneTextField.text ?? ""
        WOWHud.showLoadingSV()
        WOWNetManager.sharedManager.requestWithTarget(.api_LoginCaptcha(mobile:mobile), successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                WOWHud.dismiss()
                WOWHud.showMsg("验证码发送成功")
                strongSelf.msgCodeButton.startTimer(60, title: "重新获取", mainBGColor: UIColor.white, mainTitleColor: UIColor.black, countBGColor:UIColor.white, countTitleColor:GrayColorlevel3, handle: nil)
            }
        }) { (errorMsg) in
              LoadView.dissMissView()
            WOWHud.showMsgNoNetWrok(message: errorMsg)
        }

        
    }
    
    @IBAction func wechatLogin(_ sender: UIButton) {
        
        
        toWeixinVC(isPresent)
    }
    
    
    @IBAction func login(_ sender: UIButton) {
        let phone = phoneTextField.text
        let code = codeTextField.text
        if !validatePhone(phone, tips: "请输入手机号", is_phone: true){
            return
        }
        if !validatePhone(code, tips: "请输入验证码"){
            
            return
        }
        
        WOWHud.showLoading()
        WOWNetManager.sharedManager.requestWithTarget(.api_LoginByCaptcha(mobile: phone!, captcha: code!), successClosure: {[weak self](result, code) in
            
            if let strongSelf = self{
                DLog(result)
                WOWHud.dismiss()
                let model = Mapper<WOWUserModel>().map(JSONObject:result)
                WOWUserManager.saveUserInfo(model)
                
                
                TalkingDataAppCpa.onLogin(phone!)
                AnalyaticEvent.e2(.Login,["user":phone!])
                
                
                WOWUserManager.userMobile = phone!
                VCRedirect.toLoginSuccess(strongSelf.isPresent)
                
                
                
            }
        }) {[weak self] (errorMsg) in
            if self != nil{
                WOWHud.dismiss()
                WOWHud.showMsgNoNetWrok(message: errorMsg)
            }
        }
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
    
}
