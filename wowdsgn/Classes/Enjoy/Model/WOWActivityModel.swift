//
//  WOWActivityModel.swift
//  wowdsgn
//
//  Created by 安永超 on 2017/5/4.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
import ObjectMapper

class WOWActivityModel: WOWBaseModel ,Mappable {
    
    var id                              :  Int?
    var instagramCategoryId             :  Int?
    var img                             :  String?
    var title                           :  String?
    var content                         :  String?
    var subhead                         :  String?
    var categoryName                    :  String?
    var offset                          :  Int?     //距离开始/结束天数
    var status                          :  Int?     //0-未开始,1-未结束,2-已结束
    var instagramQty                    :  Int?     //作品数
    var likeQty                         :  Int?     //喜欢数
    var picHeight               : CGFloat = MGScreenWidth

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id                                                      <- map["id"]
        instagramCategoryId                                     <- map["instagramCategoryId"]
        img                                                     <- map["img"]
        title                                                   <- map["title"]
        categoryName                                            <- map["categoryName"]
        subhead                                                 <- map["subhead"]
        content                                                 <- map["content"]
        offset                                                  <- map["offset"]
        status                                                  <- map["status"]
        instagramQty                                            <- map["instagramQty"]
        likeQty                                                 <- map["likeQty"]
        if let pic = img{
            if pic.contains("_2dimension_") {
                
                picHeight =  WOWArrayAddStr.get_img_sizeNew(str: pic , width: MGScreenWidth, defaule_size: .OneToOne)
                
            }
        }
    }

}
