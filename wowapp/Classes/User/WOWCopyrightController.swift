//
//  WOWCopyrightController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/18.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
import WebKit
class WOWCopyrightController: WOWBaseViewController {
    
    @IBOutlet weak var webview: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
//MARK:Private Method
    override func setUI() {
        super.setUI()
        navigationItem.title = "用户协议"

        let path = Bundle.main.path(forResource: "wowprotocol", ofType:"html")
        let url = URL(fileURLWithPath: path!)
        //创建请求
        let request = URLRequest(url: url)
        //加载请求
        webview.loadRequest(request)
        //添加wkwebview
        self.view.addSubview(webview)
    }
    
    
}

