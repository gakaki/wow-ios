//
//  ScreenConfigModel.swift
//  wowapp
//
//  Created by 陈旭 on 16/9/26.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
import ObjectMapper

class ScreenConfigModel:NSObject,Mappable{
    
    var colorList       : [ScreenModel]?
    var styleList       : [ScreenModel]?
    var sceneList       : [ScreenModel]?
   
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        colorList           <-   map["colors"]
        styleList           <-   map["styles"]
        sceneList           <-   map["sceneList"]
    }
}
class ScreenModel:NSObject,Mappable{
    
    
    
    var id              : Int?
    var name            : String?
    var imgurl          : String?
    var min             : Int?
    var max             : Int?
    var isSelect        : Bool = false
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id          <-   map["id"]
        name        <-   map["name"]
        imgurl      <-   map["imgurl"]
        min         <-   map["min"]
        max         <-   map["max"]
    }
}
