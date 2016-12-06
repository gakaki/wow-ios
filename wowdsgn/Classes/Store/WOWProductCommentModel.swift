//
//  WOWProductCommentModel.swift
//  wowdsgn
//
//  Created by 安永超 on 16/11/24.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit
import ObjectMapper


class WOWProductCommentModel: WOWBaseModel, Mappable{
    var nickName                : String?
    var avatar                  : String?
    var comments                : String?
    var commentImgs             : [String]?
    var specAttributes          : [String]?
    var isReplyed               : Bool?
    var employeeRealName        : String?
    var replyContent            : String?
    var publishTimeFormat       : String?
    var timeStamp               : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        nickName            <- map["nickName"]
        avatar              <- map["avatar"]
        comments            <- map["comments"]
        commentImgs         <- map["commentImgs"]
        specAttributes      <- map["specAttributes"]
        isReplyed           <- map["isReplyed"]
        employeeRealName    <- map["employeeRealName"]
        replyContent        <- map["replyContent"]
        publishTimeFormat   <- map["publishTimeFormat"]
        timeStamp           <- map["timeStamp"]
    }

}
