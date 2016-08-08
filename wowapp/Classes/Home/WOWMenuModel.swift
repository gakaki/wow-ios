//
//  WOWMenuModel.swift
//  Wow
//
//  Created by dcpSsss on 16/4/3.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit
import ObjectMapper

/*
final class WOWCategoryModel : Object{
   dynamic var categoryName:String = ""
   dynamic var categoryCount:Int = 0
   dynamic var categoryID:String = ""
   let subCats = List<WOWSubCategoryModel>()
    
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




final class WOWSubCategoryModel: Object,Mappable{
    dynamic  var subCatName : String = ""
    dynamic  var subCatID   : String = ""
}

extension WOWSubCategoryModel{
      convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        subCatName    <-    map["name"]
        subCatID      <-    map["cid"]
    }
}
*/


final class WOWCategoryModel : WOWBaseModel{
     var categoryName:String?
     var categoryCount:Int?
     var categoryID:String?
    
     var categoryBgImg:String?
     var categoryIconBig:String?
     var categoryIconBg:String?

    
     var subCats:[WOWSubCategoryModel]?
}

extension WOWCategoryModel:Mappable{
    func mapping(map: Map) {
        categoryName    <-    map["categoryName"]
        categoryCount   <-    map["sum"]
        categoryID      <-    (map["categoryId"],StringDecimalNumberTransform())
        subCats         <-    map["subcats"]
        
        categoryBgImg   <-    map["categoryBgImg"]
        categoryIconBig <-    map["categoryIconBig"]
        categoryIconBg  <-    map["categoryIconBg"]
        
    }
    
    convenience init?(_ map: Map) {
        self.init()
    }
}




final class WOWSubCategoryModel: WOWBaseModel,Mappable{
      var subCatName : String = ""
      var subCatID   : String = ""
}

extension WOWSubCategoryModel{
    convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        subCatName    <-    map["name"]
        subCatID      <-    map["cid"]
    }
    
}


