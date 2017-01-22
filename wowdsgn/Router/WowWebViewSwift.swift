import UIKit
import WebKit
import WebViewBridge_Swift
import JLRoutes

public class WOWWebViewController: WOWBaseViewController , WKUIDelegate, WKNavigationDelegate {
    
    public var bridge:ZHWebViewBridge!
    @IBOutlet weak var goBackBtn: UIButton!
    @IBOutlet weak var goFormatBtn: UIButton!
    @IBOutlet weak var reloadBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    fileprivate var shareProductImage:UIImage? //供分享使用
    lazy var placeImageView:UIImageView={  //供分享使用
        let image = UIImageView()
        return image
    }()
    public let webView: WKWebView = {
        let webConfiguration    = WKWebViewConfiguration()
        let w = WKWebView(frame: .zero, configuration: webConfiguration)
        return w
    }()
    
    public var url = ""
    var shareTitle = "尖叫设计"
    var shareDesc = "生活即风格！"
    
    
    //MARK: -- delegate
    public func webView(_: WKWebView, decidePolicyFor: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    {
        
//        if decidePolicyFor.navigationType == .linkActivated {
        
            print("webView:\(webView) decidePolicyForNavigationAction:\(decidePolicyFor) decisionHandler:\(decisionHandler)")
        can()
            if let url = decidePolicyFor.request.url {
                print(url.absoluteString)
                
//                JLRoutes.global().routeURL(url)
                JLRouterRule.handle_open_url(url: url)
//                FN.open(url: url.absoluteString)
            }

//        }
        decisionHandler(.allow)
        

    }
    public func webView(_: WKWebView, decidePolicyFor: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void)
    {
        can()
        decisionHandler(.allow)
      

     }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
        can()
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
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress", context: nil)
        removeObservers()

    }

    fileprivate func addObserver(){
        
        NotificationCenter.default.addObserver(self, selector:#selector(updateBageCount), name:NSNotification.Name(rawValue: WOWUpdateCarBadgeNotificationKey), object:nil)
        
    }
    fileprivate func removeObservers() {
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: WOWUpdateCarBadgeNotificationKey), object: nil)
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        //    专题详情
        //    品牌专题
        //    产品详情
        //    优惠券
        
        navigationItem.title = "尖叫设计"
        configBuyBarItem()
        addObserver()
        webView.frame       = CGRect(x: 0, y: 0, width: MGScreenWidth, height: MGScreenHeight - 114)
        view.insertSubview(webView, belowSubview: progressView)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.navigationDelegate  = self
       
        bridge = ZHWebViewBridge.bridge(webView)
//        bridge_router()
        can()
        var url_final   = (url ?? "")
        if url_final.length > 0 {
            url_final   = "\(url_final)?platform=ios&wowdsgn=true"
        }
        let myURL       = URL(string: url_final ?? "")
        let myRequest   = URLRequest(url: myURL!)
        webView.load(myRequest)
        //获取H5信息
        requestH5()

    }
    

    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = CGRect(x: 0, y: 0, width: MGScreenWidth, height: MGScreenHeight - 114)
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
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    //MARK: -- Net 
    func requestH5() {
//        WOWHud.showLoadingSV()
        WOWNetManager.sharedManager.requestWithTarget(.api_H5Share(h5Url: url), successClosure: {[weak self] (result, code) in
            if let strongSelf = self {
                let json = JSON(result)
                strongSelf.shareTitle = json["h5Title"].string ?? ""
                strongSelf.shareDesc = json["h5Desc"].string ?? ""
                let shareImg = json["h5ImgUrl"].string ?? ""
                //加载分享图片
                strongSelf.placeImageView.yy_setImage(
                    with: URL(string:shareImg ),
                    placeholder: nil,
                    options: [YYWebImageOptions.progressiveBlur , YYWebImageOptions.setImageWithFadeAnimation],
                    completion: { [weak self] (img, url, from_type, image_stage,err ) in
                        if let strongSelf = self{
                            strongSelf.shareProductImage = img
                            
                            
                        }
                        
                        
                })
                

            }
            
        }) { (errorMsg) in
        }

    }
    
    //MARMK: -- Action
    @IBAction func goBackClick(_ sender: UIButton) {
        // 获取webView当前加载的页面的数量，可以判断是否在首页，解决无法返回的问题
        webView.goBack()
       
    }
    
    @IBAction func goFormatClick(_ sender: UIButton) {
        webView.goForward()
       
    }
    
    @IBAction func reloadClick(_ sender: UIButton) {
        webView.reload()
       
        
    }
    
    @IBAction func shareClick(_ sender: UIButton) {
        //加载成功后弹出分享按钮
        WOWShareManager.shareUrl(shareTitle, shareText: shareDesc, url: url, shareImage: shareProductImage ?? UIImage(named: "me_logo")!)
        
     
    }
    
    //MARK: - method
    func can() {
        if webView.canGoBack {
            goBackBtn.setImage(UIImage.init(named: "back1"), for: .normal)
        }else {
            goBackBtn.setImage(UIImage.init(named: "back2"), for: .normal)

        }
        
        if webView.canGoForward {
            goFormatBtn.setImage(UIImage.init(named: "forward1"), for: .normal)
        }else {
            goFormatBtn.setImage(UIImage.init(named: "forward2"), for: .normal)
            
        }
        
    }
   
}



