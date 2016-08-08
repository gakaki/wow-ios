import ObjectMapper

//public class ForceToStringTransform {
//
//    func transformFromJSON(value: AnyObject?) -> Object?{
//        return value as! String
//    }
//    func transformToJSON(value: Object?) -> JSON?{
//        turn 
//    }
//}


class WOWFoundProductModel: WOWBaseModel,Mappable{
    var productId               :   Int?
    var productName             :   String?
    var productImg              :   String?
    
    var sellPrice               :   Double?
    var originalPrice           :   Float?

    var detailDescription       :   String?
    var pageModuleType          :   Int?

    func get_formted_price() -> String {
        return "¥\(self.sellPrice!)"
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        productId                  <- map["productId"]
        productName                <- map["productName"]
        productImg                 <- map["productImg"]
        sellPrice                  <- map["sellPrice"]
        originalPrice              <- map["originalPrice"]
        detailDescription          <- map["detailDescription"]
        pageModuleType             <- map["pageModuleType"]
    }
}


