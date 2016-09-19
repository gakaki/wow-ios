//
//  WOWShareManager.swift
//  WowDsgn
//
//  Created by 小黑 on 16/5/5.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import Foundation
//import MonkeyKing
struct WOWShareManager {
    
    static let vc = UIApplication.currentViewController()
    
    static var shareBackView = WOWShareBackView(frame:CGRectMake(0, 0,MGScreenWidth,  MGScreenHeight))
    

    static func share(title:String?,shareText:String?,url:String?,shareImage:UIImage = UIImage(named: "me_logo")!){

        shareBackView.show()

        shareBackView.shareActionBack = {(shareType:WOWShareType)in
            switch shareType {
            case .friends:
                UMSocialData.defaultData().extConfig.wechatTimelineData.title = title
                UMSocialData.defaultData().extConfig.wechatTimelineData.url = url

                UMSocialDataService.defaultDataService().postSNSWithTypes([UMShareToWechatTimeline], content: shareText, image: shareImage, location: nil, urlResource: nil, presentedController: UIApplication.currentViewController(), completion: { response in
                    if response.responseCode == UMSResponseCodeSuccess {
                        
                    }
                })
               
            case .wechat:
                
                UMSocialData.defaultData().extConfig.wechatSessionData.title = title
                UMSocialData.defaultData().extConfig.wechatSessionData.url = url

                UMSocialDataService.defaultDataService().postSNSWithTypes([UMShareToWechatSession], content: shareText, image: shareImage, location: nil, urlResource: nil, presentedController: UIApplication.currentViewController(), completion: { response in
                    if response.responseCode == UMSResponseCodeSuccess {
                        
                    }
                })

                return
            }

        }
    }
}
