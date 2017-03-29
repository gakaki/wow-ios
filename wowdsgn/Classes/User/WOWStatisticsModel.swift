//
//  WOWStatisticsModel.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/29.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
import ObjectMapper


class WOWStatisticsModel: WOWBaseModel,Mappable{
    var endUserId                   : Int?
    var instagramCounts             : Int?
    var likeCounts                  : Int?
    var collectCounts               : Int?
    var nickName                    : String?
    var avatar                      : String?
    var selfIntroduction            : String?
    
    override init() {
        super.init()
    }
    
    
    required init?(map: Map) {
        
        
    }
    
    func mapping(map: Map) {
        endUserId                   <- map["id"]
        instagramCounts             <- map["instagramCounts"]
        likeCounts                  <- map["likeCounts"]
        collectCounts               <- map["collectCounts"]
        nickName                    <- map["nickName"]
        avatar                      <- map["avatar"]
        selfIntroduction            <- map["selfIntroduction"]
 
    }
}


class WOWWorksListModel: WOWBaseModel,Mappable{
    var id                          : Int?
    var likeCounts                  : Int?
    var collectCounts               : Int?
    var type                        : String?
    var pic                         : String?
    var userList                    : [WOWStatisticsModel]?
    
    override init() {
        super.init()
    }
    
    
    required init?(map: Map) {
        
        
    }
    
    func mapping(map: Map) {
        id                          <- map["id"]
        likeCounts                  <- map["likeCounts"]
        collectCounts               <- map["collectCounts"]
        type                        <- map["type"]
        pic                         <- map["pic"]
        userList                    <- map["userList"]
        
    }
}
