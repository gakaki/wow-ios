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

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

//MARK:Life

    
//MARK:Lazy
    
    
//MARK:Private Method
    override func setUI() {
        super.setUI()
        configNavItem()
    }
    
    private func configNavItem(){
        makeCustomerNavigationItem("注册", left: false) {[weak self] in
            if let strongSelf = self{
                strongSelf.regist()
            }
        }
        makeCustomerImageNavigationItem("closeNav_white", left:true) {[weak self] in
            if let strongSelf = self{
                strongSelf.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    
//MARK:Actions

    
    private func regist(){
        let v = UIStoryboard.initialViewController("Login", identifier:String(WOWRegistController))
        navigationController?.pushViewController(v, animated: true)
    }
    
    
    @IBAction func forgetPasswordClick(sender: UIButton) {
        DLog("忘记密码")
//        let vc = UIStoryboard.initialViewController("Login", identifier:String(WOWMsgCodeController)) as! WOWMsgCodeController
//        vc.entrance  = .ForgetPasswordHome
//        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func login(sender: UIButton) {
        guard let phone = accountTextField.text where !phone.isEmpty else{
            WOWHud.showMsg("请输入账号")
            return
        }
        guard let passwd = passWordTextField.text where !passwd.isEmpty else{
            WOWHud.showMsg("请输入密码")
            return
        }
        guard phone.validateMobile() || phone.validateEmail() else{
            WOWHud.showMsg("对不起，账号格式错误")
            return
        }
        WOWNetManager.sharedManager.requestWithTarget(.Api_Login(phone,passwd), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                WOWHud.showMsg("登录成功")
                NSNotificationCenter.postNotificationNameOnMainThread(WOWLoginSuccessNotificationKey, object: nil)
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64( 2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                    strongSelf.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        }) { (errorMsg) in
                
        }
        
    }
    
}


//MARK:Delegate


