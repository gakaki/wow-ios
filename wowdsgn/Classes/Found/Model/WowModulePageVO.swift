import ObjectMapper


class WowModulePageVO:Mappable
{
    var moduleID:Int?
    var moduleType:Int?
    var contentTmp:AnyObject?
    
    var moduleContentArr:[WowModulePageItemVO]?
    var moduleContentItem:WowModulePageItemVO?
    var moduleClassName:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        moduleType              <- map["moduleType"]
        contentTmp              <- map["moduleContent"]
        moduleID                <- map["moduleId"]
    }
    

}

//超级集合类方便使用
class WowModulePageItemVO:Mappable
{
    // 301 302
    var categoryId:             Int?
    var categoryName:           String?
    var categoryBgImg:          String?
    
    // 201
    var bannerImgSrc:           String?
    var bannerLinkType:         Int?
    var bannerLinkTargetId:     Int?

    // 501
    var productId               :   Int?
    var productName             :   String?
    var productImg              :   String?
    var sellPrice               :   Double?
    var originalPrice           :   Double?
    var detailDescription       :   String?
    var favorite                :   Bool?
    var pageModuleType          :   Int?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        //201
        bannerImgSrc            <- map["bannerImgSrc"]
        bannerLinkType          <- map["bannerLinkType"]
        bannerLinkTargetId      <- map["bannerLinkTargetId"]
        
        //301
        categoryId              <- map["categoryId"]
        categoryName            <- map["categoryName"]
        categoryBgImg           <- map["categoryBgImg"]
        
        productId               <- map["productId"]
        productName             <- map["productName"]
        sellPrice               <- map["sellPrice"]
        productImg              <- map["productImg"]
        
        //501
        productId               <- map["productId"]
        productName             <- map["productName"]
        productImg              <- map["productImg"]
        sellPrice               <- map["sellPrice"]
        originalPrice           <- map["originalPrice"]
        detailDescription       <- map["detailDescription"]
        favorite                <- map["favorite"]
    }
    
    func get_formted_sell_price() -> String {
        return WOWCalPrice.calTotalPrice([sellPrice ?? 0],counts:[1])
        
    }
    func get_formted_original_price() -> String {
        return WOWCalPrice.calTotalPrice([originalPrice ?? 0],counts:[1])
    }
}

