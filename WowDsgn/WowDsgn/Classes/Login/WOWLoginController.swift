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
        let vc = UIStoryboard.initialViewController("Login", identifier:String(WOWMsgCodeController)) as! WOWMsgCodeController
        vc.entrance  = .ForgetPasswordHome
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func login(sender: UIButton) {
        DLog("登录")
    }
    
    //MARK:Lazy
    
    //MARK:Delegate
    
}
