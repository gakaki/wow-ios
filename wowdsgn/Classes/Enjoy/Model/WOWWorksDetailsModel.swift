//
//  WOWWorksDetailsModel.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/3/28.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
import ObjectMapper
class WOWWorksDetailsModel: WOWBaseModel,Mappable  {
    var id                      :  Int?
    var avatar                  :  String?
    var categoryId              :  Int?
    var categoryName            :  String?
    var des                     :  String?
    var endUserId               :  Int?
    var instagramCounts         :  Int?
    var likeCounts              :  Int?
    var nickName                :  String?
    var pic                     :  String?
    var totalCollectCounts      :  Int?
    var totalLikeCounts         :  Int?
    var like                    :  Int?
    var collect                 :  Int?
    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        id                                          <- map["id"]
        avatar                                      <- map["avatar"]
        categoryId                                  <- map["categoryId"]
        categoryName                                <- map["categoryName"]
        des                                         <- map["description"]
        endUserId                                   <- map["endUserId"]
        instagramCounts                             <- map["instagramCounts"]
        likeCounts                                  <- map["likeCounts"]
        nickName                                    <- map["nickName"]
        pic                                         <- map["pic"]
        totalCollectCounts                          <- map["totalCollectCounts"]
        totalLikeCounts                             <- map["totalLikeCounts"]
        like                                        <- map["like"]
        collect                                     <- map["collect"]
    }

}
