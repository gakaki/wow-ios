import ObjectMapper


class WOWFoundProductModel: WOWBaseModel,Mappable{
    var productId               :   Int?
    var productName             :   String?
    var productImg              :   String?
    
    var sellPrice               :   Double?
    var originalPrice           :   Double?

    var detailDescription       :   String?
    var pageModuleType          :   Int?

    
    func get_formted_sell_price() -> String {
        return WOWCalPrice.calTotalPrice([sellPrice ?? 0],counts:[1])
        
    }
    func get_formted_original_price() -> String {

        return WOWCalPrice.calTotalPrice([originalPrice ?? 0],counts:[1])

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


