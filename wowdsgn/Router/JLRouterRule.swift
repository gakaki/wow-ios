import UIKit
import SafariServices
import JLRoutes

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
      
        if let host = url.host {
            
            if (host == "m.wowdsgn.com" || host == "m.intra.wowdsgn.com" ) {
                //进行我们需要的处理
                let url_replaced = replace_domain_name(url)
                
                if JLRoutes.canRouteURL(url_replaced) {
                    return JLRoutes.global().routeURL(url_replaced)
                }else{
                    print("该url 未能被打开 \(url_replaced.absoluteString) ")
                    return false
                }
            }
            else {
                print("该url非指定域名",host)
                return false
            }
        }else{
            //没有url
            print("无url 无host",url.absoluteString)
            return false
        }

        
    }
    
    
//    "/main"            //app 首页
//    "/item"            //产品详情页
//    "/contenttopic"    //商品详情页(产品详情)
//    "/producttopic"    //商品列表详情页(系列品)
//    "/brand"           //品牌详情页
//    "/designer"        //设计师详情页
//    "/coupon"          //优惠券列表
//    "/order/list"      //订单列表
//    "/order"           //订单详情
//    "/category"        //分类详情页
//    "/h5"              //APP内H5页
    
    public class func router_init() {
        
        JLRoutes.setVerboseLoggingEnabled(true)
        
        // 跳转首页
        JLRoutes.global().add(["/","/main/:page"]) { (params) -> Bool in
            print(params)
            
            //        FNUtil.currentTopViewController().present(alert, animated: true, completion: nil)
            let page = params["page"] as? String
            
            var rootIndexVC = 0
            switch page ?? ""{
                case "main":
                    rootIndexVC = 0
                case "shopping":
                    rootIndexVC = 1
                case "hotstyle":
                    rootIndexVC = 2
                case "favorite":
                    rootIndexVC = 3
                case "me":
                    rootIndexVC = 4
                default:
                    rootIndexVC = 0 //啥都没有去首页
                    break
            }
            VCRedirect.toHomeIndex(index: rootIndexVC)
            return true
        }
        
        // 跳转产品
        JLRoutes.global().add(["/item","/item/:id"]) { (params) -> Bool in
            print(params)
            let productId = params["id"] as? String
            VCRedirect.toVCProduct(productId?.toInt())
            print(params)
            return true
        }

        // 跳转商品详情页(产品详情)
        JLRoutes.global().add(["/contenttopic","/contenttopic/:id","/topic/content/:id"]) { (params) -> Bool in
            print(params)
            let id              = params["id"] as? String
            let toPicId         = id?.toInt() ?? 0
            VCRedirect.toToPidDetail(topicId: toPicId)
            return true
        }
        
        // 跳转商品列表详情页(系列品)
        JLRoutes.global().add(["/producttopic","/producttopic/:id","/topic/product/:id"]) { (params) -> Bool in
            print(params)
            let id              = params["id"] as? String
            let toPicId         = id?.toInt() ?? 0
            VCRedirect.toTopicList(topicId: toPicId)
            return true
        }
        
        // 跳转品牌详情页
        JLRoutes.global().add(["/brand","/brand/:id"]) { (params) -> Bool in
            print(params)
            if let id = params["id"] as? String {
                VCRedirect.toBrand(brand_id: id.toInt())
            }
            return true
        }
        
        // 跳转设计师详情页
        JLRoutes.global().add(["/designer","/designer/:id"]) { (params) -> Bool in
            print(params)
            if let id = params["id"] as? String {
                VCRedirect.toDesigner(designerId: id.toInt())
            }
            return true
        }

        // 跳转优惠券列表
        JLRoutes.global().addRoute("/coupon") { (params) -> Bool in
            print(params)
            VCRedirect.toCouponVC()

            return true
        }
        
        // 跳转订单列表
        JLRoutes.global().addRoute("/order/list") { (params) -> Bool in
            print(params)
            VCRedirect.toOrderList()
            return true
        }
        
        
        // 跳转订单详情
        JLRoutes.global().addRoute("/order") { (params) -> Bool in
            print(params)
            //        FNUtil.currentTopViewController().present(alert, animated: true, completion: nil)
            return true
        }
        
        // 跳转分类详情页
        JLRoutes.global().add(["/category","/category/:id"]) { (params) -> Bool in
            
            let categoryId = params["id"] as? String
            VCRedirect.toVCCategory(categoryId?.toInt())
            print(params)
            return true
        }
        
        // 跳转APP内H5页
        JLRoutes.global().add(["/h5","/h5/:url"]) { (params) -> Bool in
            DLog(params)
            let url = params["url"] as? String
            VCRedirect.toVCH5(url)
            return true
        }
        
        // 跳转产品组
        JLRoutes.global().add(["/productgroup","/productgroup/:id"]) { (params) -> Bool in
            if let id = params["id"] as? String {
                VCRedirect.goToProductGroup(id.toInt() ?? 0)
            }
            return true
        }
        
        //领券
        JLRoutes.global().addRoute("/coupon/obtain/:couponId") { (params) -> Bool in
            print(params)
            if let couponId = params["couponId"] as? String {
                VCRedirect.getCoupon(couponId.toInt() ?? 0)
            }
       
            return true
        }
    }
}
