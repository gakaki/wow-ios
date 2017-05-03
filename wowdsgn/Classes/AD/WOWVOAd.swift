
import ObjectMapper

struct WOWVOAd: Mappable {
    var id                          :Int?
    var imgUrl                      :String?
    var contentUrl                  :String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id              <- map["id"]
        imgUrl          <- map["bannerImgSrc"]
        contentUrl      <- map["contentUrl"]
        
    }
}



