import UIKit
import WebKit
import WebViewBridge_Swift

public class WowWebViewSwift: UIViewController , WKUIDelegate, WKNavigationDelegate {
    
    public var bridge:ZHWebViewBridge!

    public let webView: WKWebView = {
        let webConfiguration    = WKWebViewConfiguration()
        let w = WKWebView(frame: .zero, configuration: webConfiguration)
        return w
    }()
    
    public let url = "http://10.0.60.116:8080/wow11-11.html"
    
    public func bridge_router(){
        
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
        
        
        webView.frame       = self.view.bounds
        view.addSubview(webView)
        
        bridge = ZHWebViewBridge.bridge(webView)
        bridge_router()
        
        
        let myURL       = URL(string: url)
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


