//
//  WOWSceneModel.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/19.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
import ObjectMapper

class WOWSenceModel: WOWBaseModel,Mappable{
    var id               :   String?
    var name             :   String?
    var products         :   [WOWProductModel]?
    var senceTime        :   String?
    var image            :   String?
    var url              :   String?
    var desc             :   String?
    var totalPrice       :   String?
    var userLike         :   String?
    var recommendProducts:   [WOWProductModel]?
    var comments         :   [WOWCommentListModel]?
    var comments_count   :   Int?
    
    required init?( map: Map) {
        
    }
    
    func mapping(map: Map) {
        id                  <- map["_id"]
        name                <- map["name"]
        senceTime           <- map["time"]
        products            <- map["products"]
        image               <- map["image"]
        url                 <- map["url"]
        desc                <- map["desc"]
        totalPrice          <- map["total_price"]
        userLike            <- map["user_like"]
        recommendProducts   <- map["recommend_products"]
        comments            <- map["comments"]
        comments_count      <- map["commentcount"]
    }
}
