//
//  WOWLoginController.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/19.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWLoginController: WOWBaseViewController {

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var tipsLabel: UILabel!
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
        let v = UIStoryboard.initialViewController("Login", identifier:String(WOWRegistController))
        navigationController?.pushViewController(v, animated: true)
    }
    
    @IBAction func forgetPasswordClick(sender: UIButton) {
        let vc = UIStoryboard.initialViewController("Login", identifier:String(WOWMsgCodeController)) as! WOWMsgCodeController
        vc.entrance  = .ForgetPasswordHome
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func wechatLogin(sender: UIButton) {
        DLog("微信登录")
        
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
                WOWBuyCarMananger.updateBadge()
                NSNotificationCenter.postNotificationNameOnMainThread(WOWLoginSuccessNotificationKey, object: nil)
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64( 0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                    strongSelf.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.tipsLabel.text = errorMsg
            }
        }
    }
}



//MARK:Delegate
extension WOWLoginController:UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}




