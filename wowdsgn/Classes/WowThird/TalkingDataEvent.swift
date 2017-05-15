

import UIKit

public extension TalkingData {
    public static func e(_ structEvent:StructDataEvent , _ params: [String : Any] ){
        let event_name = String(describing: structEvent)
        DLog(event_name)
        TalkingData.trackEvent(event_name, label: "AppStore", parameters: params)
    }
    
}

public enum StructDataEvent  {
    
    case ViewItem                   //查看商品
    case Login                     //登入
    case AddItemToShoppingCart     //添加商品至购物车
    case Regist                    //注册
    case PlaceOrder                //提交订单
    case PaySuccess                //支付成功
    
    case Banner                  //（首页）轮播模块
    case Landscape_Banner_Group     //（首页）横向banner组模块
    case Portrait_Banner_Group        //（首页）纵向banner组模块
    case Landscape_Product_Group        //（首页）横向产品组模块
    case Portrait_Product_Group          //（首页）纵向产品组模块
    case Hot_Category_Banner            //（首页）热门分类模块
    case Recommend_Brand                  //（首页）品牌推荐模块
    case Category_Banner                //（分类）分类banner模块点击
    
}



