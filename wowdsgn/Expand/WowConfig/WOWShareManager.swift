//
//  WOWShareManager.swift
//  WowDsgn
//
//  Created by 小黑 on 16/5/5.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import Foundation

import WowShare
struct WOWCustomerNeedHelp {
    
    static let vc = UIApplication.currentViewController()
    static var shareBackView = WOWShareBackView(frame:CGRect(x: 0, y: 0, w: MGScreenWidth, h: MGScreenHeight))
    static func show(_ orderNumber:String,title:String = "订单详情"){
        
        shareBackView.showNeedHelp()

        shareBackView.shareActionBack = {(shareType:WOWShareType)in
            switch shareType {
            case .needPhone:
                if title == "确认订单" {
                    MobClick.e(.customer_service_phone_edit_order)
                }
                if title == "订单详情" {
                    MobClick.e(.customer_service_phone_order_detail)
                }
                WOWTool.callPhone()
                return
            case .needCustomer:
                if title == "确认订单" {
                    MobClick.e(.online_customer_service_edit_order)
                }
                if title == "订单详情" {
                    MobClick.e(.online_customer_service_order_detail)
                }
                let source = QYSource()
                source.title =  title
                VCRedirect.goCustomerVC(source, commodityInfo: nil,orderNumber:orderNumber)
                
                return
            default:break
            }
           
        }
    }
    
}
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

                
               return
            case .wechat:
                
                WowShare.share_text(title ?? "", shareText: shareNewText, url: url, shareImage: shareImage, successClosure: {
                        WOWHud.showMsg("分享成功")
                },
                 failClosure: { e in
                                        share_cancel_deal(e)
                })
               

                return
                default:break
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
 
    
    public static func sharePhoto(_ m: WOWWorksDetailsModel){
//        WOWShareManager.sharePhoto(self.modelData?.nickName ?? "", shareText: self.modelData?.des ?? "", url: "", shareImage: self.modelData?.pic ?? "")
        MobClick.e(.sharepicture_popup)
        shareBackView.showPhotoImg(m)
        
        let pushlishImg = shareBackView.sharePhotoView.createViewImage()
        var  pushLishUrl = ""
       
        
        
        shareBackView.shareActionBack = {(shareType:WOWShareType)in
            
            WOWUploadManager.uploadShareImg(pushlishImg, successClosure: { (url) in
                pushLishUrl = url!
                
                switch shareType {
                case .friends:
                    MobClick.e(.moments_clicks_sharing_page)
                    WowShare.share_WechatFriendsImg(url: pushLishUrl, shareImage: pushlishImg, successClosure: {
                        
                        WOWHud.showMsg("分享成功")
                        
                    }, failClosure: { (e) in
                        
                        share_cancel_deal(e)
                        
                    })
                    
                    return
                case .wechat:
                    MobClick.e(.wx_friends_clicks_sharing_page)
                    WowShare.share_WechatImg(url: pushLishUrl, shareImage: pushlishImg, successClosure: {
                        WOWHud.showMsg("分享成功")
                    }, failClosure: { (e) in
                        share_cancel_deal(e)
                    })
                    
                    return
                default:break
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
            default:break
            }
            
            
        }
    }
}
