//
//  WOWRegistProtocolController.swift
//  Wow
//
//  Created by 小黑 on 16/4/10.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit


class WOWRegistProtocolController: WOWBaseViewController {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var agreeButton: UIButton!
    var agreeAction:WOWActionClosure?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "尖叫用户使用协议"
        let path = Bundle.main.path(forResource: "wowprotocol", ofType:"html")
        let url = URL(fileURLWithPath: path!)
        //创建请求
        let request = URLRequest(url: url)
        //加载请求
        webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func agreeButtonClick(_ sender: UIButton) {
        if let action = self.agreeAction {
            action()
        }
        navigationController?.popViewController(animated: true)
    }
    

}
