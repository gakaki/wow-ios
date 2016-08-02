import ObjectMapper

let VOFoundCategories = [
    
    WOWFoundCategoryModel( id:"10", pic: "" ,   title: "客厅与卧室"          ),
    WOWFoundCategoryModel( id:"11", pic: "" ,   title: "厨房"             ),
    WOWFoundCategoryModel( id:"12", pic: "" ,   title: "浴室"             ),
    WOWFoundCategoryModel( id:"15", pic: "" ,   title: "照明"             ),
    WOWFoundCategoryModel( id:"16", pic: "" ,   title: "家庭配饰"         ),
    WOWFoundCategoryModel( id:"18", pic: "" ,   title: "时尚生活"         )
    
]

class WOWFoundRecommendModel: WOWBaseModel,Mappable{
    var id               :   String?
    var name             :   String?
    var pic              :   String?
    var desc             :   String?
    
    var price_before     :   String?
    var price            :   String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        id                  <- map["id"]
        name                <- map["name"]
        pic                 <- map["pic"]
        desc                <- map["desc"]
        price_before        <- map["price_before"]
        price               <- map["price"]
    }
}

struct WOWFoundCategoryModel{
    
    var id:String       = "" //分类id
    var pic:String      = "" //图片路径
    var title:String    = "" //标题
    
}

class WOWFoundWeeklyNewModel: WOWBaseModel,Mappable{
    var id               :   String?
    var name             :   String?
    var pic              :   String?
    var desc             :   String?
    
    var price_before     :   String?
    var price            :   String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        id                  <- map["id"]
        name                <- map["name"]
        pic                 <- map["pic"]
        desc                <- map["desc"]
        price_before        <- map["price_before"]
        price               <- map["price"]
    }
}