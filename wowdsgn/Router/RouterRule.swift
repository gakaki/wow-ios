import UIKit
import wow3rd
import SafariServices
public class RouterRule {
    
    public class func router_init() {

        FNUrlRoute.initUrlRoute(dictionary: ["m.wowdsgn.com/main": RouterModuleMain.self,
                                             "m.wowdsgn.com/product": RouterModuleProduct.self,
                                             "m.wowdsgn.com/contenttopic": RouterModuleContenTopic.self,          //product?id=id 商品详情页(产品详情)
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

        
        
        
    }
}
