//
//  WOWPwdLoginController.swift
//  wowdsgn
//
//  Created by 安永超 on 17/2/14.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWPwdLoginController: WOWBaseViewController {
    @IBOutlet weak var wechatButton: UIButton!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var pwdView: UIView!
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
        accountTextField.text = ""
        passWordTextField.text = ""
    }
    
    //MARK:Private Method
    override func setUI() {
        wechatButton.isHidden = !WXApi.isWXAppInstalled()
//        pwdView.borderColor(0.5, borderColor: UIColor.init(hexString: "#EAEAEA")!)
    }

    //MARK:Actions
    @IBAction func regist(_ sender: UIButton) {

        VCRedirect.toRegVC(false, isPresent: isPresent, userInfoFromWechat: nil)
        
    }
    
    
    @IBAction func forgetPasswordClick(_ sender: UIButton) {
        let vc = UIStoryboard.initialViewController("Login", identifier:String(describing: WOWMsgCodeController.self)) as! WOWMsgCodeController
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func wechatLogin(_ sender: UIButton) {
        
        
        toWeixinVC(isPresent)
    }
    
    
    @IBAction func login(_ sender: UIButton) {
        guard let phone = accountTextField.text , !phone.isEmpty else{
            WOWHud.showMsg("请输入手机号")
            return
        }
        guard let passwd = passWordTextField.text , !passwd.isEmpty else{
            WOWHud.showMsg("请输入密码")
            return
        }
        guard phone.validateMobile() || phone.validateEmail() else{
            WOWHud.showMsg("请输入正确的手机号")
            return
        }
        
        WOWHud.showLoading()
        WOWNetManager.sharedManager.requestWithTarget(.api_Login(phone,passwd), successClosure: {[weak self](result, code) in
            
            if let strongSelf = self{
                DLog(result)
                WOWHud.dismiss()
                let model = Mapper<WOWUserModel>().map(JSONObject:result)
                WOWUserManager.saveUserInfo(model)
                
                
                TalkingDataAppCpa.onLogin(phone)
                AnalyaticEvent.e2(.Login,["user":phone])
                
                
                WOWUserManager.userMobile = phone
                VCRedirect.toLoginSuccess(strongSelf.isPresent)
                
                
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                WOWHud.dismiss()
            }
        }
    }
    

    
}



//MARK:Delegate
//extension WOWLoginController:UMSocialUIDelegate{
//
//}

extension WOWPwdLoginController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
