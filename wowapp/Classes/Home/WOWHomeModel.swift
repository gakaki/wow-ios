//
//  WOWHomeModel.swift
//  wowapp
//
//  Created by 陈旭 on 16/9/2.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
import ObjectMapper
//class WOWHomeModel: WOWBaseModel,Mappable {
//    var pageId               :   Int?
//    var region          :   Int?
//    var moduleDataList          :  [WOWHomeModle]?
//    
//    required init?(_ map: Map) {
//        
//    }
//    
//    func mapping(map: Map) {
//        pageId                 <- map["pageId"]
//        region            <- map["region"]
//        moduleDataList            <- map["modules"]
//        
//    }
//
//}
final class WOWHomeModle: WOWBaseModel,Mappable{
    var moduleType    :   Int?
    var moduleContent           :  WOWCarouselBanners?
    var moduleContentList       :  WOWModelVoTopic?//产品列表CollectionView
    var moduleAdditionalInfo    :   WOWHomeAdditionalInfo? // 配置信息～

    required init?(_ map: Map) {
        
    }
    
    func mapping(_ map: Map) {
        moduleType    <- map["moduleType"]
        
        switch moduleType! {
        case 101://顶部轮播
            moduleContent         <- map["moduleContent"]
        case 201://单个图片
            moduleContent         <- map["moduleContent"]
        case 601://产品列表CollectionView
            moduleContentList         <- map["moduleContent"]
            moduleAdditionalInfo    <- map["moduleAdditionalInfo"]
        case 701://爆款页 参数

            moduleAdditionalInfo    <- map["moduleAdditionalInfo"]

            moduleContentList       <- map["moduleContent"]
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

    
    
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(_ map: Map) {
        
        imageUrl            <- map["imageUrl"]
        showTitle           <- map["showTitle"]
        title               <- map["title"]
        descLen             <- map["descLen"]
        
    }
    
}
