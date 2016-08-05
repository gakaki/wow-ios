//
//  WOWProductModel.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/19.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
import ObjectMapper

class WOWProductModel: WOWBaseModel,Mappable{
    var productId             : String?
    var primaryImgs           : Array<String>?
    var productName           : String?
    var sellPrice             : Double?
    var sellingPoint          : String?
    var brandCname            : String?
    var brandId               : Int?
    var brandLogoImg          : String?
    var designerId            : Int?
    var designerName          : String?
    var designerPhoto         : String?
    var firstNonPrimaryImgUrl : String?
    var firstNonPrimaryImgDesc: String?
    var detailDescription     : String?
    var productParameter      : WOWParameter?
    
    
    var productDes      : String?
    var productShortDes : String?
    
    var productImage    : String?
    var price           : String?
    var brandID         : String?
    var brandName       : String?
    var brandImage      : String?
    var brandDesc       : String?
    
    var comments_count  : Int?
    var comments        : [WOWCommentListModel]?
    var likesCount      : Int?
    var user_isLike     : String?
    
    var designer_url    : String?
    var designer_name   : String?
    var designer_image  : String?
    var designer_desc   : String?
    var attributes      : [WOWAttributeModel]?
    var skus            : [WOWProductSkuModel]?
    var skuID           : String?
    var pics_compose    : [WOWProductPicTextModel]? //图文详情
    var pics_carousel   : [String]?  //详情轮播的图片
    
    override init() {
        super.init()
    }
    
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {

        productDes      <- map["description"]
        productShortDes <- map["description_short"]
        productImage    <- map["image"]
        price           <- map["price"]
        brandID         <- map["brand_id"]
        brandName       <- map["brand_name"]
        brandImage      <- map["brand_image"]
        brandDesc       <- map["brand_desc"]
        comments_count  <- map["commentcount"]
        comments        <- map["comments"]
        likesCount      <- map["likes_count"]
        designer_url    <- map["designer_url"]
        designer_name   <- map["designer_name"]
        designer_desc   <- map["designer_desc"]
        attributes      <- map["attr"]
        skus            <- map["skus"]
        skuID           <- map["sku"]
        pics_compose    <- map["pics_compose"]
        pics_carousel   <- map["pics_carousel"]
        user_isLike     <- map["user_like"]
        designer_image  <- map["designer_image"]
        
        /*************************新版Map***********************/
        productId               <- map["id"]
        primaryImgs             <- map["primaryImgs"]
        productName             <- map["productName"]
        sellPrice               <- map["sellPrice"]
        sellingPoint            <- map["sellingPoint"]
        brandCname              <- map["brandCname"]
        brandId                 <- map["brandId"]
        brandLogoImg            <- map["brandLogoImg"]
        designerName            <- map["designerName"]
        designerId              <- map["designerId"]
        designerPhoto           <- map["designerPhoto"]
        firstNonPrimaryImgUrl   <- map["firstNonPrimaryImgUrl"]
        firstNonPrimaryImgDesc  <- map["firstNonPrimaryImgDesc"]
        detailDescription       <- map["detailDescription"]
        productParameter        <- map["productParameter"]
        
    
        
    }
    
    /// 商品列表瀑布流需要用的高度
    var cellHeight:CGFloat = 0
    func calCellHeight(){
        let s = self.productShortDes ?? ""
        var height = s.heightWithConstrainedWidth((MGScreenWidth - CGFloat(3)) / CGFloat(2) - 30, font: UIFont.systemScaleFontSize(13))
        height = height > 18 ? 30 : 18
        self.cellHeight = 20 + 5 + 14 + height + 6 + WOWGoodsSmallCell.itemWidth
    }
    
}
