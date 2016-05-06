//
//  WOWPasswordController.swift
//  Wow
//
//  Created by 小黑 on 16/4/10.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWPasswordController: WOWBaseViewController {
    @IBOutlet weak var firstPassTextField: UITextField!
    @IBOutlet weak var secondPassTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var tipsLabel: UILabel!
    
    var mobile:String!
    var code:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setUI() {
        super.setUI()
        navigationItem.title = "重置密码"
        
    }

    
    @IBAction func nextClick(sender: UIButton) {
        guard let f = firstPassTextField.text where !f.isEmpty else{
            WOWHud.showMsg("请输入密码")
            return
        }
        
        guard let s = secondPassTextField.text where !s.isEmpty else{
            WOWHud.showMsg("请确认密码")
            return
        }
        
        guard f == s else{
            WOWHud.showMsg("两次输入密码不一致")
            return
        }
        
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_ResetPwd(mobile:mobile, code:code, password:f), successClosure: {[weak self](result) in
            if let strongSelf = self{
                let json = JSON(result).string
                if let ret = json where ret == "ok"{
                    strongSelf.navigationController?.popToRootViewControllerAnimated(true)
                }
            }
        }) { (errorMsg) in
                
        }
        
    }
    
}

extension WOWPasswordController:UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
