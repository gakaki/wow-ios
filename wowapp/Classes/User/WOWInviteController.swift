//
//  WOWInviteController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/5/30.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWInviteController: WOWBaseViewController,WebViewProgressDelegate,UIWebViewDelegate{
    let webUrl = "http://wx.wowdsgn.com/invitation/app.html"
    @IBOutlet weak var webView: UIWebView!
    
    private var progressView: WebViewProgressView!
    private var progressProxy: WebViewProgress!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.addSubview(progressView)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        progressView.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setUI() {
        super.setUI()
        self.navigationItem.title = "邀请好友"
        configWeb()
    }
    
    private func configWeb(){
        progressProxy = WebViewProgress()
        webView.delegate = progressProxy
        progressProxy.webViewProxyDelegate = self
        progressProxy.progressDelegate = self
        let progressBarHeight: CGFloat = 2.0
        let navigationBarBounds = self.navigationController!.navigationBar.bounds
        let barFrame = CGRect(x: 0, y: navigationBarBounds.size.height - progressBarHeight, width: navigationBarBounds.width, height: progressBarHeight)
        progressView = WebViewProgressView(frame: barFrame)
        progressView.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin]
        
        
        let url = NSURL(string: webUrl)!
        let req = NSURLRequest(URL: url)
        webView.loadRequest(req)
    }
    
    
    // MARK: - WebViewProgressDelegate
    func webViewProgress(webViewProgress: WebViewProgress, updateProgress progress: Float) {
        progressView.setProgress(progress, animated: true)
    }
    
}
