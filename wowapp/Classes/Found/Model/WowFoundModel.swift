import ObjectMapper

let VOFoundCategories = [
    
    WOWFoundCategoryModel( id:"10", pic: "" ,   title: "客厅与卧室"          ),
    WOWFoundCategoryModel( id:"11", pic: "" ,   title: "厨房"             ),
    WOWFoundCategoryModel( id:"12", pic: "" ,   title: "浴室"             ),
    WOWFoundCategoryModel( id:"15", pic: "" ,   title: "照明"             ),
    WOWFoundCategoryModel( id:"16", pic: "" ,   title: "家庭配饰"         ),
    WOWFoundCategoryModel( id:"18", pic: "" ,   title: "时尚生活"         )
    
]


//
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
//        return "123123123123123"
        return "¥\(self.sellPrice!)"
    }
    
//    "productId": 158,
//    "productName": "不伞5",
//    "productImg": "http://www.wowdsgn.com/media/catalog/product/cache/1/mainimg_1/9df78eab33525d08d6e5fb8d27136e95/t/0/t03.jpg",
//    "sellPrice": 0.01,
//    "originalPrice": 20,
//    "detailDescription": "不一样的伞不一样的伞不一样的伞不一样的伞不一样的伞不一样的伞不一样的伞不一样的伞不一样的伞不一样的伞不一样的伞不一样的伞不一样的伞",
//    "pageModuleType": 4

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

struct WOWFoundCategoryModel{
    
    var id:String       = "" //分类id
    var pic:String      = "" //图片路径
    var title:String    = "" //标题
    
}
