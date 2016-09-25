
import ObjectMapper

struct WOWVOAd: Mappable {
    var id                          :Int?
    var workday                   :Int?
    var imgUrl                    :String?
    var contentUrl              :String?
    var isEnable                   :Bool?
    
    init?(map: Map) {
        
    }
    init?() {
        
    }
    mutating func mapping(map: Map) {
        id              <- map["id"]
        workday         <- map["workday"]
        imgUrl          <- map["imgUrl"]
        contentUrl      <- map["contentUrl"]
        isEnable       <- map["isEnable"]
        
    }
}



