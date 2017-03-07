//
//  WOWMenuModel.swift
//  Wow
//
//  Created by dcpSsss on 16/4/3.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit
import ObjectMapper


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
    func mapping(map: Map) {
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
    
    convenience init?(map: Map) {
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
    
 
    func mapping(map: Map) {
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
    
    convenience init?(map: Map) {
        self.init()
    }
}







final class WOWSubCategoryModel: WOWBaseModel,Mappable{
      var subCatName : String = ""
      var subCatID   : String = ""
        var id         : Int = 0
        var categoryName        : String = ""
}

extension WOWSubCategoryModel{
    convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        subCatName    <-    map["name"]
        subCatID      <-    map["cid"]
        id              <- map["id"]
        categoryName    <- map["categoryName"]
    }
    
}

final class WOWNewCategoryModel: WOWBaseModel,Mappable {
    var id                      :       Int?
    var name                    :       String?
    var icon                :       String?
    var background              : String?
    var categories              : [WOWSubCategoryModel]?
    
    
    convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id                  <- map["id"]
        name                <- map["name"]
        icon                <- map["icon"]
        background          <- map["background"]
        categories          <- map["categories"]
    }
    
}


