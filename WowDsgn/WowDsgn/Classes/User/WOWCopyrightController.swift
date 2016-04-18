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
    var navTitle:String = "使用协议"
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
//MARK:Private Method
    override func setUI() {
        super.setUI()
        navigationItem.title = navTitle
        let webview = WKWebView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        webview.UIDelegate = self
        webview.navigationDelegate = self
        //FIXME:要替换
        let url = NSURL(string: "http://www.jianshu.com/users/040395b7230c/latest_articles")
        //创建请求
        let request = NSURLRequest(URL: url!)
        //加载请求
        webview.loadRequest(request)
        //添加wkwebview
        self.view.addSubview(webview)
    }
    
    
}

extension WOWCopyrightController:WKUIDelegate,WKNavigationDelegate{
    //开始加载
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        WOWHud.showLoading()
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        WOWHud.showMsg("加载失败")
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        WOWHud.dismiss()
    }
    
}
