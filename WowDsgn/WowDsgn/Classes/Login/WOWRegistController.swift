//
//  WOWRegistController.swift
//  Wow
//
//  Created by 小黑 on 16/4/10.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWRegistController: WOWBaseViewController {
    

    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var msgCodeTextField: UITextField!
    
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var msgCodeButton: UIButton!
    
    @IBOutlet weak var passwdTextField: UITextField!
    
    @IBOutlet weak var protocolCheckButton: UIButton!
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
        super.setUI()
        configNavItem()
    }
    
    private func configNavItem(){
        makeCustomerNavigationItem("已有账号?登录", left: false) {[weak self] in
            if let strongSelf = self{
                strongSelf.back()
            }
        }
//        makeCustomerImageNavigationItem("closeNav_white", left:true) {[weak self] in
//            if let strongSelf = self{
//                strongSelf.navigationController?.popViewControllerAnimated(true)
//            }
//        }
    }
    
    private func validatePhone(phoneNumber:String?) -> Bool{
        guard let phone = phoneNumber where !phone.isEmpty else{
            WOWHud.showMsg("请输入账号")
            return false
        }
        
        guard phone.validateMobile() else{
            WOWHud.showMsg("请输入正确的手机号")
            return false
        }
        return true
    }
    
//MARK:Actions
    private func back(){
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func msgCodeButtonClick(sender: AnyObject) {
        if !validatePhone(phoneTextField.text){
            return
        }
        
        
        
    }
    
    
    
    
    
    
    @IBAction func registClick(sender: UIButton) {
        
    }
    
    @IBAction func protocolCheckButtonClick(sender:UIButton) {
        sender.selected = !sender.selected
    }
    
    @IBAction func showProtocol(sender: UIButton) {
        DLog("用户协议")
        let vc = UIStoryboard.initialViewController("Login", identifier:String(WOWRegistProtocolController)) as! WOWRegistProtocolController
        vc.agreeAction = {[weak self] in
            if let strongSelf = self{
                strongSelf.protocolCheckButton.selected = true
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    

   
}

//MARK:Delegate
