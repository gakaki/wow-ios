//
//  WOWHomeControllers.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/2/28.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWHomeControllers: WOWBaseViewController {
    var pageMenu:CAPSPageMenu?
    var controllerArray : [UIViewController] = []
    var selectCurrentIndex : Int? = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hexString: "efeff4")
        
        let titleArray  = ["推荐","礼品","家居","家具","选项1","选项2"]
        for index in 0..<titleArray.count {
            
            let orderListVC = UIStoryboard.initialViewController("Home", identifier:String(describing: WOWController.self)) as! WOWController
            orderListVC.title = titleArray[index]
//            orderListVC.selectIndex = index
            controllerArray.append(orderListVC)
            orderListVC.parentNavigationController = self.navigationController
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
//        pageMenu?.viewBackgroundColor = UIColor.init(hexString: "efeff4")!
//        pageMenu?.delegate = self
//        pageMenu?.enableHorizontalBounce = false
//        pageMenu?.centerMenuItems = true
        //        pageMenu!.currentPageIndex = selectCurrentIndex!
//        pageMenu?.moveToPage(selectCurrentIndex!)
        //        pageMenu!.startingPageForScroll = selectCurrentIndex!
        pageMenu?.delegate = self
        self.view.addSubview(pageMenu!.view)
        addObserver()
        // Do any additional setup after loading the view.
    }
    fileprivate func addObserver(){
        /**
         添加通知
         */
  
        NotificationCenter.default.addObserver(self, selector:#selector(updateBageCount), name:NSNotification.Name(rawValue: WOWUpdateCarBadgeNotificationKey), object:nil)
        
        
    }
    override func setUI() {
        super.setUI()
    
        configBarItem()
        
    }
    override func request() {
        super.request()
        requestMsgCount()
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
         self.navigationShadowImageView?.isHidden = true
     
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

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
        MobClick.e(.Son_Home_Page_Tab)
    }
    
}
