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
    /**
     跳转登录界面
     
     - parameter isPresent: true：present跳转 false：push跳转
     */
    func toLoginVC(isPresent:Bool = false){

        if isPresent {
            let vc = UIStoryboard.initialViewController("Login", identifier: "WOWLoginNavController") as! WOWNavigationController
            let login = vc.topViewController as! WOWLoginController
            login.isPresent = isPresent
            presentViewController(vc, animated: true, completion: nil)

        }else {
            let vc = UIStoryboard.initialViewController("Login", identifier:String(WOWLoginController)) as! WOWLoginController
            vc.isPresent = isPresent
            self.pushVC( vc )
        }
        
        
    }
    /**
     跳转登录界面 点击叉号返回 导航控制器根视图
     
     - parameter isPresent: true：present跳转 false：push跳转
     */
    func toLoginVCPopRootVC(isPresent:Bool = false){
        
        if isPresent {
            let vc = UIStoryboard.initialViewController("Login", identifier: "WOWLoginNavController") as! WOWNavigationController
            let login = vc.topViewController as! WOWLoginController
            login.isPresent = isPresent
            login.isPopRootVC = true
            presentViewController(vc, animated: true, completion: nil)
            
        }else {
            let vc = UIStoryboard.initialViewController("Login", identifier:String(WOWLoginController)) as! WOWLoginController
            vc.isPresent = isPresent
            self.pushVC( vc )
        }
        
        
    }

    //跳转注册/绑定微信界面需要传从哪跳转来的
    func toRegVC(fromWechat:Bool = false , isPresent:Bool = false,userInfoFromWechat:NSDictionary?){
        
        let vc = UIStoryboard.initialViewController("Login", identifier:String(WOWRegistController)) as! WOWRegistController
        vc.isPresent = isPresent
        vc.byWechat = fromWechat
        vc.userInfoFromWechat = userInfoFromWechat
        self.pushVC( vc )
    }
    //跳转微信登录界面
    func toWeixinVC(isPresent:Bool = false){
        print("toWeixinVC")
                let snsPlat = UMSocialSnsPlatformManager.getSocialPlatformWithName(UMShareToWechatSession)
//                UMSocialControllerService.defaultControllerService().socialUIDelegate = self
                snsPlat.loginClickHandler(self, UMSocialControllerService.defaultControllerService(), true, {[weak self]response in
                    if let strongSelf = self{
                        if response.responseCode == UMSResponseCodeSuccess {
//                            let snsAccount:UMSocialAccountEntity = UMSocialAccountManager.socialAccountDictionary()[UMShareToWechatSession] as! UMSocialAccountEntity
                  
                            
                            strongSelf.checkWechatToken(response.thirdPlatformUserProfile as! NSDictionary, isPresent: isPresent)
                        }else{
                            WOWHud.showMsg("授权登录失败")
                        }
                    }
                })
        /**
         shareSDK第三方登录
         */
//        ShareSDK.getUserInfo(SSDKPlatformType.TypeWechat) { [weak self](state:SSDKResponseState, userData:SSDKUser!, error:NSError!) -> Void in
//            if let strongSelf = self{
//                switch state{
//                    
//                case SSDKResponseState.Success:
//                    print("获取授权成功")
//                    print(userData)
//                    print(userData.rawData)
//                    strongSelf.checkWechatToken(userData, isPresent: isPresent)
//                    
//                case SSDKResponseState.Fail:
//                    print("授权失败,错误描述:\(error)")
//                    
//                case SSDKResponseState.Cancel:
//                    print("授权取消")
//                    
//                default:
//                    break
//                }
//            }
//            
//        }
        
    }
    private func checkWechatToken(userData:NSDictionary,isPresent:Bool = false){
        //FIXME:验证token是否是第一次咯或者是第二次
        var isOpenIdBinded = Bool()//假设的bool值
        WOWNetManager.sharedManager.requestWithTarget(.Api_Wechat(openId:(userData["openid"] ?? "") as! String), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                let json = JSON(result)
                DLog(json)
                isOpenIdBinded = JSON(result)["isOpenIdBinded"].bool ?? true
                
                if isOpenIdBinded {
                    //FIXME:未写的，先保存用户信息
                    let model = Mapper<WOWUserModel>().map(result)
                    WOWUserManager.saveUserInfo(model)
                    strongSelf.toLoginSuccess(isPresent)
                    
                }else{ //第一次登陆
                    strongSelf.toRegVC(true,isPresent: isPresent,userInfoFromWechat: userData)
                }
            }
        }) {[weak self] (errorMsg) in
            if let _ = self{
                
            }
        }
        
        
    }
    
    //登录成功方法
    func toLoginSuccess(isPresent:Bool = false){
//        WOWBuyCarMananger.updateBadge(true)
        NSNotificationCenter.postNotificationNameOnMainThread(WOWUpdateCarBadgeNotificationKey, object: nil)
        NSNotificationCenter.postNotificationNameOnMainThread(WOWLoginSuccessNotificationKey, object: nil)
        if isPresent{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64( 0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                self.dismissViewControllerAnimated(true, completion: nil)
//                UIApplication.appTabBarController.selectedIndex = 0
            })
        }else {
            //进入首页
            toMainVC()
        }
    }

    func toRegInfo(isPresent:Bool = false) {
        NSNotificationCenter.postNotificationNameOnMainThread(WOWLoginSuccessNotificationKey, object: nil)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64( 0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            let vc = UIStoryboard.initialViewController("Login", identifier:"WOWRegistInfoFirstController") as! WOWRegistInfoFirstController
            vc.isPresent = isPresent
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
    }
    func toReg2ndVC(){
        
    }

    
    func toVCCategoryChoose(){
        let vc          = VCCategoryChoose()
//        vc.cid          = cid.toString
        self.pushVC(vc)
    }

    
    func toVCCategory( cid: String? = "10" , cname:String? ){
        let vc      = UIStoryboard.initialViewController(StoryBoardNames.Found.rawValue, identifier: String(VCCategory)) as! VCCategory
        vc.cid      = cid!
        vc.title    = cname!
        self.pushVC(vc)
    }
    
    
    func toVCProduct( pid: Int? ){
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWProductDetailController)) as! WOWProductDetailController
        vc.hideNavigationBar = true
        vc.productId = pid
        self.pushVC(vc)
    }
    
    
    func toVCCart( ){
        guard WOWUserManager.loginStatus else {
            toLoginVC(true)
            return
        }
        let vc = UIStoryboard.initialViewController("BuyCar", identifier:String(WOWBuyCarController)) as! WOWBuyCarController
        vc.hideNavigationBar = false
        pushVC(vc)
    }
    
    
    func toVCTopic( topic_id:Int? ){
        if let t = topic_id {
            let vc                  = VCTopic(nibName: nil, bundle: nil)
            vc.topic_id             = t
            vc.hideNavigationBar    = true
            self.pushVC(vc)
        }
        
    }
    // 跳转专题详情页
    func toVCTopidDetail( topic_id:Int? ){
        
        let vc = UIStoryboard.initialViewController("HotStyle", identifier:String(WOWContentTopicController)) as! WOWContentTopicController
        //                vc.hideNavigationBar = true
        vc.topic_id = topic_id ?? 0
        navigationController?.pushViewController(vc, animated: true)

    }

}
