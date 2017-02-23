 
 //
//  WowVCManager.swift
//  wowapp
//
//  Created by g on 16/7/14.
//  Copyright © 2016年 小黑. All rights reserved.
//

//VCManager is collect the redirect code
import UIKit
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
    /*
     ** 首页页面
     */
    public class func toMainVC(){
        let mainVC = UIStoryboard(name: "Main", bundle:Bundle.main).instantiateInitialViewController()
        mainVC?.modalTransitionStyle = .flipHorizontal
        AppDelegate.rootVC = mainVC
        topNaVC?.present(mainVC!, animated: true, completion: nil)
    }
    


    /*
     ** 设计师页面
     */
    public class func toDesigner(designerId:Int?){
        if let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWBrandHomeController.self)) as? WOWBrandHomeController
        {
            vc.designerId           = designerId
            vc.entrance             = .designerEntrance
            vc.hideNavigationBar = true
            topNaVC?.pushViewController(vc, animated: true)
        }
    }
    
    /*
     ** 品牌页面
     */
    public class func toBrand( brand_id: Int?){
        if let vc    = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWBrandHomeController.self)) as? WOWBrandHomeController {
            vc.brandID = brand_id
            vc.entrance = .brandEntrance
            vc.hideNavigationBar = true
            topNaVC?.pushViewController(vc, animated: true)
        }
    }
    
    /**
     跳转登录界面
     
     - parameter isPresent: true：present跳转 false：push跳转
     */
    public class func toLoginVC(_ isPresent:Bool = false){
        let vc = UIStoryboard.initialViewController("Login", identifier:String(describing: WOWLoginController.self)) as! WOWLoginController
            vc.isPresent = isPresent
        if isPresent {
            
            topNaVC?.present(vc, animated: true, completion: nil)
            
        }else {
            
            topNaVC?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    /**
     跳转登录界面 点击叉号返回 导航控制器根视图
     
     - parameter isPresent: true：present跳转 false：push跳转
     */
    public class func toLoginVCPopRootVC(_ isPresent:Bool = false){
        
        if isPresent {
            let vc = UIStoryboard.initialViewController("Login", identifier: "WOWLoginNavController") as! WOWNavigationController
            let login = vc.topViewController as! WOWLoginController
            login.isPresent = isPresent
            login.isPopRootVC = true
            topNaVC?.present(vc, animated: true, completion: nil)
            
        }else {
            let vc = UIStoryboard.initialViewController("Login", identifier:String(describing: WOWLoginController.self)) as! WOWLoginController
            vc.isPresent = isPresent
            topNaVC?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    //跳转注册/绑定微信界面需要传从哪跳转来的
    public class func toRegVC(_ fromWechat:Bool = false , isPresent:Bool = false,userInfoFromWechat:Dictionary<String, Any>?){
        
        let vc = UIStoryboard.initialViewController("Login", identifier:String(describing: WOWRegistController.self)) as! WOWRegistController
        vc.isPresent = isPresent
        vc.byWechat = fromWechat
        vc.userInfoFromWechat = userInfoFromWechat
        topNaVC?.pushViewController(vc, animated: true)
    }
    
    public class func goLeavaTips(){
        
        let vc = UIStoryboard.initialViewController("User", identifier:"WOWLeaveTipsController") as! WOWLeaveTipsController
        
        topNaVC?.pushViewController(vc, animated: true)
    }
    //登录成功方法
    public class func toLoginSuccess(_ isPresent:Bool = false){
        
        NotificationCenter.postNotificationNameOnMainThread(WOWLoginSuccessNotificationKey, object: nil)
        if isPresent{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64( 0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                topNaVC?.dismiss(animated: true, completion: nil)
            })
        }else {
            //进入首页
            toMainVC()
        }
    }
    
    public class func toRegInfo(_ isPresent:Bool = false) {
        NotificationCenter.postNotificationNameOnMainThread(WOWLoginSuccessNotificationKey, object: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64( 0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            let vc = UIStoryboard.initialViewController("Login", identifier:"WOWRegistInfoFirstController") as! WOWRegistInfoFirstController
            vc.isPresent = isPresent
            topNaVC?.pushViewController(vc, animated: true)
        })
        
    }

    /*
     ** 内容专题页面
     */
    public class func toToPidDetail(topicId: Int){
        
//        MobClick.e(.My_Orders)
        
        let vc = UIStoryboard.initialViewController("HotStyle", identifier:String(describing: WOWContentTopicController.self)) as! WOWContentTopicController
   
        vc.topic_id = topicId
     
        topNaVC?.pushViewController(vc, animated: true)
    }
    
    /*
     ** 订单列表页面
     */
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
    
    /*
     ** 订单详情页面
     */
    public class func toOrderDetail(orderCode: String){
        guard WOWUserManager.loginStatus else{
            toLoginVC(true)
            return
        }
        let vc = UIStoryboard.initialViewController("User", identifier: "WOWOrderDetailController") as! WOWOrderDetailController
        vc.orderCode = orderCode
        topNaVC?.pushViewController(vc, animated: true)
    }
    
    /*
     ** 列表专题页面
     */
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
    
    /*
     ** 优惠券页面
     */
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
    
    /*
     ** 商品详情页面
     */
    public class func toVCProduct( _ pid: Int? ){
        
        let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWProductDetailController.self)) as! WOWProductDetailController
        vc.hideNavigationBar = true
        vc.productId = pid
        topNaVC?.pushViewController(vc, animated: true)
    }
    
    /*
     ** H5页面
     */
    public class func toVCH5( _ url: String? ){
        
        let vc = UIStoryboard.initialViewController("Home", identifier:String(describing: WOWWebViewController.self)) as! WOWWebViewController
        if let url = url{
            vc.url = url
        }
        topNaVC?.pushViewController(vc, animated: true)
    }
    
    /*
     ** 分类页面
     */
    public class func toVCCategory( _ pid: Int? ){
        
        let vc = UIStoryboard.initialViewController(StoryBoardNames.Found.rawValue, identifier: String(describing: VCCategory.self)) as! VCCategory
        vc.ob_cid.value     = pid ?? 10
        topNaVC?.pushViewController(vc, animated: true)
    }
    
    public class func toVCCategoryChoose(){
        let vc          = VCCategoryChoose()
        //        vc.cid          = cid.toString
        topNaVC?.pushViewController(vc, animated: true)
    }
    
    // 跳转评论 页面
    public class func toCommentVC(_ orderCode:String )  {
        let vc = UIStoryboard.initialViewController("User", identifier:String(describing: WOWUserCommentVC.self)) as! WOWUserCommentVC
        vc.orderCode = orderCode
        topNaVC?.pushViewController(vc, animated: true)
    }
    
    ///购物车页面
    public class func toVCCart( ){
        
        
        guard WOWUserManager.loginStatus else {
            toLoginVC(true)
            return
        }
        let vc = UIStoryboard.initialViewController("BuyCar", identifier:String(describing: WOWBuyCarController.self)) as! WOWBuyCarController
        vc.hideNavigationBar = false
        topNaVC?.pushViewController(vc, animated: true)
    }
    
    //跳转消息中心
    public class func toVCMessageCenter()  {
        let vc = UIStoryboard.initialViewController("Message", identifier:String(describing: WOWMessageController.self)) as! WOWMessageController
        vc.hideNavigationBar = false
        topNaVC?.pushViewController(vc, animated: true)
    }
    
    /// 跳转专题列表
    ///   - columntId: 专题ID
    ///   - title: 专题Title
    ///   - isOpenTag: 是否点击标签进来的， true 为点击标签触发
    ///   - isPageView: false为在首页点击触发，true为在详情页点击触发
    public class func toVCArticleListVC(_ columntId: Int,title: String,isOpenTag:Bool,isPageView:Bool) {
        let vc = UIStoryboard.initialViewController("HotStyle", identifier:String(describing: WOWHotArticleList.self)) as! WOWHotArticleList
        vc.title        = title
        vc.columnId     = columntId
        vc.isOpenTag    = isOpenTag
        vc.isPageView   = isPageView
        topNaVC?.pushViewController(vc, animated: true)
    }
    
    // 104 类型跳转。 linkType = 10 产品组
    public class func goToProductGroup(_ groupId:Int){
        let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWProductListController.self)) as! WOWProductListController
        vc.groupId = groupId
        vc.hideNavigationBar = true
        topNaVC?.pushViewController(vc, animated: true)
        
    }
    
    //领取优惠券
    public class func getCoupon(_ couponId: Int) {
        guard WOWUserManager.loginStatus else{
            toLoginVC(true)
            return
        }
        
        WOWNetManager.sharedManager.requestWithTarget(.api_CouponObtain(couponId: couponId), successClosure: { (result, code) in
            WOWHud.showMsg("恭喜您获得一张优惠券")
            
        }) { (errorMsg) in
            
        }
        
    }
    
    //绑定新手机
    public class func bingMobileFirst() {
        guard WOWUserManager.loginStatus else{
            toLoginVC(true)
            return
        }
        let vc = UIStoryboard.initialViewController("User", identifier:String(describing: WOWBindMobileFirstController.self)) as! WOWBindMobileFirstController
        vc.hideNavigationBar = false
        topNaVC?.pushViewController(vc, animated: true)
    }
    //绑定新手机
    public class func bingMobileSecond() {
        guard WOWUserManager.loginStatus else{
            toLoginVC(true)
            return
        }
        let vc = UIStoryboard.initialViewController("User", identifier:String(describing: WOWBindMobileSecondViewController.self)) as! WOWBindMobileSecondViewController
        vc.hideNavigationBar = false
        topNaVC?.pushViewController(vc, animated: true)
    }
    
 }
extension  UIViewController {
    //跳转微信登录界面
    func toWeixinVC(_ isPresent:Bool = false){
        
        MobClick.e(UMengEvent.Guide_Wx_Bind)
        DLog("toWeixinVC")
        
        WowShare.getAuthWithUserInfoFromWechat {[weak self] (response) in
            if let strongSelf = self{
                //                    if response?.responseCode == UMSResponseCodeSuccess {
                //
                strongSelf.checkWechatToken(response as! Dictionary, isPresent: isPresent)
            }else{
                WOWHud.showMsg("授权登录失败")
            }
            
            DLog(response)
            
        }
        
    }
    
    func checkWechatToken(_ userData:Dictionary<String, Any>,isPresent:Bool = false){
        //FIXME:验证token是否是第一次咯或者是第二次
        var firstLogin = Bool()//假设的bool值
        let open_id        = (userData["openid"] ?? "") as! String
        let unionid        = (userData["unionid"] ?? "") as! String
        let avatar        = (userData["headimgurl"] ?? "") as! String
        let nickName        = (userData["nickname"] ?? "") as! String
        WOWNetManager.sharedManager.requestWithTarget(.api_Wechat(openId : open_id, wechatNickName: nickName, wechatAvatar: avatar, unionId: unionid), successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                let json = JSON(result)
                DLog(json)
                firstLogin = JSON(result)["firstLogin"].bool ?? true
                
                //微信登录成功
                let user_id    = "wechatUser_\(open_id)"
                TalkingDataAppCpa.onLogin(user_id)
                AnalyaticEvent.e2(.Login,["user":user_id])
                let model = Mapper<WOWUserModel>().map(JSONObject:result)
                WOWUserManager.saveUserInfo(model)
                
                if !firstLogin {
                    //FIXME:未写的，先保存用户信息
                    
                    
                    VCRedirect.toLoginSuccess(isPresent)
                    
                }else{ //第一次登陆
           
                    VCRedirect.toRegInfo(isPresent)
                    
                }
            }
        }) {[weak self] (errorMsg) in
            if let _ = self{
                
            }
        }
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
            self.pushVC(vc)
        }
        
    }
    
    ///购物车页面
    func toVCCart( ){
        
        
        guard WOWUserManager.loginStatus else {
            toLoginVC(true)
            return
        }
        let vc = UIStoryboard.initialViewController("BuyCar", identifier:String(describing: WOWBuyCarController.self)) as! WOWBuyCarController
        vc.hideNavigationBar = false
        self.pushVC(vc)
    }
    
    //跳转消息中心
    func toVCMessageCenter()  {
        let vc = UIStoryboard.initialViewController("Message", identifier:String(describing: WOWMessageController.self)) as! WOWMessageController
        vc.hideNavigationBar = false
        self.pushVC(vc)
    }
}
