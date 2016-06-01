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
    var fromUserCenter:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

//MARK:Life

    
//MARK:Lazy
    
    
//MARK:Private Method
    override func setUI() {
        configNavItem()
        wechatButton.hidden = !WXApi.isWXAppInstalled()
    }
    
    private func configNavItem(){
        makeCustomerImageNavigationItem("close", left:true) {[weak self] in
            if let strongSelf = self{
                strongSelf.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    
//MARK:Actions
    @IBAction func regist(sender: UIButton) {
        goRegist()
    }
    
    func goRegist(fromWechat:Bool = false) {
        let v = UIStoryboard.initialViewController("Login", identifier:String(WOWRegistController)) as! WOWRegistController
        v.fromUserCenter = fromUserCenter
        v.byWechat = fromWechat
        navigationController?.pushViewController(v, animated: true)
    }
    
    @IBAction func forgetPasswordClick(sender: UIButton) {
        let vc = UIStoryboard.initialViewController("Login", identifier:String(WOWMsgCodeController)) as! WOWMsgCodeController
        vc.entrance  = .ForgetPasswordHome
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func wechatLogin(sender: UIButton) {
        let snsPlat = UMSocialSnsPlatformManager.getSocialPlatformWithName(UMShareToWechatSession)
        UMSocialControllerService.defaultControllerService().socialUIDelegate = self
        snsPlat.loginClickHandler(self, UMSocialControllerService.defaultControllerService(), true, {[weak self]response in
            if let strongSelf = self{
                if response.responseCode == UMSResponseCodeSuccess {
                    let snsAccount:UMSocialAccountEntity = UMSocialAccountManager.socialAccountDictionary()[UMShareToWechatSession] as! UMSocialAccountEntity
                    DLog("username is \(snsAccount.userName), uid is \(snsAccount.usid), token is \(snsAccount.accessToken) url is \(snsAccount.iconURL)")
                    let token = snsAccount.accessToken
                    strongSelf.checkWechatToken(token)
                }else{
                    DLog(response)
                }
            }
        })
    }
    
    private func checkWechatToken(token:String?){
        //FIXME:验证token是否是第一次咯或者是第二次
        WOWUserManager.wechatToken = token ?? ""
        let first = true //假设的bool值
        if first {
            goRegist(true)
        }else{ //二次登录，拿到用户信息，这时候算是登录成功咯
            //FIXME:未写的，先保存用户信息
            loginSuccess()
        }
    }
    
    
    private func loginSuccess(){
        WOWBuyCarMananger.updateBadge()
        NSNotificationCenter.postNotificationNameOnMainThread(WOWLoginSuccessNotificationKey, object: nil)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64( 0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.dismissViewControllerAnimated(true, completion: nil)
            if self.fromUserCenter{
                UIApplication.appTabBarController.selectedIndex = 0
            }
        })
    }
    
    @IBAction func login(sender: UIButton) {
        guard let phone = accountTextField.text where !phone.isEmpty else{
            WOWHud.showMsg("请输入账号")
            tipsLabel.text = "请输入账号"
            return
        }
        guard let passwd = passWordTextField.text where !passwd.isEmpty else{
            WOWHud.showMsg("请输入密码")
            tipsLabel.text = "请输入密码"
            return
        }
        guard phone.validateMobile() || phone.validateEmail() else{
            WOWHud.showMsg("对不起，账号格式错误")
            tipsLabel.text = "账号格式错误"
            return
        }
        WOWNetManager.sharedManager.requestWithTarget(.Api_Login(phone,passwd), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                DLog(result)
                let model = Mapper<WOWUserModel>().map(result)
                WOWUserManager.saveUserInfo(model)
                strongSelf.loginSuccess()
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.tipsLabel.text = errorMsg
            }
        }
    }
}



//MARK:Delegate
extension WOWLoginController:UMSocialUIDelegate{
    
}

extension WOWLoginController:UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}




