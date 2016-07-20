//
//  WowVCManager.swift
//  wowapp
//
//  Created by g on 16/7/14.
//  Copyright © 2016年 小黑. All rights reserved.
//

//VCManager is collect the redirect code
import UIKit

extension  UIViewController {
    
    func toMainVC(){
        let mainVC = UIStoryboard(name: "Main", bundle:NSBundle.mainBundle()).instantiateInitialViewController()
        mainVC?.modalTransitionStyle = .FlipHorizontal
        AppDelegate.rootVC = mainVC
        self.presentViewController(mainVC!, animated: true, completion: nil)
    }
    //跳转登录界面需要传从哪跳转来的true：个人中心 false：其他
    func toLoginVC(fromUserCenter:Bool = false){
//        let mainVC = UIStoryboard(name: "Login", bundle:NSBundle.mainBundle()).instantiateInitialViewController()
//        mainVC?.modalTransitionStyle = .FlipHorizontal
//        AppDelegate.rootVC = mainVC
//        self.presentViewController(mainVC!, animated: true, completion: nil)
        
        let vc = UIStoryboard.initialViewController("Login", identifier:String(WOWLoginController)) as! WOWLoginController
        vc.fromUserCenter = fromUserCenter
        self.pushVC( vc )
    }
    //跳转注册/绑定微信界面需要传从哪跳转来的
    func toRegVC(fromWechat:Bool = false , fromUserCenter:Bool = false){
        
        let vc = UIStoryboard.initialViewController("Login", identifier:String(WOWRegistController)) as! WOWRegistController
        vc.fromUserCenter = fromUserCenter
        vc.byWechat = fromWechat
        self.pushVC( vc )
    }
    //跳转微信登录界面
    func toWeixinVC(fromUserCenter:Bool = false){
        print("toWeixinVC")
        /**
         shareSDK第三方登录
         */
        ShareSDK.getUserInfo(SSDKPlatformType.TypeWechat) { [weak self](state:SSDKResponseState, userData:SSDKUser!, error:NSError!) -> Void in
            if let strongSelf = self{
                switch state{
                    
                case SSDKResponseState.Success:
                    print("获取授权成功")
                    print(userData)
                    strongSelf.checkWechatToken(userData.uid)
                    
                case SSDKResponseState.Fail:
                    print("授权失败,错误描述:\(error)")
                    
                case SSDKResponseState.Cancel:
                    print("授权取消")
                    
                default:
                    break
                }
            }
            
        }
        
    }
    private func checkWechatToken(token:String?,fromUserCenter:Bool = false){
        //FIXME:验证token是否是第一次咯或者是第二次
        WOWUserManager.wechatToken = token ?? ""
        var first = Bool(true)//假设的bool值
        WOWNetManager.sharedManager.requestWithTarget(.Api_Wechat(openId:WOWUserManager.wechatToken), successClosure: {[weak self] (result) in
            if let _ = self{
                DLog(result)
            }
        }) {[weak self] (errorMsg) in
            if let _ = self{
                
            }
        }
        
        if first {
            toRegVC(true,fromUserCenter: fromUserCenter)
        }else{ //二次登录，拿到用户信息，这时候算是登录成功咯
            //FIXME:未写的，先保存用户信息
            toLoginSuccess()
        }
    }
    //登录成功方法
    func toLoginSuccess(fromUserCenter:Bool = false){
        WOWBuyCarMananger.updateBadge(true)
        NSNotificationCenter.postNotificationNameOnMainThread(WOWLoginSuccessNotificationKey, object: nil)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64( 0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.dismissViewControllerAnimated(true, completion: nil)
            if fromUserCenter{
                UIApplication.appTabBarController.selectedIndex = 0
            }
        })
    }

    
    func toReg2ndVC(){
        
    }

}
