
import UIKit

class WOWBuyCarRequestVo: WOWBaseModel,Mappable {
    
    var totalPrice                          : NSNumber?
    var shoppingCartResult                  : [WOWCarProductModel]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
             
    }
    
}
