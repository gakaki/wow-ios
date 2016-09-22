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
    
    static var shareBackView = WOWShareBackView(frame:CGRect(x: 0, y: 0, w: MGScreenWidth, h: MGScreenHeight))
    

    static func share(_ title:String?,shareText:String?,url:String?,shareImage:UIImage = UIImage(named: "me_logo")!){
        shareBackView.show()

        shareBackView.shareActionBack = {(shareType:WOWShareType)in
            switch shareType {
            case .friends:
                UMSocialData.default().extConfig.wechatTimelineData.title = title
                UMSocialData.default().extConfig.wechatTimelineData.url = url

                UMSocialDataService.default().postSNS(withTypes: [UMShareToWechatTimeline], content: shareText, image: shareImage, location: nil, urlResource: nil, presentedController: UIApplication.currentViewController(), completion: { response in
                    if response?.responseCode == UMSResponseCodeSuccess {
                        
                    }
                })
               
            case .wechat:
                
                UMSocialData.default().extConfig.wechatSessionData.title = title
                UMSocialData.default().extConfig.wechatSessionData.url = url

                UMSocialDataService.default().postSNS(withTypes: [UMShareToWechatSession], content: shareText, image: shareImage, location: nil, urlResource: nil, presentedController: UIApplication.currentViewController(), completion: { response in
                    if response?.responseCode == UMSResponseCodeSuccess {
                        
                    }
                })

                return
            }

        }
    }
}
