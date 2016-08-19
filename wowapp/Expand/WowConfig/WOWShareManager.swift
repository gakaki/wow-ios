//
//  WOWShareManager.swift
//  WowDsgn
//
//  Created by 小黑 on 16/5/5.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import Foundation
import MonkeyKing
struct WOWShareManager {
    
    static let vc = UIApplication.currentViewController()
    
    static var shareBackView = WOWShareBackView(frame:CGRectMake(0, 0, vc?.view.w ?? MGScreenWidth, vc?.view.h ?? MGScreenHeight))
    

    static func share(title:String?,shareText:String?,url:String?,shareImage:UIImage = UIImage(named: "me_logo")!){

        shareBackView.show()
        let urlResoure = UMSocialUrlResource.init(snsResourceType: UMSocialUrlResourceTypeWeb, url: url)
        shareBackView.shareActionBack = {(shareType:WOWShareType)in
            switch shareType {
            case .friends:
                UMSocialData.defaultData().extConfig.wechatTimelineData.title = title
                
                UMSocialDataService.defaultDataService().postSNSWithTypes([UMShareToWechatTimeline], content: shareText, image: shareImage, location: nil, urlResource: urlResoure, presentedController: UIApplication.currentViewController(), completion: { response in
                    if response.responseCode == UMSResponseCodeSuccess {
                        
                    }
                })
               
            case .wechat:
                
                UMSocialData.defaultData().extConfig.wechatSessionData.title = title

                UMSocialDataService.defaultDataService().postSNSWithTypes([UMShareToWechatSession], content: shareText, image: shareImage, location: nil, urlResource: urlResoure, presentedController: UIApplication.currentViewController(), completion: { response in
                    if response.responseCode == UMSResponseCodeSuccess {
                        
                    }
                })

                return
            }

        }
    }
}
