//
//  WOWFavoriteListModel.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/29.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
import ObjectMapper

class WOWFavoriteListModel: WOWBaseModel,Mappable{
    var id         :String?
    var type       :String?
    var imgUrl     :String?
    var name       :String?
    var price      :String?
    
    var cellHeight:CGFloat = 0
    
    func mapping(map: Map) {
        id      <- map["id"]
        type    <- map["type"]
        imgUrl  <- map["imageurl"]
        name    <- map["name"]
        price   <- map["price"]
    }
    
    required init?(_ map: Map) {
        
    }
    
    
    
    func calCellHeight(){
        let s = self.name ?? ""
        var height = s.heightWithConstrainedWidth((MGScreenWidth - CGFloat(3)) / CGFloat(2) - 30, font: UIFont.systemScaleFontSize(13))
        height = height > 18 ? 30 : 18
        self.cellHeight = 20 + 5 + 14 + height + 6 + WOWImageCell.itemWidth
    }

}
