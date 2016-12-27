 
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
import WowShare
 
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

    //Wow开头的类  然后可以注入id
    public class func toDesigner(designerId:Int?){
        if let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWBrandHomeController.self)) as? WOWBrandHomeController
        {
            vc.designerId           = designerId
            vc.entrance             = .designerEntrance
            vc.hideNavigationBar = true
            topNaVC?.pushViewController(vc, animated: true)
        }
    }
    public class func toBrand( brand_id: Int?){
        if let vc    = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWBrandHomeController.self)) as? WOWBrandHomeController {
            vc.brandID = brand_id
            vc.entrance = .brandEntrance
            vc.hideNavigationBar = true
            topNaVC?.pushViewController(vc, animated: true)
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
//    toVCTopidDetail
    public class func toToPidDetail(topicId: Int){
        
//        MobClick.e(.My_Orders)
        
        let vc = UIStoryboard.initialViewController("HotStyle", identifier:String(describing: WOWContentTopicController.self)) as! WOWContentTopicController
   
        vc.topic_id = topicId
     
        topNaVC?.pushViewController(vc, animated: true)
    }

    public class func toOrderList(){
        guard WOWUserManager.loginStatus else{
            toLoginVC(true)
            return
        }
        
        MobClick.e(.My_Orders)

        let vc = WOWOrderListViewController()
        vc.selectCurrentIndex = 0
        
        
        topNaVC?.pushViewController(vc, animated: true)
    }
    
    public class func toOrderDetail(orderCode: String){
        guard WOWUserManager.loginStatus else{
            toLoginVC(true)
            return
        }
        let vc = UIStoryboard.initialViewController("User", identifier: "WOWOrderDetailController") as! WOWOrderDetailController
        vc.orderCode = orderCode
        topNaVC?.pushViewController(vc, animated: true)
    }

    public class func toTopicList(topicId: Int){
        
        let vc                  = VCTopic(nibName: nil, bundle: nil)
        vc.topic_id             = topicId
        vc.hideNavigationBar    = true

        
        topNaVC?.pushViewController(vc, animated: true)
    }

    public class func toHomeIndex(index: Int){
        guard index != 3 else{
            toLoginVC(true)
            return
        }
        
        UIApplication.appTabBarController.selectedIndex = index
        WOWTool.lastTabIndex = index
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

    public class func toVCProduct( _ pid: Int? ){
        
        let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWProductDetailController.self)) as! WOWProductDetailController
        vc.hideNavigationBar = true
        vc.productId = pid
        topNaVC?.pushViewController(vc, animated: true)
    }
    public class func toVCH5( _ url: String? ){
        
        let vc = WOWWebViewController()
        if let url = url{
            vc.url = url
        }
        topNaVC?.pushViewController(vc, animated: true)
    }
    
    public class func toVCCategory( _ pid: Int? ){
        
        let vc = UIStoryboard.initialViewController(StoryBoardNames.Found.rawValue, identifier: String(describing: VCCategory.self)) as! VCCategory
        vc.ob_cid.value     = pid ?? 10
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
        
//        let snsPlat = UMSocialSnsPlatformManager.getSocialPlatform(withName: UMShareToWechatSession)
//        
//        snsPlat?.loginClickHandler(self, UMSocialControllerService.default(), true, {[weak self]response in
//            if let strongSelf = self{
//                if response?.responseCode == UMSResponseCodeSuccess {
//                    
//                    strongSelf.checkWechatToken(response?.thirdPlatformUserProfile as! NSDictionary, isPresent: isPresent)
//                }else{
//                    WOWHud.showMsg("授权登录失败")
//                }
//            }
//        })

        WowShare.getAuthWithUserInfoFromWechat {[weak self] (response) in
                if let strongSelf = self{
//                    if response?.responseCode == UMSResponseCodeSuccess {
//                        
                        strongSelf.checkWechatToken(response as! NSDictionary, isPresent: isPresent)
                    }else{
                        WOWHud.showMsg("授权登录失败")
                    }
//                    let userInfo: UMSocialUserInfoResponse = response as! UMSocialUserInfoResponse
            
                    print(response)

        }
    
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
    
    func goLeavaTips(){
        
        let vc = UIStoryboard.initialViewController("User", identifier:"WOWLeaveTipsController") as! WOWLeaveTipsController

        self.navigationController?.pushViewController(vc, animated: true)
    }
    //登录成功方法
    func toLoginSuccess(_ isPresent:Bool = false){
//        WOWBuyCarMananger.updateBadge(true)
       
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
    // 跳转评论 页面
    func toCommentVC(_ orderCode:String )  {
        let vc = UIStoryboard.initialViewController("User", identifier:String(describing: WOWUserCommentVC.self)) as! WOWUserCommentVC
//        self?.navigationController?.pushViewController(vc, animated: true)
        vc.orderCode = orderCode
        pushVC(vc)
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
    
    //跳转消息中心
    func toVCMessageCenter()  {
        let vc = UIStoryboard.initialViewController("Message", identifier:String(describing: WOWMessageController.self)) as! WOWMessageController
        vc.hideNavigationBar = false
        pushVC(vc)
    }
    /// 跳转专题列表
    ///   - columntId: 专题ID
    ///   - title: 专题Title
    ///   - isOpenTag: 是否点击标签进来的， true 为点击标签触发
    ///   - isPageView: false为在首页点击触发，true为在详情页点击触发
    func toVCArticleListVC(_ columntId: Int,title: String,isOpenTag:Bool,isPageView:Bool) {
        let vc = UIStoryboard.initialViewController("HotStyle", identifier:String(describing: WOWHotArticleList.self)) as! WOWHotArticleList
        vc.title        = title
        vc.columnId     = columntId
        vc.isOpenTag    = isOpenTag
        vc.isPageView   = isPageView
        pushVC(vc)
    }
    // 104 类型跳转。 linkType = 10 
    func goToProductGroup(_ groupId:Int){
        let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWProductListController.self)) as! WOWProductListController
        vc.groupId = groupId
        vc.hideNavigationBar = true
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
