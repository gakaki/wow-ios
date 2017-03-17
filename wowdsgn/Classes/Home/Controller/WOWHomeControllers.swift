//
//  WOWHomeControllers.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/2/28.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
import SnapKit

class WOWHomeControllers: WOWBaseViewController {
    var pageMenu:CAPSPageMenu?
    var controllerArray : [UIViewController] = []
    var selectCurrentIndex : Int? = 0
    
    var parameters: [CAPSPageMenuOption]? = nil
    var tabs : [WOWHomeTabs] = []{// 如果设置值 则说明 子首页tab接口请求成功 titleArray  controllerArray 清零 给新的值
        didSet {
            
            var tabIdArrray :[Int] = []
            titleArray.removeAll()
            controllerArray.removeAll()
            if tabs.count > 0 {
                for tab in tabs.enumerated() {
                    if tab.offset == 0 {
                        titleArray.append("推荐")
                        tabIdArrray.append(tab.element.id ?? 0)
                    }else {
                        titleArray.append(tab.element.name ?? "")
                        tabIdArrray.append(tab.element.id ?? 0)
                    }
                    
                    
                }
            }
            
            for index in 0..<titleArray.count {
                
                let HomeTabVC = UIStoryboard.initialViewController("Home", identifier:String(describing: WOWController.self)) as! WOWController
                HomeTabVC.title = titleArray[index]
                
                if index == 0 {
                    
                }else {
                    
                    HomeTabVC.tabId = tabIdArrray[index]
                }
                HomeTabVC.delegate = self
                controllerArray.append(HomeTabVC)
                HomeTabVC.SuperViewController = self
            }
            self.configTabs()

        }
    }
    var titleArray  = ["推荐"] // 默认 一页
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "titleView"))
        self.view.backgroundColor = UIColor(hexString: "efeff4")
        
        for index in 0..<titleArray.count {// 默认 为“推荐”
            
            let HomeTabVC = UIStoryboard.initialViewController("Home", identifier:String(describing: WOWController.self)) as! WOWController
            HomeTabVC.title = titleArray[index]
            
            HomeTabVC.delegate = self
            
            controllerArray.append(HomeTabVC)

        }
        let width =  MGScreenWidth - CGFloat(53 * controllerArray.count)
        let menuMargin = width/CGFloat(controllerArray.count + 1)
        parameters = [
            .scrollMenuBackgroundColor(UIColor.white),
            .menuHeight(40),
            .menuMargin(menuMargin),
            .menuItemFont(UIFont.systemFont(ofSize: 14)),
            .unselectedMenuItemLabelColor(MGRgb(128, g: 128, b: 128)),
            .menuItemWidth(53),
            .selectionIndicatorColor(UIColor.black),
            .selectedMenuItemLabelColor(UIColor.black),
            .menuItemSeparatorPercentageHeight(0.1),
            .bottomMenuHairlineColor(MGRgb(234, g: 234, b: 234))
        ]
           pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        
        self.view.addSubview(pageMenu!.view)

        addObserver()
        // Do any additional setup after loading the view.
    }
    // 配置顶部tab信息
    func configTabs(){
        
        pageMenu?.view.removeFromSuperview()
        pageMenu = nil
        let width =  MGScreenWidth - CGFloat(53 * controllerArray.count)
        var menuMargin = width/CGFloat(controllerArray.count + 1)
        if controllerArray.count > 5 {
            menuMargin = 15
        }
        parameters = [
            .scrollMenuBackgroundColor(UIColor.white),
            .menuHeight(40),
            .menuMargin(menuMargin),
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
       
        self.view.addSubview(pageMenu!.view)
        

    }
    
    fileprivate func addObserver(){
        /**
         添加通知
         */
  
        NotificationCenter.default.addObserver(self, selector:#selector(updateBageCount), name:NSNotification.Name(rawValue: WOWUpdateCarBadgeNotificationKey), object:nil)
        
        
    }

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
//                    if strongSelf.tabs.elementsEqual(array)  {
//                      
//                         print("equal two")
//                    }else {
                        var isEqual = true
                        if strongSelf.tabs.count != array.count {
                            isEqual = false
                        }else {
                            for model  in array.enumerated() {
//                                if strongSelf.tabs.count > model.offset {
                                    let oldModel = strongSelf.tabs[model.offset]
                                    if model.element.id == oldModel.id && model.element.name == oldModel.name {
                                        print("equal")
                                    }else{
                                        isEqual = false
                                        print("new")
                                    }
//                                }else {
//                                    isEqual = false
//                                    print("new")
//                                }
                            }
                        }
                    
                    if isEqual == false {
                        strongSelf.tabs = array
                        
                    }
 
                   
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

extension WOWHomeControllers:CAPSPageMenuDelegate,WOWChideControllerDelegate{
    

    // 滑动结束 再请求网络
    func didMoveToPage(_ controller: UIViewController, index: Int){
        
        
        let currentVC = controller as! WOWController
        if currentVC.isRequest == false { // 如果未请求，才去请求网络。
            currentVC.request()
        }
        
        
    }
    func updateTabsRequsetData(){
        print("request ...")
         requestTabs()
    }
}
