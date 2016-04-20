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
        //返回登录界面再登录吧
        navigationController?.popToRootViewControllerAnimated(true)
    }

}
