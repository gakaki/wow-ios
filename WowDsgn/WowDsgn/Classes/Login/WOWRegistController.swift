//
//  WOWRegistController.swift
//  Wow
//
//  Created by 小黑 on 16/4/10.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWRegistController: WOWBaseViewController {

    @IBOutlet weak var countryCodeView: UIView!

    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var tipsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:Life
    
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
        self.navigationItem.leftBarButtonItems = nil
        makeCustomerImageNavigationItem("closeNav_white", left:true) {[weak self] in
            if let strongSelf = self{
                strongSelf.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    //MARK:Actions
    private func back(){
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func nextClick(sender: UIButton) {
        let vc = UIStoryboard.initialViewController("Login", identifier:String(WOWRegistProtocolController)) as! WOWRegistProtocolController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:Lazy
    
    

   
}

//MARK:Delegate
