
import ObjectMapper

//{
//    "id": 1,
//    "topicName": "unnamed",
//    "topicImg": "http://img.wowdsgn.com/topic/banner/1.jpg?a",
//    "topicMainTitle": "浓郁北欧元素季",
//    "topicDesc": "回归自然，崇尚原木韵味，外加现代、实用、精美的艺术设计风格，北欧人似乎有着不可替代的天赋",
//    "topicType": 1,
//    "groupId": 0,
//    "canShow": true,
//    "createTime": 1470971693000
//}

class WOWModelVoTopic: WOWBaseModel,Mappable {
    var id                          :Int?
    var topicName                   :String?
    var topicImg                    :String?
    var topicMainTitle              :String?
    var topicDesc                   :String?
    var topicType                   :Int?
    var groupId                     :Int?
    var canShow                     :Int?
    var createTime                  :NSNumber?
    var products                    :[WOWProductModel]?
    var brand                       :WOWBrandStyleModel?
    var likeQty                     :Int?
    var readQty                     :Int?
    var imageSerial                 :WOWImageSerial?
    var favorite                    : Bool?
    var imageAspect:CGFloat = 0
    
    required init?(map: Map) {
        
        
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        topicName       <- map["topicName"]
        topicImg        <- map["topicImg"]
        topicMainTitle  <- map["topicMainTitle"]
        topicDesc       <- map["topicDesc"]
        topicType       <- map["topicType"]
        groupId         <- map["groupId"]
        canShow         <- map["canShow"]
        createTime      <- map["createTime"]
        products        <- map["products"]
        brand           <- map["brand"]
        likeQty         <- map["likeQty"]
        readQty         <- map["readQty"]
        imageSerial     <- map["imageSerial"]
        favorite        <- map["favorite"]
       
        if imageAspect == 0 {
//            calImageHeight()
        }
        
    }
    func calImageHeight(){
        //定义NSURL对象
        let url = NSURL(string: topicImg ?? "")
        DispatchQueue.global(qos: .background).async {
            if let data = NSData(contentsOf: url as! URL), let image = UIImage(data: data as Data) {
                //计算原始图片的宽高比
                self.imageAspect = image.size.width / image.size.height
                //            //设置imageView宽高比约束
                //            //加载图片
                //
                
            }
        }
        
    }
}

class WOWImageSerial: WOWBaseModel, Mappable {
    var serialId:           Int?
    var records:            [WOWProductPicTextModel]?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        serialId        <- map["serialId"]
        records         <- map["records"]
    }
}
