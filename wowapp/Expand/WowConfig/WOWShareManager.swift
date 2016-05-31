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
    
    static var accessToken: String?
    
    static let weiboAccount = MonkeyKing.Account.Weibo(appID: WOWID.Weibo.appID, appKey: WOWID.Weibo.appKey, redirectURL: WOWID.Weibo.redirectURL)
    
    static let wxAccount    = MonkeyKing.Account.WeChat(appID: WOWID.Wechat.appID, appKey: WOWID.Wechat.appKey)
    
    
    static func share(title:String?,shareText:String?,url:String?,shareImage:UIImage = UIImage(named: "me_logo")!){
        let postTitle = (title ?? "")  + "-尖叫设计"
        var postDes = ""
        if shareText?.length > 100 {
            let index = shareText?.startIndex.advancedBy(100)
            postDes   = (shareText?.substringToIndex(index!) ?? "") + "......"
        }else{
            postDes   = shareText ?? ""
        }
        let postUrl   = url ?? "http://www.wowdsgn.com/"
        let postImage = shareImage
        let info =  MonkeyKing.Info(
            title: postTitle,
            description: postDes,
            thumbnail: postImage,
            media: .URL(NSURL(string:postUrl)!)
        )
        shareBackView.show()
        shareBackView.shareActionBack = {(shareType:WOWShareType)in
            var message : MonkeyKing.Message?
            switch shareType {
            case .friends,.wechat:
                if !wxAccount.isAppInstalled {
                    WOWHud.showMsg("暂未安装微信客户端")
                    return
                }
            default:
                break
            }
            
            switch shareType {
            case .friends:
                message = MonkeyKing.Message.WeChat(.Timeline(info:info))
            case .wechat:
                message = MonkeyKing.Message.WeChat(.Session(info:info))
            case .weibo:
                if !weiboAccount.isAppInstalled {
                    MonkeyKing.OAuth(.Weibo, completionHandler: {(dictionary, response, error) -> Void in
                        if let json = dictionary, accessToken = json["access_token"] as? String {
                            self.accessToken = accessToken
                        }
                        print("dictionary \(dictionary) error \(error)")
                    })
                }
                
                let message = MonkeyKing.Message.Weibo(.Default(info:(
                    title: postTitle,
                    description: postDes,
                    thumbnail: UIImage(named: "me_logo"),
                    media: .URL(NSURL(string:postUrl)!)
                    ), accessToken: accessToken))
                MonkeyKing.shareMessage(message) { result in
                    print("result: \(result)")
                }
                return
            }
            if  let message = message {
                MonkeyKing.shareMessage(message) { result in
                    print("result: \(result)")
                }
            }
        }
    }
}
