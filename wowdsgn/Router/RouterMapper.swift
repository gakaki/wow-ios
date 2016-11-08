import UIKit
import wow3rd

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
        let productId = params?["id"] as? String
        VCRedirect.toVCProduct(productId?.toInt())
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
        if let id = params?["id"] as? String {
            VCRedirect.toBrand(brand_id: Int(id))
        }
    }
}
public class RouterModuleDesigner : FNUrlRouteDelegate{
    required public init(params: [String: AnyObject]?) {
        if let id = params?["id"] as? String {
            VCRedirect.toDesigner(designerId:Int(id))
        }
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
        let categoryId = params?["id"] as? String
        VCRedirect.toVCCategory(categoryId?.toInt())
        print(params)
        //        FNUtil.currentTopViewController().present(alert, animated: true, completion: nil)
    }
}
public class RouterModuleH5 : FNUrlRouteDelegate{
    required public init(params: [String: AnyObject]?) {
        let url = params?["url"] as? String
        VCRedirect.toVCH5(url)
        //        FNUtil.currentTopViewController().present(alert, animated: true, completion: nil)
    }
}
