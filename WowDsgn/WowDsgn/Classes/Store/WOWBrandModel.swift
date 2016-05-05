//
//  WOWBrandModel.swift
//  WowDsgn
//
//  Created by 小黑 on 16/5/5.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit
import ObjectMapper

class WOWBrandModel: WOWBaseModel,Mappable {
    var id         : String?
    var name       : String?
    var image      : String?
    var url        : String?
    var products   : [WOWProductModel]?
    var desc       : String?
    
    required init?(_ map: Map) {
        
        
    }
    
    func mapping(map: Map) {
        id       <- map["id"]
        name     <- map["name"]
        image    <- map["image"]
        url      <- map["url"]
        products <- map["products"]
        desc     <- map["desc"]
    }
    
    
    static func shareBrand(shareStr:String,url:String){
        //替换
        let shareText = shareStr
        //微信好友
        UMSocialData.defaultData().extConfig.wxMessageType = UMSocialWXMessageTypeWeb
        UMSocialData.defaultData().extConfig.wechatSessionData.url = url
        UMSocialData.defaultData().extConfig.wechatSessionData.shareText = shareText
        UMSocialData.defaultData().extConfig.wechatSessionData.shareImage = UIImage(named: "me_logo")
        UMSocialData.defaultData().extConfig.wechatSessionData.title = shareText
        
        //朋友圈
        UMSocialData.defaultData().extConfig.wechatTimelineData.url = url
        UMSocialData.defaultData().extConfig.wechatTimelineData.shareText = shareText
        UMSocialData.defaultData().extConfig.wechatTimelineData.shareImage = UIImage(named: "me_logo")
        UMSocialData.defaultData().extConfig.wechatTimelineData.title = shareText
        
        //微博
        UMSocialData.defaultData().extConfig.sinaData.shareText = shareText
        UMSocialData.defaultData().extConfig.sinaData.shareImage = UIImage(named: "me_logo")
        
        let vc = UIApplication.currentViewController()
        UMSocialSnsService.presentSnsIconSheetView(vc, appKey:WOWUMKey, shareText:"", shareImage:nil, shareToSnsNames: [UMShareToWechatTimeline,UMShareToWechatSession,UMShareToSina], delegate: nil)
    }
    
    
}
