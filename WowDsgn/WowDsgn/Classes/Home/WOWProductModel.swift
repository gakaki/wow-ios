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
    var productID:String?
    var productName:String?
    var productX:Float?
    var productY:Float?
    
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
//    var likesList       : []
//    var favorites_count : Int?
    var user_isLike     : String?
    
    var designer_url    : String?
    var designer_name   : String?
    var designer_image  : String?
    var designer_desc   : String?
    var attributes      : [WOWAttributeModel]?
    var skus            : [WOWProductSkuModel]?
    var pics_compose    : [WOWProductPicTextModel]? //图文详情
    var pics_carousel   : [String]?  //详情轮播的图片
    
    override init() {
        super.init()
    }
    
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        productID       <- map["id"]
        productName     <- map["name"]
        productX        <- map["x"]
        productY        <- map["y"]
        
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
        pics_compose    <- map["pics_compose"]
        pics_carousel   <- map["pics_carousel"]
        user_isLike     <- map["user_like"]
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
