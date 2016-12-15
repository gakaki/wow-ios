////
////  ThirdPartyHelper.swift
////  Pods
////
////  Created by g on 2016/12/15.
////
////
//
//import Foundation
//
//public class ThirdPartyHelper{
//    
//    public static func registAppKey(_ launchOptions: [AnyHashable: Any]?){
//        //友盟分析
//        MobClick.setAppVersion(self.get_version_full())
//        UMAnalyticsConfig.sharedInstance().appKey = WOWID.UMeng.appID
//        UMAnalyticsConfig.sharedInstance().channelId = ""
//        MobClick.start(withConfigure: UMAnalyticsConfig.sharedInstance())
//        MobClick.setCrashReportEnabled(true)
//        
//        //友盟分享
//        UMSocialData.setAppKey(WOWID.UMeng.appID)
//        UMSocialWechatHandler.setWXAppId(WOWID.Wechat.appID, appSecret: WOWID.Wechat.appKey, url:"http://www.wowdsgn.com/")
//        
//        //友盟推送
//        umessage.init_umessage(launchOptions)
//        
//        WXApi.registerApp(WOWID.Wechat.appID)
//        
//        //Growing
//        Growing.start(withAccountId: "a04e14656f08dc7e")
//        //DeepShare
//        DeepShare.initWithAppID("e494427d3e67f207", withLaunchOptions: launchOptions, withDelegate: self)
//        //Talking Data
//        TalkingData.setExceptionReportEnabled(true)
//        TalkingData.sessionStarted("12430AB8C707826E0C0FBDA290E620E4", withChannelId: "AppStore")
//        
//        //Talking Data ADTracking
//        TalkingDataAppCpa.init("e81f26ce70664a9dab698bae55be2044", withChannelId: "AppStore")
//        
//        //        //MonkeyKing
//        //        MonkeyKing.registerAccount(.WeChat(appID: WOWID.Wechat.appID, appKey: WOWID.Wechat.appKey))
//        //        MonkeyKing.registerAccount(.Weibo(appID: WOWID.Weibo.appID, appKey: WOWID.Weibo.appKey, redirectURL: WOWID.Weibo.redirectURL))
//        
//        //LeanCloud
//        //        AVOSCloud.setApplicationId(WOWID.LeanCloud.appID, clientKey:WOWID.LeanCloud.appKey)
//        
//        //        //融云IM
//        //        RCIM.sharedRCIM().initWithAppKey(WOWID.RongCloud.appID)
//        //        RCIM.sharedRCIM().connectWithToken(WOWID.RongCloud.testToken,success: { (userId) -> Void in
//        //            DLog("登陆成功。当前登录的用户ID：\(userId)")
//        //            }, error: { (status) -> Void in
//        //                DLog("登陆的错误码为:\(status.rawValue)")
//        //            }, tokenIncorrect: {
//        //                //token过期或者不正确。
//        //                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
//        //                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
//        //                DLog("token错误")
//        //        })
//        
//        //shareSDK
//        
//        //        ShareSDK.registerApp(WOWID.ShareSDK.appKey,
//        //
//        //                             activePlatforms: [SSDKPlatformType.TypeWechat.rawValue,],
//        //                             onImport: {(platform : SSDKPlatformType) -> Void in
//        //
//        //                                switch platform{
//        //
//        //                                case SSDKPlatformType.TypeWechat:
//        //                                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
//        //
//        //                                default:
//        //                                    break
//        //                                }
//        //            },
//        //                             onConfiguration: {(platform : SSDKPlatformType,appInfo : NSMutableDictionary!) -> Void in
//        //                                switch platform {
//        //
//        //                                case SSDKPlatformType.TypeWechat:
//        //                                    //设置微信应用信息
//        //                                    appInfo.SSDKSetupWeChatByAppId(WOWID.Wechat.appID, appSecret: WOWID.Wechat.appKey)
//        //
//        //                                default:
//        //                                    break
//        //
//        //                                }
//        //        })
//        
//        
//        
//    }
//
//    
//    
//    
//}
//
//
