//
//  WOWBindMobileSecondViewController.swift
//  wowdsgn
//
//  Created by 安永超 on 17/2/10.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
 public enum BindMobileEntrance {
    case userInfo
    case bindMobile
    case editOrder
    case orderDetail
}

class WOWBindMobileSecondViewController: WOWBaseViewController {
    //    @IBOutlet weak var tipsLabel: UILabel!
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var msgCodeButton: UIButton!
    
    var action  : WOWObjectActionClosure?
    
    var entrance = BindMobileEntrance.userInfo     //入口
    var mobile:String!
    //MARK:Life
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if entrance == .editOrder{
            
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false;

            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        MobClick.e(.Bind_Phonepage_Reg)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
    }
    //MARK:Lazy
    
    //MARK:Private Method
    override func setUI() {
        
        navigationItem.title = "手机绑定"
        switch entrance {
        case .bindMobile:
            phoneTextField.placeholder = "请输入新手机号"
        default:
            phoneTextField.placeholder = "请输入手机号"
        }
        
    }
    
    func goBack() {
        switch entrance {
        case .bindMobile:
            for controller in (navigationController?.viewControllers)! {
                if controller.isKind(of: WOWUserInfoController.self){
                    let _ = navigationController?.popToViewController(controller, animated: true)
                }
            }
        case .editOrder, .orderDetail:
            if let ac = action{
                ac(true as AnyObject)
                popVC()
            }

        default:
            let _ = navigationController?.popViewController(animated: true)
        }
    }
    
    override func navBack() {
        switch entrance {

        case .editOrder:
            if let ac = action{
                popVC()
                ac(false as AnyObject)

            }
            
        default:
            let _ = navigationController?.popViewController(animated: true)
        }
    }

    //MARK:Actions
    @IBAction func msgCodeButtonClick(_ sender: UIButton) {
        if !validatePhone(phoneTextField.text, tips: "请输入手机号", is_phone: true){
            return
        }
        let mobile = phoneTextField.text ?? ""
         sender.isUserInteractionEnabled = false
        WOWNetManager.sharedManager.requestWithTarget(.api_NewMobileCaptcha(mobile:mobile), successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                WOWHud.showMsg("验证码发送成功")
                strongSelf.msgCodeButton.startTimer(60, title: "重新获取", mainBGColor: UIColor.white, mainTitleColor: UIColor.black, countBGColor:UIColor.white, countTitleColor:GrayColorlevel3, handle: nil)
            }
        }) { (errorMsg) in
             sender.isUserInteractionEnabled = true
            WOWHud.showWarnMsg(errorMsg)
        }
        
        
    }
    
    @IBAction func sureClick(_ sender: UIButton) {
        
        //手机号验证成功才进去验证码界面
        if !validatePhone(phoneTextField.text, tips: "请输入手机号", is_phone: true){
            return
        }
        if !validatePhone(codeTextField.text, tips: "请输入验证码"){
            
            return
        }
        
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_BindMobile(mobile: phoneTextField.text!, captcha: codeTextField.text!), successClosure: {[weak self](result, code) in
            if let strongSelf = self{
                WOWHud.showMsg("绑定成功")
                WOWUserManager.userMobile = strongSelf.phoneTextField.text!
                strongSelf.goBack()

            }
        }) {(errorMsg) in
            WOWHud.showWarnMsg(errorMsg)

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
