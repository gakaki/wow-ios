//
//  WOWIntroduceController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/28.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWIntroduceController: WOWBaseViewController {
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func setUI() {
        super.setUI()
        let data = NSData(contentsOfFile:NSBundle.mainBundle().pathForResource("intro", ofType: "gif")!)
        webView.loadData(data!, MIMEType: "image/gif", textEncodingName: "", baseURL: NSURL(string: "")!)
    }
}

extension WOWIntroduceController:UIWebViewDelegate{
    func webViewDidFinishLoad(webView: UIWebView) {
        DLog("结束了")
    }
}






