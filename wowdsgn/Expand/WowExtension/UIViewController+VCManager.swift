 
 //
//  WowVCManager.swift
//  wowapp
//
//  Created by g on 16/7/14.
//  Copyright © 2016年 小黑. All rights reserved.
//

//VCManager is collect the redirect code
import UIKit
import wow3rd
 
public class VCRedirect {
    
    public class var topNaVC : UINavigationController? {
        
        get {
            let topViewController = FNUtil.currentTopViewController()
            let navigation = topViewController.navigationController
            return navigation
        }
    }
    
    public class func vc_show(vc:UIViewController) {
        
        let topViewController = FNUtil.currentTopViewController()
        if (topViewController.navigationController != nil)  {
            let navigation = topViewController.navigationController
            navigation?.pushViewController(vc, animated: true)
        }
        else {
            topViewController.present(vc, animated: true, completion: nil)
        }
        
    }

    
    public class  func toLoginVC(_ isPresent:Bool = false){
        
        if isPresent {
            let vc = UIStoryboard.initialViewController("Login", identifier: "WOWLoginNavController") as! WOWNavigationController
            let login = vc.topViewController as! WOWLoginController
            login.isPresent = isPresent
            
            topNaVC?.present(vc, animated: true, completion: nil)
            
        }else {
            let vc = UIStoryboard.initialViewController("Login", identifier:String(describing: WOWLoginController.self)) as! WOWLoginController
            vc.isPresent = isPresent
            topNaVC?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    public class func toOrderList(){
        guard WOWUserManager.loginStatus else{
            toLoginVC(true)
            return
        }
        
        MobClick.e(.My_Coupons)
        let vc = UIStoryboard.initialViewController("User", identifier: "WOWCouponController") as! WOWCouponController
        vc.entrance = couponEntrance.userEntrance
        
        topNaVC?.pushViewController(vc, animated: true)

    }
    public class func toCouponVC(){
        guard WOWUserManager.loginStatus else{
            toLoginVC(true)
            return
        }
        
        MobClick.e(.My_Coupons)
        let vc = UIStoryboard.initialViewController("User", identifier: "WOWCouponController") as! WOWCouponController
        vc.entrance = couponEntrance.userEntrance
        
        topNaVC?.pushViewController(vc, animated: true)
    }

    
    
 }
extension  UIViewController {
    func toMainVC(){
        let mainVC = UIStoryboard(name: "Main", bundle:Bundle.main).instantiateInitialViewController()
        mainVC?.modalTransitionStyle = .flipHorizontal
        AppDelegate.rootVC = mainVC
        self.present(mainVC!, animated: true, completion: nil)
    }
    /**
     跳转登录界面
     
     - parameter isPresent: true：present跳转 false：push跳转
     */
    func toLoginVC(_ isPresent:Bool = false){

        if isPresent {
            let vc = UIStoryboard.initialViewController("Login", identifier: "WOWLoginNavController") as! WOWNavigationController
            let login = vc.topViewController as! WOWLoginController
            login.isPresent = isPresent
            present(vc, animated: true, completion: nil)

        }else {
            let vc = UIStoryboard.initialViewController("Login", identifier:String(describing: WOWLoginController.self)) as! WOWLoginController
            vc.isPresent = isPresent
            self.pushVC( vc )
        }
        
        
    }
    /**
     跳转登录界面 点击叉号返回 导航控制器根视图
     
     - parameter isPresent: true：present跳转 false：push跳转
     */
    func toLoginVCPopRootVC(_ isPresent:Bool = false){
        
        if isPresent {
            let vc = UIStoryboard.initialViewController("Login", identifier: "WOWLoginNavController") as! WOWNavigationController
            let login = vc.topViewController as! WOWLoginController
            login.isPresent = isPresent
            login.isPopRootVC = true
            present(vc, animated: true, completion: nil)
            
        }else {
            let vc = UIStoryboard.initialViewController("Login", identifier:String(describing: WOWLoginController.self)) as! WOWLoginController
            vc.isPresent = isPresent
            self.pushVC( vc )
        }
        
        
    }

    //跳转注册/绑定微信界面需要传从哪跳转来的
    func toRegVC(_ fromWechat:Bool = false , isPresent:Bool = false,userInfoFromWechat:NSDictionary?){
        
        let vc = UIStoryboard.initialViewController("Login", identifier:String(describing: WOWRegistController.self)) as! WOWRegistController
        vc.isPresent = isPresent
        vc.byWechat = fromWechat
        vc.userInfoFromWechat = userInfoFromWechat
        self.pushVC( vc )
    }
    //跳转微信登录界面
    func toWeixinVC(_ isPresent:Bool = false){
        print("toWeixinVC")
                let snsPlat = UMSocialSnsPlatformManager.getSocialPlatform(withName: UMShareToWechatSession)
//                UMSocialControllerService.defaultControllerService().socialUIDelegate = self
                snsPlat?.loginClickHandler(self, UMSocialControllerService.default(), true, {[weak self]response in
                    if let strongSelf = self{
                        if response?.responseCode == UMSResponseCodeSuccess {
//                            let snsAccount:UMSocialAccountEntity = UMSocialAccountManager.socialAccountDictionary()[UMShareToWechatSession] as! UMSocialAccountEntity
                  
                            
                            strongSelf.checkWechatToken(response?.thirdPlatformUserProfile as! NSDictionary, isPresent: isPresent)
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
    fileprivate func checkWechatToken(_ userData:NSDictionary,isPresent:Bool = false){
        //FIXME:验证token是否是第一次咯或者是第二次
        var isOpenIdBinded = Bool()//假设的bool值
        let open_id        = (userData["openid"] ?? "") as! String
        let unionid        = (userData["unionid"] ?? "") as! String
        print(userData)
        WOWNetManager.sharedManager.requestWithTarget(.api_Wechat(openId:open_id, unionId: unionid), successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                let json = JSON(result)
                DLog(json)
                isOpenIdBinded = JSON(result)["isOpenIdBinded"].bool ?? true
                
                //微信登录成功
                TalkingDataAppCpa.onLogin("wechatUser_\(open_id)")
                
                if isOpenIdBinded {
                    //FIXME:未写的，先保存用户信息
                    let model = Mapper<WOWUserModel>().map(JSONObject:result)
                    WOWUserManager.saveUserInfo(model)
                    
                    TalkingDataAppCpa.onLogin("wechatUser_\(WOWUserManager.WOWUserID)")

                    strongSelf.toLoginSuccess(isPresent)
                    
                }else{ //第一次登陆
                    
                    TalkingDataAppCpa.onLogin("wechatUser_\(WOWUserManager.WOWUserID)")

                    strongSelf.toRegVC(true,isPresent: isPresent,userInfoFromWechat: userData)
                }
            }
        }) {[weak self] (errorMsg) in
            if let _ = self{
                
            }
        }
        
        
    }
    
    //登录成功方法
    func toLoginSuccess(_ isPresent:Bool = false){
//        WOWBuyCarMananger.updateBadge(true)
        NotificationCenter.postNotificationNameOnMainThread(WOWUpdateCarBadgeNotificationKey, object: nil)
        NotificationCenter.postNotificationNameOnMainThread(WOWLoginSuccessNotificationKey, object: nil)
        if isPresent{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64( 0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self.dismiss(animated: true, completion: nil)
//                UIApplication.appTabBarController.selectedIndex = 0
            })
        }else {
            //进入首页
            toMainVC()
        }
    }

    func toRegInfo(_ isPresent:Bool = false) {
        NotificationCenter.postNotificationNameOnMainThread(WOWLoginSuccessNotificationKey, object: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64( 0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
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

    
    func toVCCategory( _ cid: Int = 10 , cname:String? ){
        
            let vc              = UIStoryboard.initialViewController(StoryBoardNames.Found.rawValue, identifier: String(describing: VCCategory.self)) as! VCCategory
            vc.ob_cid.value     = cid
            vc.title    = cname!
            self.pushVC(vc)

    }
    
    
    func toVCProduct( _ pid: Int? ){
        let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWProductDetailController.self)) as! WOWProductDetailController
        vc.hideNavigationBar = true
        vc.productId = pid
        self.pushVC(vc)
    }
    
    
    func toVCCart( ){
        
        
        guard WOWUserManager.loginStatus else {
            toLoginVC(true)
            return
        }
        let vc = UIStoryboard.initialViewController("BuyCar", identifier:String(describing: WOWBuyCarController.self)) as! WOWBuyCarController
        vc.hideNavigationBar = false
        pushVC(vc)
    }
    
    
    func toVCTopic( _ topic_id:Int? ){
        if let t = topic_id {
            let vc                  = VCTopic(nibName: nil, bundle: nil)
            vc.topic_id             = t
            vc.hideNavigationBar    = true
            self.pushVC(vc)
        }
        
    }
 
    // 跳转专题详情页
    func toVCTopidDetail( _ topic_id:Int? ){
        
        let vc = UIStoryboard.initialViewController("HotStyle", identifier:String(describing: WOWContentTopicController.self)) as! WOWContentTopicController
        //                vc.hideNavigationBar = true
        vc.topic_id = topic_id ?? 0
        navigationController?.pushViewController(vc, animated: true)

    }

}
