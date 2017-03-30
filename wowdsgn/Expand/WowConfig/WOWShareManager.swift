//
//  WOWShareManager.swift
//  WowDsgn
//
//  Created by 小黑 on 16/5/5.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import Foundation
//import MonkeyKing
import WowShare

struct WOWShareManager {
    
    static let vc = UIApplication.currentViewController()
    
    static var shareBackView = WOWShareBackView(frame:CGRect(x: 0, y: 0, w: MGScreenWidth, h: MGScreenHeight))
    

    static func share(_ title:String?,shareText:String?,url:String?,shareImage:Any!){
        shareBackView.show()
        let shareNewText = "尖叫设计，生活即风格－600元新人礼包等你来拿！"
        shareBackView.shareActionBack = {(shareType:WOWShareType)in
            switch shareType {
            case .friends:
                
                WowShare.share_friends(title ?? "", shareText: shareNewText, url: url, shareImage: shareImage, successClosure: {
                    WOWHud.showMsg("分享成功")
                },
                    failClosure: { e in
                        share_cancel_deal(e)
                })
//                WowShare.share_WechatFriendsImg()
//                WowShare.share_WechatFriendsImg()
                
               return
            case .wechat:
                
                WowShare.share_text(title ?? "", shareText: shareNewText, url: url, shareImage: shareImage, successClosure: {
                        WOWHud.showMsg("分享成功")
                },
                 failClosure: { e in
                                        share_cancel_deal(e)
                })
               

                return
            }
        
            

        }
    }
    

    
    public static func share_cancel_deal(_ error: Swift.Error){
        
        var message: String = ""
        print("Share Fail with error ：%@", error)
        message = "失败原因Code: \(error) , 用户手动取消"
        message = "分享失败"
        let alert = UIAlertView(title: "share", message: message, delegate: nil, cancelButtonTitle: "确定")
        //最好这里能打点记录下
        alert.show()
    }
 
    
    public static func sharePhoto(_ title:String,shareText:String,url:String?,shareImage:Any!){
        shareBackView.showPhotoImg(img: shareImage as! String ,des: shareText, nikeName: title)
        
        let pushlishImg = shareBackView.sharePhotoView.createViewImage()
        var  pushLishUrl = ""
       
        
        
        shareBackView.shareActionBack = {(shareType:WOWShareType)in
            
            WOWUploadManager.uploadShareImg(pushlishImg, successClosure: { (url) in
                pushLishUrl = url!
                
                switch shareType {
                case .friends:
                    
                    WowShare.share_WechatFriendsImg(url: pushLishUrl, shareImage: pushlishImg, successClosure: {
                        
                        WOWHud.showMsg("分享成功")
                        
                    }, failClosure: { (e) in
                        
                        share_cancel_deal(e)
                        
                    })
                    
                    return
                case .wechat:
                    
                    WowShare.share_WechatImg(url: pushLishUrl, shareImage: pushlishImg, successClosure: {
                        WOWHud.showMsg("分享成功")
                    }, failClosure: { (e) in
                        share_cancel_deal(e)
                    })
                    
                    return
                }

            }) { (error) in
                print("shibai")
            }
            
            
        }
    }

    
    public static func shareUrl(_ title:String?,shareText:String?,url:String?,shareImage:Any!){
        shareBackView.show()
      
        shareBackView.shareActionBack = {(shareType:WOWShareType)in
            switch shareType {
            case .friends:

                WowShare.share_friends(title ?? "", shareText: shareText, url: url, shareImage: shareImage, successClosure: {
                        WOWHud.showMsg("分享成功")
                    },
                    failClosure: { e in
                        share_cancel_deal(e)
                    })
               
                
                return
            case .wechat:
                
                WowShare.share_text(title ?? "", shareText: shareText, url: url, shareImage: shareImage, successClosure: {
                    WOWHud.showMsg("分享成功")

                },
                failClosure: { e in
                    share_cancel_deal(e)
                })

                return
            }
            
        }
    }
}
