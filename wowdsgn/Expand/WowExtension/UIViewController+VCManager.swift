 
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
    public class func toRegVC( isPresent:Bool = false){
        
        let vc = UIStoryboard.initialViewController("Login", identifier:String(describing: WOWRegistController.self)) as! WOWRegistController
        vc.isPresent = isPresent
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
                
                topNaVC?.topViewController?.dismiss(animated: true, completion: nil)
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
        
        MobClick.e(.Content_topic)
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
    
    /*
     ** isNew： 当指定到第三个页面时，isNew 为 true时， 滑动到 最新 界面
     */
    public class func toHomeIndex(index: Int,isNew:Bool=false){

        if index == 4 {
            guard WOWUserManager.loginStatus else{
                toLoginVC(true)
                return
            }
        }
        
        let tabBarController = UIApplication.currentViewController()?.tabBarController
        tabBarController?.selectedIndex = index
        
        WOWTool.lastTabIndex = index
        if index == 3 {
            if isNew {
                let vc =  tabBarController?.viewControllers?[3] as! UINavigationController
                let viewController = vc.visibleViewController as? WOWEnjoyController
                 viewController?.isOpenRouter = true
                viewController?.toMagicPage = 1
               
            }else {
                let vc =  tabBarController?.viewControllers?[3] as! UINavigationController
                let viewController = vc.visibleViewController as? WOWEnjoyController
                viewController?.isOpenRouter = true
                viewController?.toMagicPage = 0
            }
          
        }

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
    public class func toVCProduct( _ pid: Int?, customPop: Bool = false, isFromCustomVC: Bool = false){
        
        let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWProductDetailController.self)) as! WOWProductDetailController
        vc.hideNavigationBar = true
//        vc.isCustormer = true
        vc.productId = pid
        vc.isNeedCustomPop = customPop
        vc.isFromCustomVC  = isFromCustomVC
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
        MobClick.e(.CategoryDetail)
        let vc = UIStoryboard.initialViewController(StoryBoardNames.Found.rawValue, identifier: String(describing: VCCategory.self)) as! VCCategory
        vc.ob_cid.value     = pid ?? 10
        topNaVC?.pushViewController(vc, animated: true)

    }
    
    /*
     ** 场景和标签页面 entrance代表入口
     */
    public class func toVCScene( _ pid: Int?, entrance: CategoryEntrance){

        
            let vc = UIStoryboard.initialViewController(StoryBoardNames.Found.rawValue, identifier: String(describing: WOWSceneController.self)) as! WOWSceneController
            vc.entrance = entrance
            vc.ob_cid     = pid ?? 1
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
        MobClick.e(.Productlist_topic)
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
            WOWHud.showWarnMsg(errorMsg)
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
    public class func bingMobileSecond(entrance: BindMobileEntrance) {
        guard WOWUserManager.loginStatus else{
            toLoginVC(true)
            return
        }
        let vc = UIStoryboard.initialViewController("User", identifier:String(describing: WOWBindMobileSecondViewController.self)) as! WOWBindMobileSecondViewController
        vc.hideNavigationBar = false
        vc.entrance = entrance
        topNaVC?.pushViewController(vc, animated: true)
    }
    
    //优惠券可用商品
    public class func goCounponProduct(couponId: Int, navTitle: String) {
        let vc = UIStoryboard.initialViewController("User", identifier:String(describing: WOWCouponProductController.self)) as! WOWCouponProductController
        vc.couponId = couponId
        vc.navTitle = navTitle
        topNaVC?.pushViewController(vc, animated: true)
    }
    //设置
    public class func goSetting() {
        MobClick.e(.Setting)

        let vc = UIStoryboard.initialViewController("User", identifier:String(describing: WOWSettingController.self)) as! WOWSettingController
        topNaVC?.pushViewController(vc, animated: true)
    }
    
    //关于尖叫设计
    public class func goAbout() {
        let vc = UIStoryboard.initialViewController("User", identifier:"WOWAboutController") as! WOWAboutController
        topNaVC?.pushViewController(vc, animated: true)

    }
    
    //个人中心内页
    public class func goUserCenter(_ toIndexPage:Int = 0) {
        let vc = UIStoryboard.initialViewController("User", identifier:"WOWUserCenterController") as! WOWUserCenterController
        vc.indexPage = toIndexPage
        topNaVC?.pushViewController(vc, animated: true)
    }
    
    public class func goUserInfo() {
        let vc = UIStoryboard.initialViewController("User", identifier:String(describing: WOWUserInfoController.self)) as! WOWUserInfoController
        topNaVC?.pushViewController(vc, animated: true)
    }
    
    public class func goOtherCenter(endUserId: Int) {
        
        let vc = UIStoryboard.initialViewController("NewUser", identifier:String(describing: WOWOtherCenterController.self)) as! WOWOtherCenterController
        vc.endUserId = endUserId
        topNaVC?.pushViewController(vc, animated: true)
    }
    //喜欢
    public class func goFavorite() {
        let vc = UIStoryboard.initialViewController("Favorite", identifier:String(describing: WOWFavoriteController.self)) as! WOWFavoriteController
        topNaVC?.pushViewController(vc, animated: true)
    }
    //优惠券可用商品
    //作品详情页
    public class func bingWorksDetails(worksId:Int) {
        let vc = UIStoryboard.initialViewController("Enjoy", identifier:String(describing: WOWWorksDetailsController.self)) as! WOWWorksDetailsController
        vc.worksId = worksId
        topNaVC?.pushViewController(vc, animated: true)
    }
    //发布作品页
    class func bingReleaseWorks(photo:UIImage!, indexRow: Int, sizeImgId: Int, categoryArray: Array<WOWEnjoyCategoryModel>) {
        let vc = UIStoryboard.initialViewController("Enjoy", identifier:String(describing: WOWReleaseWorksController.self)) as! WOWReleaseWorksController
        vc.photo = photo
        vc.indexRow = indexRow
        vc.imgSizeId = sizeImgId
        vc.categoryArr = categoryArray
        topNaVC?.pushViewController(vc, animated: true)
        
    }

    class func goReleaseWorks(photo:UIImage!, instagramCategoryId: Int?, sizeImgId: Int, instagramCategoryName: String?, type: Int, topicId: Int, activityName: String?) {
        let vc = UIStoryboard.initialViewController("Enjoy", identifier:String(describing: WOWReleaseWorksController.self)) as! WOWReleaseWorksController
        vc.photo = photo
        vc.instagramCategoryId = instagramCategoryId
        vc.imgSizeId = sizeImgId
        vc.instagramCategoryName = instagramCategoryName
        vc.type = type
        vc.topicId = topicId
        vc.activityName = activityName
        topNaVC?.pushViewController(vc, animated: true)
    }
    
    
    //作品活动详情页面
    public class func goWorksActivity(topicId: Int) {
        let vc = UIStoryboard.initialViewController("Enjoy", identifier:String(describing: WOWWorksActivityController.self)) as! WOWWorksActivityController
        vc.topicId = topicId
        topNaVC?.pushViewController(vc, animated: true)

    }
    //作品详情页
    public class func goWorksActivityDetail(topicId: Int) {
        let vc = UIStoryboard.initialViewController("Enjoy", identifier:String(describing: WOWActitvityDetailController.self)) as! WOWActitvityDetailController
        vc.topicId = topicId
        topNaVC?.pushViewController(vc, animated: true)
        
    }

    //申请售后页面
    class func goApplyAfterSales(sendType:AfterType = .sendGoods) {
     
        let vc = WOWApplyAfterController()
        vc.sendType = sendType
        topNaVC?.pushViewController(vc, animated: true)
        
    }
    //仅退款页面
    class func goOnlyRefund() {
 
        let vc = WOWOnlyRefundViewController()
        topNaVC?.pushViewController(vc, animated: true)
        
    }
    //仅退款页面
    class func goAfterDetail() {
  
        let vc = WOWAfterDetailController()
        topNaVC?.pushViewController(vc, animated: true)
        
    }
    //协商详情页面
    class func goNogotiateDetails() {
        


        let vc = WOWNogotiateDetailsController()
        topNaVC?.pushViewController(vc, animated: true)
        
    }
    //协商详情页面
    class func goMoneyFromController() {
//        
//        let vc = UIStoryboard.initialViewController("NewUser", identifier:String(describing: WOWMoneyFromController.self)) as! WOWMoneyFromController
        let vc = WOWMoneyFromController()
        topNaVC?.pushViewController(vc, animated: true)
        
    }
    //跳转在线客服页面 source ：用户信息 commodityInfo: 自定义商品信息 orderNumber : 订单号    ·
    public class func goCustomerVC(_ source:QYSource?,commodityInfo:QYCommodityInfo?, orderNumber:String?) {
        guard WOWUserManager.loginStatus else{
            toLoginVC(true)
            return
        }
        let sessionViewController = QYSDK.shared().sessionViewController()!
        sessionViewController.sessionTitle = "在线客服"
        if let source = source {
            let userId      = WOWCustomerInfoModel.init(key: "userId", label: "用户ID", value: WOWUserManager.userID)
            let userName    = WOWCustomerInfoModel.init(key: "userName", label: "名称", value: WOWUserManager.userName)
            let userPhone   = WOWCustomerInfoModel.init(key: "userPhone", label: "手机号码", value: WOWUserManager.userMobile)
            let userAgeRange   = WOWCustomerInfoModel.init(key: "userAgeRange", label: "年龄段", value:  WOWAgeRange[WOWUserManager.userAgeRange] ?? "保密")
           
            var sexStr = ""
            switch WOWUserManager.userSex {
            case 3:
                sexStr = "保密"
                break
            case 1:
                sexStr = "男"
                break
            case 2:
                sexStr = "女"
                break
            default:
                sexStr = "保密"
                break
            }
            let userSex   = WOWCustomerInfoModel.init(key: "userSex", label: "用户性别", value: sexStr)
            var userInfoArr =  [userId,userName,userPhone,userSex,userAgeRange]
            if let orderNumber = orderNumber {
                let orderNumber = WOWCustomerInfoModel.init(key: "userId", label: "订单号", value: orderNumber)
                userInfoArr.append(orderNumber)
            }
            
            // 设置用户的自定义信息
            let userInfo = QYUserInfo()
            userInfo.userId = WOWUserManager.userID
            userInfo.data   = userInfoArr.toJSONString() ?? ""
            QYSDK.shared().setUserInfo(userInfo)
            
            sessionViewController.source = source
        }
        if let commodityInfo = commodityInfo {
            sessionViewController.commodityInfo = commodityInfo
        }

        QYSDK.shared().customUIConfig().customerHeadImageUrl    = WOWUserManager.userHeadImageUrl
        QYCustomUIConfig.sharedInstance().autoShowKeyboard      =  false
        QYSDK.shared().customUIConfig().serviceHeadImage        = UIImage.init(named: "me_logo")
        sessionViewController.hidesBottomBarWhenPushed          = true
        QYCustomActionConfig.sharedInstance().linkClickBlock = {(str) in //处理聊天 链接点击 自定义事件
            if let str = str {
                if str.contains("wowdsgn.com/item/") {
                    let array = str.components(separatedBy: "item/")
                    if array.count > 1{
                         toVCProduct(str.components(separatedBy: "item/")[1].toInt(), isFromCustomVC: true)
                    }
                   


                }else {
                   _ = JLRouterRule.handle_open_url(url: URL.init(string: str)! )
                
                }
             
            }
            
        }
        
        let item = UIBarButtonItem(image:UIImage(named: "nav_backArrow"), style:.plain, target: self, action: #selector(backAction))
        
        sessionViewController.navigationController?.setNavigationBarHidden(false, animated: true)
        sessionViewController.navigationItem.leftBarButtonItem = item
        
        if FNUtil.currentTopViewController().isKind(of: QYSessionViewController.classForCoder()){
            DLog("为客服聊天界面")
//           topNaVC?.popToRootViewController(animated: false)
        }else {
            MobClick.e(.online_cutomer_service_detailpage)
            topNaVC?.pushViewController(sessionViewController, animated: true)
        }
        
        
        
    }
    
    @objc class func backAction() {
        
        _ = FNUtil.currentTopViewController().navigationController?.popViewController(animated: true)
        
    }

    //    //点击跳转
    class func goToBannerTypeController(_ model: WOWCarouselBanners) {
     
            if let bannerLinkType = model.bannerLinkType {
                let id = model.bannerLinkTargetId ?? 0
                switch bannerLinkType {
                case 0:
                    DLog("占位符")
                case 1:
                    if let url = model.bannerLinkUrl{
                        VCRedirect.toVCH5(url)
                    }
                    
                case 2:
                    DLog("专题详情页（商品列表）")
                case 3:
                    DLog("专题详情页（图文混排）")
                case 4:
                    DLog("品牌详情页")
                    VCRedirect.toBrand(brand_id: id)
                    
                case 5:
                    DLog("设计师详情页")
                    VCRedirect.toDesigner(designerId: id)
                    
                case 6:
                    DLog("商品详情页")
                    VCRedirect.toVCProduct(id)
                    
                case 7:
                    DLog("分类详情页")
                    
                case 8:// 专题详情
                    VCRedirect.toTopicList(topicId: id)
                    DLog("场景还是专题")
                case 9:// 专题详情
                    
                    VCRedirect.toToPidDetail(topicId: id)
                case 10:// 分组产品列表
                    
                    
                    VCRedirect.goToProductGroup(id)
                case 11:// 跳转分类
                    VCRedirect.toVCScene(id, entrance: .category)
                    
                case 12:// 跳转场景分类
                    VCRedirect.toVCScene(id, entrance: .scene)
                    
                case 13:// 跳转标签分类
                    VCRedirect.toVCScene(id, entrance: .tag)
                case 14:// 跳转标签分类
                    
                    switch id {
                    case 0:
                        VCRedirect.toHomeIndex(index: 3)

                    default:
                        VCRedirect.toHomeIndex(index: 3,isNew: true)

                    }

                case 15:// 跳转标签分类
                    
                    VCRedirect.goOtherCenter(endUserId: id)
                    
                case 16:// 跳转标签分类
                    
                    VCRedirect.bingWorksDetails(worksId: id)
                case 17:    //作品活动详情页面
                    VCRedirect.goWorksActivity(topicId: id)
                case 18:    //优惠券
                    VCRedirect.toCouponVC()
                case 100:   //个人中心
                    VCRedirect.toHomeIndex(index: 4)

                default:
                    WOWHud.showMsg("请您更新最新版本")
                    let vc = UIStoryboard.initialViewController("User", identifier:"WOWAboutController") as! WOWAboutController
                   
                    topNaVC?.pushViewController(vc, animated: true)
                    DLog("其他")
                }
                
            }
    
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
            
            DLog(response ?? "")
            
        }
        
    }
    
    func checkWechatToken(_ userData:Dictionary<String, Any>,isPresent:Bool = false){
        //FIXME:验证token是否是第一次咯或者是第二次
        var firstLogin = Bool()//假设的bool值
        let open_id        = (userData["openid"] ?? "") as! String
        let unionid        = (userData["unionid"] ?? "") as! String
        let avatar        = (userData["headimgurl"] ?? "") as! String
        let nickName        = (userData["nickname"] ?? "") as! String
        let language        = (userData["language"] ?? "") as! String
        let province        = (userData["province"] ?? "") as! String
        let sex             = (userData["sex"] ?? 3) as! Int
        let country         = (userData["country"] ?? "") as! String
        
        var params              = [String: Any]()
        params = ["openId": open_id, "unionId": unionid, "wechatAvatar": avatar, "wechatNickName": nickName, "language": language, "province": province, "sex": sex, "country": country]
        WOWNetManager.sharedManager.requestWithTarget(.api_Wechat(params: params as [String : AnyObject]), successClosure: {[weak self] (result, code) in
            if let _ = self{
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
                    MobClick.e(.Registration_Successful)
                    
                    TalkingDataAppCpa.onRegister(user_id)
                    AnalyaticEvent.e2(.Regist,["user":user_id])
                    VCRedirect.toRegInfo(isPresent)
                    
                }
            }
        }) {[weak self] (errorMsg) in
            if let _ = self{
                WOWHud.showWarnMsg(errorMsg)
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
