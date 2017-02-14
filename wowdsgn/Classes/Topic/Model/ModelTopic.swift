
import ObjectMapper


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

class WOWContentTopicModel: WOWBaseModel,Mappable {
    var topicId                         :Int?
    var columnId                        :Int?
    var columnName                      :String?
    var topicName                   :String?
    var topicImg                    :String?
    var topicDesc                   :String?
    var images                      :[WOWImages]?
    var products                    :[WOWProductModel]?
    var tag                         :[WOWTopicTagModel]?
    var contents                    :[WOWContentsModel]?
    var favoriteQty                     :Int?
    var publishTime                 :Int?
    var allowComment                : Bool?
    var favorite                    : Bool?
    var imageAspect:CGFloat = 0
    
    required init?(map: Map) {
        
        
    }
    
    func mapping(map: Map) {
        topicId                 <- map["id"]
        columnId                <- map["columnId"]
        columnName              <- map["columnName"]
        topicName               <- map["topicName"]
        topicImg                <- map["topicImg"]
        topicDesc               <- map["topicDesc"]
        images                  <- map["images"]
        products                <- map["products"]
        tag                     <- map["tags"]
        contents                <- map["contents"]
        favoriteQty             <- map["favoriteQty"]
        publishTime             <- map["publishTime"]
        allowComment            <- map["allowComment"]
        favorite                <- map["favorite"]
       
        
    }
   
}

class WOWContentsModel: WOWBaseModel, Mappable {
    var type:                 Int?
    var product:              WOWTopicProductModel?
    var image:                WOWImages?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        type                <- map["type"]
        product             <- map["product"]
        image               <- map["image"]
    }
}

class WOWTopicProductModel: WOWBaseModel, Mappable {
    var product:               WOWProductModel?

    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        product                <- map["product"]

    }
}

class WOWImages: WOWBaseModel, Mappable {
    var url:           String?
    var note:           String?
    var desc:           String?
    var imageAspect:CGFloat = 0

    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        url             <- map["url"]
        note            <- map["note"]
        desc            <- map["desc"]
        if imageAspect == 0 {
            imageAspect = CGFloat(WOWArrayAddStr.get_imageAspect(str: url ?? ""))// 拿到图片的宽高比,
            if imageAspect == 0 {
                calImageHeight()
            }
        }
    }
    func calImageHeight(){
        
        //定义NSURL对象

        let url = URL(string: self.url ?? "")
        
        if let url = url {
            
            DispatchQueue.global(qos: .background).async {
                do{
                    let data = try Data(contentsOf: url)
                    if let image = UIImage(data: data ) {
                            //计算原始图片的宽高比
                            
                        self.imageAspect = image.size.width / image.size.height
                            //            //设置imageView宽高比约束
                            //            //加载图片
                            //
                    }
                }catch let e {
                    DLog(e)
                }

            }
        
        }
        
        
        
    }

}
class WOWTopicTagModel: WOWBaseModel, Mappable {
    var id:                 Int?
    var name:               String?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        name            <- map["name"]
    }
}
class WOWTopicCommentModel: WOWBaseModel, Mappable {
    var total:                    Int?
    var comments:                 [WOWTopicCommentListModel]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        total              <- map["total"]
        comments            <- map["comments"]
        
    }
}
class WOWTopicCommentListModel: WOWBaseModel, Mappable {
    var commentId:                 Int?
    var userName:                 String?
    var userAvatar:               String?
    var content:                  String?
    var createTime:                Int?
    var favorite:                 Bool?
    var favoriteQty:            Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        commentId             <- map["id"]
        userName              <- map["userName"]
        userAvatar            <- map["userAvatar"]
        content               <- map["content"]
        createTime             <- map["createTime"]
        favorite              <- map["favorite"]
        favoriteQty         <- map["favoriteQty"]
    }
}
