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
        VCRedirect.toCouponVC()
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
