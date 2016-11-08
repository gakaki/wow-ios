import UIKit
import wow3rd

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
        VCRedirect.toHomeIndex(index: rootIndexVC)
        
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
        
        let topicStr = params?["id"] as? String
        let toPicId = topicStr?.toInt() ?? 0
        VCRedirect.toToPidDetail(topicId: toPicId)
        
//        VCRedirect.
        //        FNUtil.currentTopViewController().present(alert, animated: true, completion: nil)
    }
}
public class RouterModuleProductTopic : FNUrlRouteDelegate{// 跳转商品列表专题
    required public init(params: [String: AnyObject]?) {
//        print(params)
        let topicStr = params?["id"] as? String
        let toPicId = topicStr?.toInt() ?? 0
        VCRedirect.toTopicList(topicId: toPicId)
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
        VCRedirect.toCouponVC()
    }
}

public class RouterModuleOrderList : FNUrlRouteDelegate{
    required public init(params: [String: AnyObject]?) {
        VCRedirect.toOrderList()
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
