import UIKit
import WebKit
import WebViewBridge_Swift
import wow3rd

public class WOWWebViewController: WOWBaseViewController , WKUIDelegate, WKNavigationDelegate {
    
    public var bridge:ZHWebViewBridge!

    public let webView: WKWebView = {
        let webConfiguration    = WKWebViewConfiguration()
        let w = WKWebView(frame: .zero, configuration: webConfiguration)
        return w
    }()
    
    public var url = ""
    
    
    public func webView(_: WKWebView, decidePolicyFor: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    {
        
        if decidePolicyFor.navigationType == .linkActivated {
            
            print("webView:\(webView) decidePolicyForNavigationAction:\(decidePolicyFor) decisionHandler:\(decisionHandler)")
            if let url = decidePolicyFor.request.url {
                print(url.absoluteString)
                FN.open(url: url.absoluteString)
            }

        }
        decisionHandler(.allow)
        

    }
    public func webView(_: WKWebView, decidePolicyFor: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void)
    {
        decisionHandler(.allow)

     }

  
    public func bridge_router(){
        
        bridge.registerHandler("Wow.router.product_detail") { (args:[Any]) -> (Bool, [Any]?) in
            if let product_id = args.first as? Int , args.count == 1 {
                
                return (true, nil)
            }
            return (false, nil)
        }
        
        bridge.registerHandler("Wow.router.coupon_me") { (args:[Any]) -> (Bool, [Any]?) in
           //跳转coupon  这里应该上router方案哦 router和vc的组合
//           self.toCouponMe()
           return (true, nil)
        }
        
        bridge.registerHandler("Wow.router.product_detail") { (args:[Any]) -> (Bool, [Any]?) in
            if let product_id = args.first as? Int , args.count == 1 {
                print(product_id)
                return (true, nil)
            }
            return (false, nil)
        }
        bridge.registerHandler("Wow.router.product_detail") { (args:[Any]) -> (Bool, [Any]?) in
            if let product_id = args.first as? Int , args.count == 1 {
                print(product_id)
                return (true, nil)
            }
            return (false, nil)
        }
        bridge.registerHandler("Wow.router.product_detail") { (args:[Any]) -> (Bool, [Any]?) in
            if let product_id = args.first as? Int , args.count == 1 {
                print(product_id)
                return (true, nil)
            }
            return (false, nil)
        }
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        //    专题详情
        //    品牌专题
        //    产品详情
        //    优惠券
        
        navigationItem.title = "尖叫设计"
        
        webView.frame       = self.view.bounds
        view.addSubview(webView)
        webView.navigationDelegate  = self
        
        bridge = ZHWebViewBridge.bridge(webView)
        bridge_router()
        
        var url_final   = (url ?? "")
        if url_final.length > 0 {
//            url_final   = "http://10.0.60.129:8080/links.html"
            url_final   = "\(url_final)?platform=ios&wowdsgn=true"
        }
        let myURL       = URL(string: url_final ?? "")
        let myRequest   = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = self.view.bounds
    }

    
    public func viewImageAtIndex(_ index:Int) {
        let alert = UIAlertController.init(title: "ViewImage atIndex \(index)", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { [weak self](_:UIAlertAction) in
            self?.dismiss(animated: false, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
   
    public func old_args(){
        
        bridge.registerHandler("Image.updatePlaceHolder") { (args:[Any]) -> (Bool, [Any]?) in
            return (true, ["place_holder.png"])
        }
        bridge.registerHandler("Image.ViewImage") { [weak self](args:[Any]) -> (Bool, [Any]?) in
            if let index = args.first as? Int , args.count == 1 {
                self?.viewImageAtIndex(index)
                return (true, nil)
            }
            return (false, nil)
        }
        bridge.registerHandler("Image.DownloadImage") { [weak self](args:[Any]) -> (Bool, [Any]?) in
            if let index = args.first as? Int , args.count == 1 {
                return (true, nil)
            }
            return (false, nil)
        }
        bridge.registerHandler("Time.GetCurrentTime") { [weak self](args:[Any]) -> (Bool, [Any]?) in
            self?.bridge.callJsHandler("Time.updateTime", args: [Date.init().description])
            return (true, nil)
        }
        bridge.registerHandler("Device.GetAppVersion") { [weak self](args:[Any]) -> (Bool, [Any]?) in
            self?.bridge.callJsHandler("Device.updateAppVersion", args: [Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String], callback: { (data:Any?) in
                if let data = data as? String {
                    let alert = UIAlertController.init(title: "Device.updateAppVersion", message: data, preferredStyle: .alert)
                    alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { [weak self](_:UIAlertAction) in
                        self?.dismiss(animated: false, completion: nil)
                    }))
                    self?.present(alert, animated: true, completion: nil)
                }
            })
            return (true, nil)
        }
    }
   
}



