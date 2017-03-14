//
//  WOWHomeControllers.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/2/28.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
import HidingNavigationBar
class WOWHomeControllers: WOWBaseViewController {
    var pageMenu:CAPSPageMenu?
    var controllerArray : [UIViewController] = []
    var selectCurrentIndex : Int? = 0
    
    var hidingNavBarManager: HidingNavigationBarManager?
    
    var tabs : [WOWHomeTabs] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hexString: "efeff4")
        
        
        
        addObserver()
        // Do any additional setup after loading the view.
    }
    // 配置顶部tab信息
    func configTabs(){
        var titleArray  = ["推荐"] // 默认 一页
        var tabIdArrray :[Int] = []
        
        if tabs.count > 0 {
            for tab in tabs.enumerated() {
                
                titleArray.append(tab.element.name ?? "")
                tabIdArrray.append(tab.element.id ?? 0)
                
            }
        }
       
        for index in 0..<titleArray.count {
            
            let HomeTabVC = UIStoryboard.initialViewController("Home", identifier:String(describing: WOWController.self)) as! WOWController
            HomeTabVC.title = titleArray[index]

            if index == 0 {
            
            }else {
                
                HomeTabVC.tabId = tabIdArrray[index - 1]
            }
           
            controllerArray.append(HomeTabVC)
            HomeTabVC.SuperViewController = self
        }
        
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.white),
            .menuHeight(40),
            .menuMargin(15),
            .menuItemFont(UIFont.systemFont(ofSize: 14)),
            .unselectedMenuItemLabelColor(MGRgb(128, g: 128, b: 128)),
            .menuItemWidth(53),
            .selectionIndicatorColor(UIColor.black),
            .selectedMenuItemLabelColor(UIColor.black),
            .menuItemSeparatorPercentageHeight(0.1),
            .bottomMenuHairlineColor(MGRgb(234, g: 234, b: 234))
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        pageMenu?.delegate = self
        
        pageMenu?.delegate = self
        self.view.addSubview(pageMenu!.view)

    }
    
    fileprivate func addObserver(){
        /**
         添加通知
         */
  
        NotificationCenter.default.addObserver(self, selector:#selector(updateBageCount), name:NSNotification.Name(rawValue: WOWUpdateCarBadgeNotificationKey), object:nil)
        
        
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        hidingNavBarManager?.viewWillAppear(animated)
//        
//
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//        
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//        hidingNavBarManager?.viewWillDisappear(animated)
//        
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        hidingNavBarManager?.viewDidLayoutSubviews()
//    }
//    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
//        //              hidingNavBarManager?.shouldScrollToTop()
//        hidingNavBarManager?.shouldScrollToTop()
//        return true
//    }
    override func setUI() {
        super.setUI()
        request()
        configBarItem()
        
    }
    override func request() {
        super.request()
        requestTabs()
        requestMsgCount()
    }
    func requestTabs(){
        WOWNetManager.sharedManager.requestWithTarget(.api_Home_Tabs, successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            if let strongSelf = self{
//                let json = JSON(result)

                if let array = Mapper<WOWHomeTabs>().mapArray(JSONObject:JSON(result)["tabs"].arrayObject){
                    
                    strongSelf.tabs = array
                    strongSelf.configTabs()
                }
               

            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self {
                strongSelf.configTabs()
            }
        }

        
    }
    // 请求消息数量接口
    func requestMsgCount() {
        
        WOWNetManager.sharedManager.requestWithTarget(.api_MessageCount, successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            if let strongSelf = self{
                let json = JSON(result)
                let systemMsg = json["systemMessageUnReadCount"].int
                let userMsg = json["userMessageUnReadCount"].int
                WOWUserManager.systemMsgCount = systemMsg ?? 0
                WOWUserManager.userMsgCount = userMsg ?? 0
                NotificationCenter.postNotificationNameOnMainThread(WOWUpdateCarBadgeNotificationKey, object: nil)
                DLog(json)
                
            }
        }) { (errorMsg) in
            
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.e(.Home_Page)
        
        self.navigationShadowImageView?.isHidden = true
     
        self.navigationController?.setNavigationBarHidden(false, animated: true)
//        hidingNavBarManager?.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//          hidingNavBarManager?.viewWillDisappear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        hidingNavBarManager?.viewDidLayoutSubviews()
    }
//    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
//                //              hidingNavBarManager?.shouldScrollToTop()
//                hidingNavBarManager?.shouldScrollToTop()
//            return true
//    }


    fileprivate func configBarItem(){
        configBuyBarItem() // 购物车数量
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension WOWHomeControllers:CAPSPageMenuDelegate{
    

    // 滑动结束 再请求网络
    func didMoveToPage(_ controller: UIViewController, index: Int){
        
        
        let currentVC = controller as! WOWController
        if currentVC.isRequest == false { // 如果未请求，才去请求网络。
            currentVC.request()
        }
        
        
    }
    
}
