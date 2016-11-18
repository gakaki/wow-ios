import UIKit

public class RouterModuleMain : FNUrlRouteDelegate{
    required public init(params: [String: AnyObject]?) { // 跳转首页
        print(params)
        //        FNUtil.currentTopViewController().present(alert, animated: true, completion: nil)
        let page = params?["page"] as? String
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
            break
        }
        
        DynamicFun.classFun("VCRedirect", "toHomeIndex" , rootIndexVC)
//        VCRedirect.toHomeIndex(index: rootIndexVC)
    }
}
public class RouterModuleProduct : FNUrlRouteDelegate{
    required public init(params: [String: AnyObject]?) {
        let productId = params?["id"] as? String
        DynamicFun.classFun("VCRedirect", "toVCProduct" , productId?.toInt0())
    }
}
public class RouterModuleContenTopic : FNUrlRouteDelegate{
    required public init(params: [String: AnyObject]?) {
        print(params)
        
        let topicStr = params?["id"] as? String
        let toPicId = topicStr?.toInt0()
//        VCRedirect.toToPidDetail(topicId: toPicId)
        DynamicFun.classFun("VCRedirect", "toToPidDetail" , toPicId)
    }
}
public class RouterModuleProductTopic : FNUrlRouteDelegate{// 跳转商品列表专题
    required public init(params: [String: AnyObject]?) {
//        print(params)
        let topicStr = params?["id"] as? String
        let toPicId = topicStr?.toInt0()
        DynamicFun.classFun("VCRedirect", "toTopicList" ,  toPicId)

    }
}
public class RouterModuleBrand : FNUrlRouteDelegate{
    required public init(params: [String: AnyObject]?) {
        if let id = params?["id"] as? String {
//            VCRedirect.toBrand(brand_id: id.toInt())
            DynamicFun.classFun("VCRedirect", "toBrand" ,  id.toInt0() )

        }
    }
}
public class RouterModuleDesigner : FNUrlRouteDelegate{
    required public init(params: [String: AnyObject]?) {
        if let id = params?["id"] as? String {
            DynamicFun.classFun("VCRedirect", "toDesigner" ,  id.toInt0() )
        }
    }
}
public class RouterModuleCoupon : FNUrlRouteDelegate{
    required public init(params: [String: AnyObject]?) {
        DynamicFun.classFun("VCRedirect", "toCouponVC"  )
    }
}

public class RouterModuleOrderList : FNUrlRouteDelegate{
    required public init(params: [String: AnyObject]?) {
        DynamicFun.classFun("VCRedirect", "toOrderList" )
        //wowdsgn://m.wowdsgn.com/vcredirectr/toorderlist/params1/params2/params3
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
        let categoryId = params?["id"] as? String
        DynamicFun.classFun("VCRedirect", "toVCCategory" ,categoryId?.toInt0())
        print(params)
        //        FNUtil.currentTopViewController().present(alert, animated: true, completion: nil)
    }
}
public class RouterModuleH5 : FNUrlRouteDelegate{
    required public init(params: [String: AnyObject]?) {
        let url = params?["url"] as? String
//        VCRedirect.toVCH5(url)
        DynamicFun.classFun("VCRedirect", "toVCH5" ,url)
        //        FNUtil.currentTopViewController().present(alert, animated: true, completion: nil)
    }
}
