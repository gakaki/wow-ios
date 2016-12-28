

import UIKit

public extension TalkingData {
    public static func e(_ structEvent:StructDataEvent , _ params: [String : Any] ){
        let event_name = String(describing: structEvent)
        print(event_name)
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
    
}



