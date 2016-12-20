//
//  WOWMessageModel.swift
//  wowdsgn
//
//  Created by 安永超 on 16/12/12.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit
import ObjectMapper



class WOWMessageModel: WOWBaseModel,Mappable {
    var messageId                   : Int?
    var msgType                     : Int?
    var unReadCount                 : Int?
    var msgTitle                    : String?
    var msgContent                  : String?
    var openType                    : Int?
    var targetType                  : String?
    var targetId                    : String?
    var targetUrl                   : String?
    var isRead                      : Bool?
    var createTime                  : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        messageId                   <- map["messageId"]
        msgType                     <- map["msgType"]
        unReadCount                 <- map["unReadCount"]
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
