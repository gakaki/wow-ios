import UIKit
import SafariServices
import JLRouter

public class JLRouterRule {
    
    public class func replace_domain_name(_ url: URL? ) -> URL {
        let m_domain        = "m.wowdsgn.com/"
        let m_domain_beta   = "m.intra.wowdsgn.com/"
        
        if let url_str = url?.absoluteString {
            let url = url_str.replacingOccurrences(of: m_domain, with: "", options: .literal, range: nil).replacingOccurrences(of: m_domain_beta, with: "", options: .literal, range: nil)
            return URL( string:url )!
        }
        
        return URL(string:"")!
    }
    
    public class func handle_open_url( url:URL ) -> Bool {
        
        let url_full_path = url.absoluteString
        
        //校验url对应的 host + path 是否为被注册的 key
        if FNUrlRoute.canOpen(url: url_full_path){
            FN.open(url:url_full_path)
            return true
        }else{
            print("该url 未能被打开 \(url) ")
            return false
        }
    }
    public class func router_init() {
        
        FNUrlRoute.initUrlRoute(dictionary: ["m.wowdsgn.com/main": RouterModuleMain.self,
                                             "m.wowdsgn.com/item": RouterModuleProduct.self,
                                             "m.wowdsgn.com/contenttopic": RouterModuleContenTopic.self,          //商品详情页(产品详情)
            "m.wowdsgn.com/producttopic": RouterModuleProductTopic.self,          // 商品列表详情页(系列品)
            "m.wowdsgn.com/brand": RouterModuleBrand.self,                   //品牌详情页
            "m.wowdsgn.com/designer": RouterModuleDesigner.self,             //设计师详情页
            "m.wowdsgn.com/coupon": RouterModuleCoupon.self,                 //优惠券列表
            "m.wowdsgn.com/order/list": RouterModuleOrderList.self,              //订单列表
            "m.wowdsgn.com/order": RouterModuleOrder.self,                  //订单详情
            "m.wowdsgn.com/category": RouterModuleCategory.self,               //分类详情页
            "m.wowdsgn.com/h5": RouterModuleH5.self                     //APP内H5页
            ])
        
        
        FNUrlRoute.setHandleOverBlock { (url, modal, params) in
            print("\(url),\(modal),\(params)")
            //            let safari = SFSafariViewController.init(url: URL.init(string: url!)!)
            //            let topViewController = FNUtil.currentTopViewController()
            //            if (topViewController.navigationController != nil) && !modal! {
            //                let navigation = topViewController.navigationController
            //                navigation?.pushViewController(safari, animated: true)
            //            }
            //            else {
            //                topViewController.present(safari, animated: true, completion: nil)
            //            }
        }
        
        //        //校验url对应的 host + path 是否为被注册的 key
        //        let url = "wowdsgn://m.wowdsgn.com/item?id=1275"
        //        if FNUrlRoute.canOpen(url: url){
        //            FN.open(url:url)
        //        }
        
        
    }
}
