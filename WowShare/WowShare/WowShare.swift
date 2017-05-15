//
//  WowShare.swift
//  WowShare
//
//  Created by g on 2016/12/13.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import Foundation
import UMSocialCore
import UMSocialNetwork
import UShareUI

public typealias ShareSuccessClosure                = () -> ()
public typealias ShareFailClosure                   = (_ e:Error) -> ()

public class WowShare {
    
    public static func is_wx_installed() -> Bool{
        return WXApi.isWXAppInstalled()
    }
    public static func manual_init() {
        
        if let umm = UMSocialManager.default() {
            //打开日志
            umm.openLog(true)
            // 获取友盟social版本号
            print("UMeng social version: \(UMSocialGlobal.umSocialSDKVersion())")
            
            WXApi.registerApp(WowShareID.Wechat.appID)

            
            let is_installer = WowShare.is_wx_installed()
            print(">>>>>>检测微信安装 \(is_installer)")

            //设置友盟appkey
            umm.umSocialAppkey      = WowShareID.UMeng.appID
            //设置微信的appKey和appSecret
            umm.setPlaform(UMSocialPlatformType.wechatSession, appKey: WowShareID.Wechat.appID, appSecret: WowShareID.Wechat.appKey, redirectURL: WowShareID.UMeng.share_url)
            

            /*
             * 添加某一平台会加入平台下所有分享渠道，如微信：好友、朋友圈、收藏，QQ：QQ和QQ空间
             * 以下接口可移除相应平台类型的分享，如微信收藏，对应类型可在枚举中查找
             */
            //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
            // 设置分享到QQ互联的appID
            // U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
//            umm.setPlaform(UMSocialPlatformType.QQ, appKey: WowShareID.QQ.appID, appSecret: WowShareID.QQ.appKey, redirectURL: "http://mobile.umeng.com/social")
            
//            //设置新浪的appKey和appSecret
//            umm.setPlaform(UMSocialPlatformType.sina, appKey: "3921700954", appSecret: "04b48b094faeb16683c32669824ebdad", redirectURL: "http://sns.whalecloud.com/sina2/callback")
//            
//            //支付宝的appKey
//            umm.setPlaform(UMSocialPlatformType.alipaySession, appKey: "2015111700822536", appSecret: nil, redirectURL: "http://mobile.umeng.com/social")

        }else{
            print(">>>> WowShare Init Fail!")
        }
    }
    
    public static func handle_open_url(_ url:URL ) -> Bool {
        let result = UMSocialManager.default().handleOpen(url)
        return result
    }
    public static func share_WechatImg(url:String?,
                                              shareImage:Any!,
                                              successClosure:@escaping ShareSuccessClosure,
                                              failClosure:@escaping ShareFailClosure){
        var messageObject                       = UMSocialMessageObject()
        let shareObject:UMShareImageObject    = UMShareImageObject.init()
        
        
        shareObject.thumbImage = shareImage
        shareObject.shareImage = url
        messageObject.shareObject               = shareObject
        
        UMSocialManager.default().share(to: UMSocialPlatformType.wechatSession, messageObject: messageObject, currentViewController: self) { (shareResponse, error) in
            var message: String = ""
            if let e = error {
                
                failClosure(e )
            }else{
                
                successClosure()
            }
            
        }
    }

    public static func share_WechatFriendsImg(url:String?,
                                              shareImage:Any!,
                                              successClosure:@escaping ShareSuccessClosure,
                                              failClosure:@escaping ShareFailClosure){
        var messageObject                       = UMSocialMessageObject()
        let shareObject:UMShareImageObject    = UMShareImageObject.init()

    
        shareObject.thumbImage = shareImage
        shareObject.shareImage = url
         messageObject.shareObject               = shareObject
        
       UMSocialManager.default().share(to: UMSocialPlatformType.wechatTimeLine, messageObject: messageObject, currentViewController: self) { (shareResponse, error) in
            var message: String = ""
            if let e = error {
                
                failClosure(e )
            }else{
         
                successClosure()
            }

        }
    }
    public static func share_friends(
        _ title:String = "尖叫设计欢迎您",
        shareText:String?,
        url:String?,
        shareImage:Any!,
        successClosure:@escaping ShareSuccessClosure,
        failClosure:@escaping ShareFailClosure
    )
    {
        var messageObject                       = UMSocialMessageObject()
        let shareObject:UMShareWebpageObject    = UMShareWebpageObject.init()
        shareObject.title                       = title       //显不显示有各个平台定
        shareObject.descr                       = shareText   //显不显示有各个平台定
        shareObject.thumbImage                  = shareImage  //缩略图，显不显示有各个平台定
        shareObject.webpageUrl                  = url
        messageObject.shareObject               = shareObject
        
        UMSocialManager.default().share(
            to: UMSocialPlatformType.wechatTimeLine,
            messageObject: messageObject,
            currentViewController: self,
            completion: { (shareResponse, error) -> Void in
                
                var message: String = ""
                
                if let e = error {
                    failClosure(e )
                }else{
                    successClosure()
                }
    
            })
    }
    
    
    
    public static func share_text(
        _ title:String = "尖叫设计欢迎您",
        shareText:String?,
        url:String?,
        shareImage:Any!,
        successClosure:@escaping ShareSuccessClosure,
        failClosure:@escaping ShareFailClosure
    )
    {
        
        var messageObject                       = UMSocialMessageObject()
        let shareObject:UMShareWebpageObject    = UMShareWebpageObject.init()
        shareObject.title                       = title       //显不显示有各个平台定
        shareObject.descr                       = shareText   //显不显示有各个平台定
        shareObject.thumbImage                  = shareImage  //缩略图，显不显示有各个平台定
        shareObject.webpageUrl                  = url
        messageObject.shareObject               = shareObject
        
        UMSocialManager.default().share(
            to: UMSocialPlatformType.wechatSession,
            messageObject: messageObject,
            currentViewController: self,
            completion: { (shareResponse, error) -> Void in
                print(error.debugDescription)
                var message: String = ""
                if let e = error {
                    failClosure(e )
                }else{
                    successClosure()
                }

                
        })

    }
    
 
    
    public static func getAuthWithUserInfoFromWechat(  success_handler: @escaping (Any?) -> Void ){
        UMSocialManager.default().getUserInfo(with: UMSocialPlatformType.wechatSession, currentViewController: nil) { (result, error) in
            if error != nil {
                print("Share Fail with error ：%@", error)
            }else{
                let user: UMSocialUserInfoResponse = result as! UMSocialUserInfoResponse
                success_handler(user.originalResponse)
            }

           
        }
    }
    
    public static func cancle(  success_handler: @escaping (Any?) -> Void ){
        UMSocialManager.default().cancelAuth(with: UMSocialPlatformType.wechatSession) { (result, error) in
            if error != nil {
                print("Share Fail with error ：%@", error)
            }else{
                
                success_handler("sucess")
            }
        }
    
    }


}
