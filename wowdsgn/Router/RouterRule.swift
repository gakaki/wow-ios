import UIKit

public class RouterModuleMain : FNUrlRouteDelegate{
    required public init(params: [String: AnyObject]?) {
        print(params)
//        FNUtil.currentTopViewController().present(alert, animated: true, completion: nil)
        
//        1 首页
//        main?page=main
//        main?page=shopping
//        main?page=hotstyle
//        main?page=favorite
//        main?page=me
        
        
    }
}
public class RouterModuleProduct : FNUrlRouteDelegate{
    required public init(params: [String: AnyObject]?) {
        print(params)
        //        FNUtil.currentTopViewController().present(alert, animated: true, completion: nil)
    }
}
public class RouterModuleContenTopic : FNUrlRouteDelegate{
    required public init(params: [String: AnyObject]?) {
        print(params)
        //        FNUtil.currentTopViewController().present(alert, animated: true, completion: nil)
    }
}
public class RouterModuleProductTopic : FNUrlRouteDelegate{
    required public init(params: [String: AnyObject]?) {
        print(params)
        //        FNUtil.currentTopViewController().present(alert, animated: true, completion: nil)
    }
}
public class RouterModuleBrand : FNUrlRouteDelegate{
    required public init(params: [String: AnyObject]?) {
        print(params)
        //        FNUtil.currentTopViewController().present(alert, animated: true, completion: nil)
    }
}
public class RouterModuleDesigner : FNUrlRouteDelegate{
    required public init(params: [String: AnyObject]?) {
        print(params)
        //        FNUtil.currentTopViewController().present(alert, animated: true, completion: nil)
    }
}
public class RouterModuleCoupon : FNUrlRouteDelegate{
    required public init(params: [String: AnyObject]?) {
        print(params)
        //        FNUtil.currentTopViewController().present(alert, animated: true, completion: nil)
    }
}

public class RouterModuleOrderList : FNUrlRouteDelegate{
    required public init(params: [String: AnyObject]?) {
        print(params)
        //        FNUtil.currentTopViewContro
    }
}
public class RouterModuleOrder : FNUrlRouteDelegate{
    required public init(params: [String: AnyObject]?) {
        print(params)
        //        FNUtil.currentTopViewController().present(alert, animated: true, completion: nil)
    }
}
public class RouterModuleCategory : FNUrlRouteDelegate{
    required public init(params: [String: AnyObject]?) {
        print(params)
        //        FNUtil.currentTopViewController().present(alert, animated: true, completion: nil)
    }
}
public class RouterModuleH5 : FNUrlRouteDelegate{
    required public init(params: [String: AnyObject]?) {
        print(params)
        //        FNUtil.currentTopViewController().present(alert, animated: true, completion: nil)
    }
}

class RouterRule {
    
    public class func router_init() {

        FNUrlRoute.initUrlRoute(dictionary: ["main": RouterModuleMain.self,
                                             "product": RouterModuleProduct.self,
                                             "contenttopic": RouterModuleContenTopic.self,          //product?id=id 商品详情页(产品详情)
                                             "producttopic": RouterModuleProductTopic.self,          // 商品列表详情页(系列品)
                                             "brand": RouterModuleBrand.self,                   //品牌详情页
                                             "designer": RouterModuleDesigner.self,             //设计师详情页
                                             "coupon": RouterModuleCoupon.self,                 //优惠券列表
                                             "order/list": RouterModuleOrderList.self,              //订单列表
                                             "order": RouterModuleOrder.self,                  //订单详情
                                             "category": RouterModuleCategory.self,               //分类详情页
                                             "h5": RouterModuleH5.self                     //APP内H5页
                                ])
   
        
    }
}
