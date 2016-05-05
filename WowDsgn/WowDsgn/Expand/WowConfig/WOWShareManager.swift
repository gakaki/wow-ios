//
//  WOWShareManager.swift
//  WowDsgn
//
//  Created by 小黑 on 16/5/5.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import Foundation

struct WOWShareManager {
    static func share(title:String?,shareText:String?,url:String?){
        let shareUrl = url ?? "http://www.wowdsgn.com/"
        //微信好友
        UMSocialData.defaultData().extConfig.wxMessageType = UMSocialWXMessageTypeWeb
        UMSocialData.defaultData().extConfig.wechatSessionData.url = shareUrl
        UMSocialData.defaultData().extConfig.wechatSessionData.shareText = shareText ?? ""
        UMSocialData.defaultData().extConfig.wechatSessionData.shareImage = UIImage(named: "me_logo")
        UMSocialData.defaultData().extConfig.wechatSessionData.title = title ?? ""
        
        //朋友圈
        UMSocialData.defaultData().extConfig.wechatTimelineData.url = shareUrl
        UMSocialData.defaultData().extConfig.wechatTimelineData.shareText = shareText ?? ""
        UMSocialData.defaultData().extConfig.wechatTimelineData.shareImage = UIImage(named: "me_logo")
        UMSocialData.defaultData().extConfig.wechatTimelineData.title = title ?? ""
        
        //微博
        UMSocialData.defaultData().extConfig.sinaData.shareText = shareText ?? ""
        UMSocialData.defaultData().extConfig.sinaData.shareImage = UIImage(named: "me_logo")
        
        let vc = UIApplication.currentViewController()
        UMSocialSnsService.presentSnsIconSheetView(vc, appKey:WOWUMKey, shareText:shareText ?? "", shareImage:nil, shareToSnsNames: [UMShareToWechatTimeline,UMShareToWechatSession,UMShareToSina], delegate: nil)
    }
}