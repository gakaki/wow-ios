//
//  WOWInviteController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/5/30.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWInviteController: WOWBaseViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func setUI() {
        super.setUI()
        self.navigationItem.title = "邀请好友"
    }
}
