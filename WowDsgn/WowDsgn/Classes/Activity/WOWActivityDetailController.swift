//
//  WOWActivityDetailController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/18.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
import WebKit
class WOWActivityDetailController: WOWBaseViewController {
    var url:String?
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//MARK:Private Method
    override func setUI() {
        let webview = WKWebView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        webview.UIDelegate = self
        webview.navigationDelegate = self
        //FIXME:要替换
        let url = NSURL(string:self.url ?? "")
        //创建请求
        let request = NSURLRequest(URL: url!)
        //加载请求
        webview.loadRequest(request)
        //添加wkwebview
        self.view.addSubview(webview)

    }
}


extension WOWActivityDetailController:WKUIDelegate,WKNavigationDelegate{
    //开始加载
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        WOWHud.showLoading()
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        WOWHud.showMsg("加载失败")
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        WOWHud.dismiss()
        navigationItem.title = webView.title
    }
    
    
}

