import ObjectMapper


class WOWFoundProductModel: WOWBaseModel,Mappable{
    var productId               :   Int?
    var productName             :   String?
    var productImg              :   String?
    
    var sellPrice               :   Int?
    var originalPrice           :   Int?

    var detailDescription       :   String?
    var pageModuleType          :   Int?

    
    func get_formted_sell_price() -> String {
        if let p = sellPrice{
            return "¥\(Int(p))"
        }else{
            return "¥ 0"
        }
    }
    func get_formted_original_price() -> String {
        if let p = originalPrice{
            return "¥\(Int(p))"
        }else{
            return "¥ 0"
        }
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


