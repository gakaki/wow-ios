//
//  WOWMessageModel.swift
//  wowdsgn
//
//  Created by 安永超 on 16/12/12.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit
import ObjectMapper

class WOWMessageMainModel: WOWBaseModel,Mappable {
    var userMessageUnReadCount      : Int?
    var systemMessageUnReadCount    : Int?
    var userMessageVo               : WOWMessageModel?
    var systemMessageVo             : WOWMessageModel?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        userMessageUnReadCount      <- map["userMessageUnReadCount"]
        systemMessageUnReadCount    <- map["systemMessageUnReadCount"]
        userMessageVo               <- map["userMessageVo"]
        systemMessageVo             <- map["systemMessageVo"]
    }
}

class WOWMessageModel: WOWBaseModel,Mappable {
    var messageId                   : Int?
    var msgTitle                    : String?
    var msgContent                  : String?
    var openType                    : Int?
    var targetType                  : Int?
    var targetId                    : String?
    var targetUrl                   : String?
    var isRead                      : Bool?
    var createTime                  : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        messageId                   <- map["messageId"]
        msgTitle                    <- map["msgTitle"]
        msgContent                  <- map["msgContent"]
        openType                    <- map["openType"]
        targetType                  <- map["targetType"]
        targetId                    <- map["targetId"]
        targetUrl                   <- map["targetUrl"]
        isRead                      <- map["isRead"]
        createTime                  <- map["createTime"]

    }
}
