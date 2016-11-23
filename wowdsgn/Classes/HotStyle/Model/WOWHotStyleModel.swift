//
//  WOWHotStyleModel.swift
//  wowdsgn
//
//  Created by 陈旭 on 2016/11/21.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit
import ObjectMapper
class WOWHotStyleModel: WOWBaseModel,Mappable {
    var id                          :   Int?
    var columnId                    :   Int?
    var columnName                  :   String?
    var columnIcon                  :   String?
    var topicName                   :   String?
    var topicImg                    :   String?
    var topicMainTitle              :   String?
    var brandId                     :   Int?
    var designerId                  :   Int?
    var topicDesc                   :   String?
    var topicType                   :   Int?
    var favoriteQty                 :   Int?
    var readQty                     :   Int?
    var publishTime                 :   Int?
    var status                      :   Int?
    var deleted                     :   Bool?
    var favorite                    :   Bool?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id                          <- map["id"]
        columnId                    <- map["columnId"]
        columnName                  <- map["columnName"]
        columnIcon                  <- map["columnIcon"]
        topicName                   <- map["topicName"]
        topicImg                    <- map["topicImg"]
        topicMainTitle              <- map["topicMainTitle"]
        brandId                     <- map["brandId"]
        designerId                  <- map["designerId"]
        topicDesc                   <- map["topicDesc"]
        topicType                   <- map["topicType"]
        favoriteQty                 <- map["favoriteQty"]
        readQty                     <- map["readQty"]
        publishTime                 <- map["publishTime"]
        status                      <- map["status"]
        deleted                     <- map["deleted"]
        favorite                    <- map["favorite"]
    }

}
