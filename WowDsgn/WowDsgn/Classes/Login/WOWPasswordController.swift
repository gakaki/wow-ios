//
//  WOWPasswordController.swift
//  Wow
//
//  Created by 小黑 on 16/4/10.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWPasswordController: WOWBaseViewController {
    var entrance:MsgCodeEntrance = .RegistCode
    @IBOutlet weak var firstPassLabel: UILabel!
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
        makeBackButton("上一步")
        switch entrance{
            case .RegistCode:
                navigationItem.title = "注册"
            case .ForgetPasswordCode:
                firstPassLabel.text = "新密码"
                navigationItem.title = "重置密码"
            default:
                DLog("")
        }
    }

    
    @IBAction func nextClick(sender: UIButton) {
        DLog("下一步")
    }

}
