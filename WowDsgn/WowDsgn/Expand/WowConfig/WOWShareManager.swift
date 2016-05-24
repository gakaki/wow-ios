//
//  WOWShareManager.swift
//  WowDsgn
//
//  Created by 小黑 on 16/5/5.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import Foundation

struct WOWShareManager {
    static var sharePlatForm = UMShareToQQ
    static let vc = UIApplication.currentViewController()

    static var shareBackView = WOWShareBackView(frame:CGRectMake(0, 0, vc?.view.w ?? MGScreenWidth, vc?.view.h ?? MGScreenHeight))
    
    static func share(title:String?,shareText:String?,url:String?,shareImage:UIImage = UIImage(named: "me_logo")!){
        let shareUrl = url ?? "http://www.wowdsgn.com/"
        //微信好友
        UMSocialData.defaultData().extConfig.wxMessageType = UMSocialWXMessageTypeWeb
        UMSocialData.defaultData().extConfig.wechatSessionData.url = shareUrl
        UMSocialData.defaultData().extConfig.wechatSessionData.shareText = shareText ?? ""
        UMSocialData.defaultData().extConfig.wechatSessionData.shareImage = shareImage
        UMSocialData.defaultData().extConfig.wechatSessionData.title = (title ?? "")  + "-尖叫设计"
        
        //朋友圈
        UMSocialData.defaultData().extConfig.wechatTimelineData.url = shareUrl
        UMSocialData.defaultData().extConfig.wechatTimelineData.shareText = shareText ?? ""
        UMSocialData.defaultData().extConfig.wechatTimelineData.shareImage = shareImage
        UMSocialData.defaultData().extConfig.wechatTimelineData.title = (title ?? "")  + "-尖叫设计"
        
        //微博
        UMSocialData.defaultData().extConfig.sinaData.shareText = shareText ?? ""
        UMSocialData.defaultData().extConfig.sinaData.shareImage = shareImage
        shareBackView.show()
        
        shareBackView.shareActionBack = {(shareType:WOWShareType)in
            switch shareType {
            case .friends:
                sharePlatForm = UMShareToWechatTimeline
            case .wechat:
                sharePlatForm = UMShareToWechatSession
            case .weibo:
                sharePlatForm = UMShareToSina
            }
            UMSocialDataService.defaultDataService().postSNSWithTypes([sharePlatForm], content: shareText ?? "", image: shareImage, location: nil, urlResource: UMSocialUrlResource(snsResourceType: UMSocialUrlResourceTypeWeb, url:shareUrl), presentedController: vc, completion: { (ret) in
                if ret.responseCode == UMSResponseCodeSuccess{
                    DLog("分享成功")
                }
            })
        }
        
//        let vc = UIApplication.currentViewController()
//        UMSocialSnsService.presentSnsIconSheetView(vc, appKey:WOWUMKey, shareText:shareText ?? "", shareImage:shareImage, shareToSnsNames: [UMShareToWechatTimeline,UMShareToWechatSession,UMShareToSina], delegate: nil)
    }
}