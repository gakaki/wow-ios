//
//  WOWBindMobileFirstController.swift
//  wowdsgn
//
//  Created by 安永超 on 17/2/10.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWBindMobileFirstController: WOWBaseViewController {

    //    @IBOutlet weak var tipsLabel: UILabel!
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var msgCodeButton: UIButton!

    
    var mobile:String!
    //MARK:Life
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK:Lazy
    
    //MARK:Private Method
    override func setUI() {
    
        navigationItem.title = "修改绑定手机"
        phoneTextField.text = WOWUserManager.userMobile.get_formted_xxPhone()

    }
    
    //MARK:Actions
    @IBAction func msgCodeButtonClick(_ sender: UIButton) {
//        if !validatePhone(phoneTextField.text, tips: "请输入手机号", is_phone: true){
//            return
//        }
      
        let mobile = WOWUserManager.userMobile
        sender.isUserInteractionEnabled = false
        WOWNetManager.sharedManager.requestWithTarget(.api_MobileCaptcha(mobile:mobile), successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                WOWHud.showMsg("验证码发送成功")
                strongSelf.msgCodeButton.startTimer(60, title: "重新获取", mainBGColor: UIColor.white, mainTitleColor: UIColor.black, countBGColor:UIColor.white, countTitleColor:GrayColorlevel3, handle: nil)
            }
        }) { (errorMsg) in
             sender.isUserInteractionEnabled = true
        }
        
        
    }
    
    @IBAction func sureClick(_ sender: UIButton) {
        //手机号验证成功才进去验证码界面
//        if !validatePhone(phoneTextField.text, tips: "请输入手机号", is_phone: true){
//            return
//        }
       
        if !validatePhone(codeTextField.text, tips: "请输入验证码"){
            
            return
        }

        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_OriginalMobile(mobile: WOWUserManager.userMobile, captcha: codeTextField.text!), successClosure: {[weak self](result, code) in
            if self != nil{
                VCRedirect.bingMobileSecond(entrance: .bindMobile)
            }
        }) {(errorMsg) in
//            if let strongSelf = self{
                //                strongSelf.tipsLabel.text = errorMsg
//            }
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
            guard phone == WOWUserManager.userMobile else {
                WOWHud.showMsg("请输入正确的手机号")
                return false
            }
        }
        return true
    }
    
    
    //MARK:Network
    
    
}

