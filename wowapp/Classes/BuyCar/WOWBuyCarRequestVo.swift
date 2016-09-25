
import UIKit

class WOWBuyCarRequestVo: WOWBaseModel,Mappable {
    
    var shippingInfoId                      : Int = 0
    var orderSource                         : Int =  2
    var orderAmount                         : String = ""
    var remark                              : String = ""
    var tipsText                            : String = ""
    var endUserCouponId                     : Int = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
             
    }
    
}
