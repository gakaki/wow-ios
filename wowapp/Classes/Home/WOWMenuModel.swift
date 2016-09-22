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
     var categoryIconSmall:String?
    
     var productImg :String?

     var subCats:[WOWSubCategoryModel]?
}

extension WOWCategoryModel:Mappable{
    func mapping(_ map: Map) {
        categoryName    <-    map["categoryName"]
        categoryCount   <-    map["sum"]
        categoryID      <-    (map["categoryId"],StringDecimalNumberTransform())
        subCats         <-    map["subcats"]
        
        categoryBgImg   <-    map["categoryBgImg"]
        categoryIconBig <-    map["categoryIconBig"]
        categoryIconBg  <-    map["categoryIconBg"]
        categoryIconSmall  <-    map["categoryIconSmall"]

        productImg      <-    map["productImg"]

    }
    
    convenience init?(_ map: Map) {
        self.init()
    }
}






final class WOWFoundCategoryModel : WOWBaseModel,Mappable{
    var categoryName:String?
    var categoryID:Int?
    var categoryIconSmall:String?
    
    var categoryCount:Int?
    
    var categoryBgImg:String?
    var categoryIconBig:String?
    var categoryIconBg:String?
    var categoryDesc:String?
    var productImg :String?
    
 
    func mapping(_ map: Map) {
        categoryName            <-    map["categoryName"]
        categoryID              <-    map["id"]
        categoryIconSmall       <-    map["categoryIconSmall"]
        
        
        categoryCount   <-    map["sum"]
        
        categoryBgImg   <-    map["categoryBgImg"]
        categoryIconBig <-    map["categoryIconBig"]
        categoryIconBg  <-    map["categoryIconBg"]
        categoryIconSmall  <-    map["categoryIconSmall"]
        categoryDesc  <-    map["categoryDesc"]

        productImg      <-    map["productImg"]

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
    
    func mapping(_ map: Map) {
        subCatName    <-    map["name"]
        subCatID      <-    map["cid"]
    }
    
}


