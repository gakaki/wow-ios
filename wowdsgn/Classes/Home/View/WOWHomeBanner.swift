//
//  WOWHomeBanner.swift
//  wowapp
//
//  Created by 安永超 on 16/7/25.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
import ObjectMapper
//暂时不用
class WOWHomeBanner: WOWBaseModel,Mappable {
    var bannerList               :   [WOWCarouselBanners]?
    var carouselBanners          :   [WOWCarouselBanners]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        bannerList                 <- map["bannerList"]
        carouselBanners            <- map["carouselBanners"]
       
    }

}

//暂时不用
class WOWHomeBannerr: WOWBaseModel,Mappable {
    //moduleType = 101
    var banners               :   [WOWCarouselBanners]?
    //moduleType = 201
    var bannerImgSrc          :     String?
    var bannerLinkType        :     Int?
    var bannerLinkTargetId    :     Int?
    var bannerLinkUrl         :     String?

    
   
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        banners                 <- map["banners"]

        bannerImgSrc            <- map["bannerImgSrc"]
        bannerLinkType          <- map["bannerLinkType"]
        bannerLinkTargetId      <- map["bannerLinkTargetId"]
        bannerLinkUrl           <- map["bannerLinkUrl"]

        
    }
    
}


final class WOWCarouselBanners: WOWBaseModel,Mappable{
    var id                    : Int?
    var name                  : String?
    
    var background            : String?
    
    var banners               :   [WOWCarouselBanners]?
    
    var bannerTitle           :   String?
    var bannerLinkTargetId    :   Int?
    var bannerLinkUrl         :   String?
    var bannerImgSrc          :   String?
    var bannerLinkType        :   Int?
    var link                  :   WOWCarouselBanners?
    var bannerIsOut           = false  // banner 是否展开 默认为false 不展开
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        name            <- map["name"]
        link            <- map["link"]
        banners                 <- map["banners"]
        bannerTitle             <- map["bannerTitle"]
        bannerLinkTargetId      <- map["bannerLinkTargetId"]
        bannerLinkUrl           <- map["bannerLinkUrl"]
        bannerImgSrc            <- map["bannerImgSrc"]
        bannerLinkType          <- map["bannerLinkType"]
        background              <- map["background"]
    }
}
