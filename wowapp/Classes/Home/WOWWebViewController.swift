//
//  WOWWebViewController.swift
//  wowapp
//
//  Created by 陈旭 on 16/9/19.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWWebViewController: WOWBaseViewController {
    @IBOutlet weak var webView: UIWebView!
    var           bannerUrl   :   String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = ""

        let url = NSURL(string: bannerUrl ?? "")!
        
        // 2.建立网络请求
        let request = NSURLRequest(URL: url)
        
        // 3.加载网络请求
        webView.loadRequest(request)
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
}
