//
//  WOWHomeModel.swift
//  wowapp
//
//  Created by 陈旭 on 16/9/2.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
import ObjectMapper

final class WOWHomeTabs: WOWBaseModel,Mappable{

    var id                      :       Int?
    var name                    :       String?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id             <- map["id"]
        name           <- map["name"]
    
    }

}
final class WOWHomeClassTabs: WOWBaseModel,Mappable{
    
    var id                      :       Int?
    var name                    :       String?
    var moduleId                :       Int?
    var moduleType              :       Int?
    var moduleName              :       String?
    var moduleDescription       :       String?
    var moduleContent           :       WOWCarouselBanners?// 顶部轮播，单个图片
    var moduleStyle             :   WOWHomeModultStyle?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id             <- map["id"]
        name           <- map["name"]
        moduleId                    <- map["moduleId"]
        moduleType                  <- map["moduleType"]
   
        moduleName                  <- map["moduleName"]
        moduleDescription           <- map["moduleDescription"]
        moduleContent              <- map["moduleContent"]
        moduleStyle                 <- map["moduleStyle"]
    }
    
}
final class WOWHomeModle: WOWBaseModel,Mappable{
    var moduleType              :  Int?
    var moduleContent           :  WOWCarouselBanners?// 顶部轮播，单个图片
    var moduleContentList       :  WOWModelVoTopic?//产品列表CollectionView
    var moduleContentProduct    :  WOWHomeProduct_402_Info? // 自定义产品组
    var moduleAdditionalInfo    :  WOWHomeAdditionalInfo? // 配置信息～
    
    var moduleContentTitle      :  WOWHomeHot_1001_title? // 精选页hot标签
    
    var moduleId                : Int?
   
    
    var moduleContentTmp        :   AnyObject?
    var moduleContentArr        :  [WowModulePageItemVO]?

    var moduleStyle             :   WOWHomeModultStyle?
    
    var name                    :   String?
    
    var moduleName              :   String?
    var moduleDescription       :   String?
    
//    var moduleContentArr:[WowModulePageItemVO]?
    var moduleContentItem:WowModulePageItemVO?
    
    var moduleClassName:String?

    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        moduleType                  <- map["moduleType"]
        moduleName                  <- map["moduleName"]
        moduleDescription           <- map["moduleDescription"]
        moduleId                    <- map["moduleId"]
        moduleStyle                 <- map["moduleStyle"]
        switch moduleType! {
        case 101,103://顶部轮播
            moduleContent           <- map["moduleContent"]
        case 201://单个图片
            moduleContent           <- map["moduleContent"]
        case 601://产品列表CollectionView
            moduleContentList       <- map["moduleContent"]
            moduleAdditionalInfo    <- map["moduleAdditionalInfo"]
        case 701://爆款页 参数

            moduleAdditionalInfo    <- map["moduleAdditionalInfo"]
            moduleContentList       <- map["moduleContent"]
            
        case 401,402:// 自定义产品组
            moduleAdditionalInfo        <- map["moduleAdditionalInfo"]
            moduleContentProduct        <- map["moduleContent"]
        case 102:// 专题列表
            moduleAdditionalInfo        <- map["moduleAdditionalInfo"]
            moduleContent               <- map["moduleContent"]
        case 801:// 今日单品
            moduleAdditionalInfo        <- map["moduleAdditionalInfo"]
            moduleContentProduct        <- map["moduleContent"]
        case 901,1001:// 1001--hot标签，901--尖叫栏目
            moduleContentTitle          <- map["moduleContent"]
            
        case 301,302,501,201,401:// 今日单品
//            moduleAdditionalInfo        <- map["moduleAdditionalInfo"]
            moduleContentTmp            <- map["moduleContent"]
//                moduleContentTmp              <- map["moduleContent"]
        case 104,105:
             moduleContent              <- map["moduleContent"]
        case 107,106:
            moduleContent        <- map["moduleContent"]
        default:
            break
        }
  

    }
}
class WOWHomeAdditionalInfo: WOWBaseModel,Mappable {
    // 701  imageUrl:背景图片地址  title：标题
    var imageUrl                :       String?
    var title                   :       String?
    var showTitle               :       Bool?
    // 601 , 标题简介应该显示多少个字
    var descLen                 :       Int?

    
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        imageUrl            <- map["imageUrl"]
        showTitle           <- map["showTitle"]
        title               <- map["title"]
        descLen             <- map["descLen"]
        
    }
    
}
class WOWHomeProduct_402_Info: WOWBaseModel,Mappable {
    // 701  imageUrl:背景图片地址  title：标题
    var id                      :       Int?
    var name                    :       String?
    var products                :       [WOWProductModel]?
    
    var banners                 :       [WOWCarouselBanners]?
    
    var link                    :       WOWCarouselBanners?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id                  <- map["id"]
        name                <- map["name"]
        products            <- map["products"]
        link            <- map["link"]
        banners                 <- map["banners"]
        
    }
    
}
// 1001， 901 都可以用
class WOWHomeHot_1001_title: WOWBaseModel,Mappable {
    // 701  imageUrl:背景图片地址  title：标题
    var id                      :       Int?
    var name                    :       String?
    var icon                    :       String?
    var tags                    :       [WOWHomeHot_1001_title]?
    var columns                 :       [WOWHomeHot_1001_title]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id                  <- map["id"]
        name                <- map["name"]
        icon                <- map["icon"]
        tags                <- map["tags"]
        columns             <- map["columns"]
    }
    
}

class WOWHomeModultStyle: WOWBaseModel,Mappable {
    
    var marginBottom                   :       Float?
    var marginLeft                     :       Float?
    var marginRight                    :       Float?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        marginBottom                    <- map["marginBottom"]
        marginLeft                      <- map["marginLeft"]
        marginRight                     <- map["marginRight"]

    }
    
}
