//
////  WowWebView.swift
////  Pods
////
////  Created by g on 2016/11/3.
////
////
//
//import UIKit
//import WebKit
//import WebViewJavascriptBridge
//
//public class WowWebView  : UIViewController , WKUIDelegate ,    WKNavigationDelegate{
//    
//    public var bridge: WKWebViewJavascriptBridge? = nil
//    public var webView: WKWebView!
//    
//    override public func loadView() {
//        let webConfiguration = WKWebViewConfiguration()
//        webView = WKWebView(frame: .zero, configuration: webConfiguration)
//        webView.uiDelegate = self
//        webView.navigationDelegate  = self
//
//        view = webView
//    }
//    
//    public override func viewDidLoad() {
//        if bridge != nil {
//            return
//        }
//        WKWebViewJavascriptBridge.enableLogging()
//
//        if let b = WKWebViewJavascriptBridge.init(for: webView){
//            b.setWebViewDelegate(self)
//            b.registerHandler("testObjcCallback", handler: { (data, responseCallBack) in
//                print("testObjcCallback called: \(data)")
//                if let c = responseCallBack {
//                    c("Response from testObjcCallback")
//                }
//            })
//            
//            b.callHandler("testJavascriptHandler", data: ["foo":"before ready"])
//        }
//        renderButtons(webView)
//        loadExamplePage(webView)
//    }
//    
//    public override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        
////        [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
////            NSLog(@"testObjcCallback called: %@", data);
////            responseCallback(@"Response from testObjcCallback");
////        }];
////        
////        [_bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
////        
////        [self renderButtons:webView];
////        [self loadExamplePage:webView];
//      
//
//    }
//    public func renderButtons(_ webView:WKWebView){
//        var font = UIFont(name: "HelveticaNeue", size: 12.0)
//        var callbackButton = UIButton(type: .roundedRect)
//        callbackButton.setTitle("Call handler", for: .normal)
//        callbackButton.addTarget(self, action: #selector(self.callHandler), for: .touchUpInside)
//        self.view.insertSubview(callbackButton, aboveSubview: webView)
//        callbackButton.frame = CGRect(x: 10, y: 400, width: 100, height: 35)
//        callbackButton.titleLabel!.font = font
//        var reloadButton = UIButton(type: .roundedRect)
//        reloadButton.setTitle("Reload webview", for: .normal)
//        reloadButton.addTarget(webView, action: #selector(webView.reload), for: .touchUpInside)
//        self.view.insertSubview(reloadButton, aboveSubview: webView)
//        reloadButton.frame = CGRect(x: 110, y: 400, width: 100, height: 35)
//        reloadButton.titleLabel!.font = font
//
//    }
//    
//    public func callHandler(_ sender: Any) {
//        var data = ["greetingFromObjC": "Hi there, JS!"]
//        if let b = bridge {
//            b.callHandler("testJavascriptHandler", data: data, responseCallback: { (response) in
//                print("testJavascriptHandler responded: \(response)")
//            })
//        }
//    }
//    public func loadExamplePage(_ webView: WKWebView) {
////        if var htmlPath = Bundle.main.path(forResource: "ExampleApp", ofType: "html") {
////            var appHtml = try! String(contentsOfFile: htmlPath, encoding: String.Encoding.utf8)
////            var baseURL = URL(fileURLWithPath: htmlPath)
////            webView.loadHTMLString(appHtml, baseURL: baseURL)!
////        }
//        let myURL = URL(string: "http://10.0.60.116:8080/index.html")
//        let myRequest = URLRequest(url: myURL!)
//        webView.load(myRequest)
// 
//    }
//    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
//        print("webViewDidStartLoad")
//    }
//
//    public func webView(_ webView:WKWebView, didFinish: WKNavigation!){
//        print("webViewDidFinishLoad");
//    }
//    
//    public func webView(_ webView:WKWebView, didCommit: WKNavigation!){
//        
//    }
//    
//    public func webView(_ webView:WKWebView, didReceiveServerRedirectForProvisionalNavigation: WKNavigation!){
//        
//    }
// 
//    public func webView(_ webView:WKWebView, didFail: WKNavigation!, withError: Error){
//        
//    }
//    
//    public func webView(_ webView:WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error){
//        
//    }
//    
//   
//    public func webViewWebContentProcessDidTerminate(_ webView:WKWebView){
//        
//    }
//    
//    public func webView(_ webView:WKWebView, decidePolicyFor: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void){
//        
//    }
////    public func webView(_ webView:WKWebView, decidePolicyFor: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void){
////        
////    }
//
//    
//    public func webView(_ webView:WKWebView, didReceive: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void){
//        
//    }
////
////    public func webView(_ webView: WebView!, decidePolicyForNavigationAction actionInformation: [AnyHashable : Any]!, request: URLRequest!, frame: WebFrame!, decisionListener listener: WebPolicyDecisionListener!)
////
////    {
////        
////    }
////
////    
//    
//    
//    
//    
//}
