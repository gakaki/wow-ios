//
//  WOWLoginController.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/19.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit
class WOWLoginController: WOWBaseViewController {
    @IBOutlet weak var wechatButton: UIButton!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var tipsLabel: UILabel!
    var isPresent:Bool = false
    
    var isPopRootVC:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

//MARK:Life

    
//MARK:Lazy
//                
    
//MARK:Private Method
    override func setUI() {
        configNavItem()
        wechatButton.isHidden = !WXApi.isWXAppInstalled()
    }
    
    fileprivate func configNavItem(){
        makeCustomerImageNavigationItem("close", left:true) {[weak self] in
            if let strongSelf = self{
//                strongSelf.dismissViewControllerAnimated(true, completion: nil)
                if strongSelf.isPopRootVC {
                    strongSelf.dismiss(animated: true, completion: {
                       _ = UIApplication.currentViewController()?.navigationController?.popToRootViewController(animated: true)
                    })

                }else{
                    strongSelf.dismiss(animated: true, completion: nil)
                }
                if WOWTool.lastTabIndex == 3 {
                    WOWTool.lastTabIndex = 0
                }
                UIApplication.appTabBarController.selectedIndex = WOWTool.lastTabIndex
                
                
            }
        }
    }
    
    
//MARK:Actions
    @IBAction func regist(_ sender: UIButton) {
//        toRegVC(false,isPresent: isPresent)
        toRegVC(false, isPresent: isPresent, userInfoFromWechat: nil)
        
    }
    
    
    @IBAction func forgetPasswordClick(_ sender: UIButton) {
        let vc = UIStoryboard.initialViewController("Login", identifier:String(describing: WOWMsgCodeController.self)) as! WOWMsgCodeController
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func wechatLogin(_ sender: UIButton) {
//        let snsPlat = UMSocialSnsPlatformManager.getSocialPlatformWithName(UMShareToWechatSession)
//        UMSocialControllerService.defaultControllerService().socialUIDelegate = self
//        snsPlat.loginClickHandler(self, UMSocialControllerService.defaultControllerService(), true, {[weak self]response in
//            if let strongSelf = self{
//                if response.responseCode == UMSResponseCodeSuccess {
//                    let snsAccount:UMSocialAccountEntity = UMSocialAccountManager.socialAccountDictionary()[UMShareToWechatSession] as! UMSocialAccountEntity
//                    DLog("username is \(snsAccount.userName), uid is \(snsAccount.usid), token is \(snsAccount.accessToken) url is \(snsAccount.iconURL)")
//                    let token = snsAccount.accessToken
//                    strongSelf.checkWechatToken(token)
//                }else{
//                    DLog(response)
//                }
//            }
//        })
        

        toWeixinVC(isPresent)
    }
    
    
    @IBAction func login(_ sender: UIButton) {
        guard let phone = accountTextField.text , !phone.isEmpty else{
            WOWHud.showMsg("请输入手机号")
            tipsLabel.text = "请输入手机号"
            return
        }
        guard let passwd = passWordTextField.text , !passwd.isEmpty else{
            WOWHud.showMsg("请输入密码")
            tipsLabel.text = "请输入密码"
            return
        }
        guard phone.validateMobile() || phone.validateEmail() else{
            WOWHud.showMsg("请输入正确的手机号")
            tipsLabel.text = "请输入正确的手机号"
            return
        }
        
        WOWNetManager.sharedManager.requestWithTarget(.api_Login(phone,passwd), successClosure: {[weak self](result, code) in
            if let strongSelf = self{
                DLog(result)
                
                let model = Mapper<WOWUserModel>().map(JSONObject:result)
                WOWUserManager.saveUserInfo(model)
                
                TalkingDataAppCpa.onLogin(phone)
                
                strongSelf.toLoginSuccess(strongSelf.isPresent)
                
                
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.tipsLabel.text = errorMsg
            }
        }
    }
}



//MARK:Delegate
//extension WOWLoginController:UMSocialUIDelegate{
//    
//}

extension WOWLoginController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}




