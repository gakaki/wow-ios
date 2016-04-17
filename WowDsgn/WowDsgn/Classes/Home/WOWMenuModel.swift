//
//  WOWMenuModel.swift
//  Wow
//
//  Created by dcpSsss on 16/4/3.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit
import ObjectMapper

final class WOWCategoryModel : Object{
   dynamic var categoryName:String = ""
   dynamic var categoryCount:Int = 0
   dynamic var categoryID:String = ""
    
    override static func primaryKey() -> String? {
        return "categoryID"
    }
    
}

extension WOWCategoryModel:Mappable{
    func mapping(map: Map) {
        categoryName    <-    map["name"]
        categoryCount   <-    map["sum"]
        categoryID      <-    map["cid"]
    }
    
    convenience init?(_ map: Map) {
        self.init()
    }
}
