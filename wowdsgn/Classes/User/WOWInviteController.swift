//
//  WOWInviteController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/5/30.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWInviteController: WOWBaseViewController,UIWebViewDelegate{
    var webUrl = "http://wx.wowdsgn.com/invitation/app.html"
    var shareUrl = "http://wx.wowdsgn.com/invitation/index.html?userName="
    var shareTitle :String?
    var shareDesc  :String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bannerImageView: UIImageView!
//    @IBOutlet weak var webView: UIWebView!
//    
//    
//    
//    private var progressView: WebViewProgressView!
//    private var progressProxy: WebViewProgress!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        request()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController!.navigationBar.addSubview(progressView)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        progressView.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func inviteButtonClick(_ sender: AnyObject) {
        WOWShareManager.share(shareTitle, shareText:shareDesc, url:shareUrl + WOWUserManager.userName, shareImage:UIImage(named: "testinvitation")!)
    }
    
    override func setUI() {
        super.setUI()
        self.navigationItem.title = "邀请好友"
//        configWeb()
    }
    
//    private func configWeb(){
//        progressProxy = WebViewProgress()
//        webView.delegate = progressProxy
//        progressProxy.webViewProxyDelegate = self
//        progressProxy.progressDelegate = self
//        let progressBarHeight: CGFloat = 2.0
//        let navigationBarBounds = self.navigationController!.navigationBar.bounds
//        let barFrame = CGRect(x: 0, y: navigationBarBounds.size.height - progressBarHeight, width: navigationBarBounds.width, height: progressBarHeight)
//        progressView = WebViewProgressView(frame: barFrame)
//        progressView.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin]
//    }
 
//    private func loadWeb(){
//        let url = NSURL(string: webUrl)!
//        let req = NSURLRequest(URL: url)
//        webView.loadRequest(req)
//    }
    
    //MARK:Network
//    override func request() {
//        super.request()
//        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Invite, successClosure: {[weak self](result, code) in
//            if let strongSelf = self{
//                let json = JSON(result)
//                strongSelf.shareTitle  = json["title"].string ?? ""
//                strongSelf.shareDesc   = json["desc"].string ?? ""
//                strongSelf.webUrl      = json["url"].string ?? ""
//                strongSelf.shareUrl    = json["shareurl"].string ?? ""
//                strongSelf.loadWeb()
//            }
//        }) { (errorMsg) in
//                
//        }
//    }
    
//    // MARK: - WebViewProgressDelegate
//    func webViewProgress(webViewProgress: WebViewProgress, updateProgress progress: Float) {
//        progressView.setProgress(progress, animated: true)
//    }
//    
//    
//    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
//        if ((request.URL?.absoluteString ?? "") == "http://wx.wowdsgn.com/invitation/app.html") {
//            return true
//        }else{
//            share()
//            return false
//        }
//    }
    
//    private func share(){
//        WOWShareManager.share(shareTitle, shareText:shareDesc, url:shareUrl + WOWUserManager.userName, shareImage:UIImage(named: "me_logo")!)
//    }
    
}
