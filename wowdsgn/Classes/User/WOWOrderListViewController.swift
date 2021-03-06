//
//  WOWOrderListViewController.swift
//  wowapp
//
//  Created by 陈旭 on 16/8/24.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWOrderListViewController: WOWBaseViewController {
    var entrance = orderDetailEntrance.orderList
    var pageMenu:CAPSPageMenu?
    var controllerArray : [UIViewController] = []
    var selectCurrentIndex : Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hexString: "efeff4")
        self.title = "我的订单"
        
        let titleArray  = ["全部","待付款","待发货","待收货","待评论"]
        for index in 0..<titleArray.count {
            
            let orderListVC = UIStoryboard.initialViewController("User", identifier:String(describing: WOWOrderController.self)) as! WOWOrderController
            orderListVC.title = titleArray[index]
            orderListVC.selectIndex = index
            controllerArray.append(orderListVC)
            orderListVC.parentNavigationController = self.navigationController
        }

        var itemWidth :CGFloat = 0.00
        switch UIDevice.deviceType {
        case .dt_iPhone5:
            itemWidth = 46
        case.dt_iPhone6:
            itemWidth = 56
        case.dt_iPhone6_Plus:
            itemWidth = 64
        default:
            itemWidth = 56*MGScreenWidth/375
        }
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.white),
            .menuHeight(40),
            .menuMargin(15),
            .menuItemFont(UIFont.systemFont(ofSize: 14)),
            .unselectedMenuItemLabelColor(MGRgb(128, g: 128, b: 128)),
            .menuItemWidth(itemWidth),
            .selectionIndicatorColor(UIColor.black),
            .selectedMenuItemLabelColor(UIColor.black),
            .menuItemSeparatorPercentageHeight(0.1),
            .bottomMenuHairlineColor(MGRgb(234, g: 234, b: 234))
            
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        pageMenu?.viewBackgroundColor = UIColor.init(hexString: "efeff4")!
        pageMenu?.delegate = self
    
  
//        pageMenu!.currentPageIndex = selectCurrentIndex!
        pageMenu?.moveToPage(selectCurrentIndex!)
//        pageMenu!.startingPageForScroll = selectCurrentIndex!
        self.view.addSubview(pageMenu!.view)
//        self.tz_addPopGesture(to: pageMenu!.view)
    }
    override func navBack() {
        if entrance == .orderPay {
           _ = self.navigationController?.popToRootViewController(animated: true)
        }else{
            popVC()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationShadowImageView?.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationShadowImageView?.isHidden = false
        
    }

    //MARK:Private Method
    override func setUI() {
        super.setUI()
    }
    


}
extension WOWOrderListViewController:CAPSPageMenuDelegate{
    
    func willMoveToPage(_ controller: UIViewController, index: Int) {
        if selectCurrentIndex == index {// 点击不同的列表页  第一次进列表页 请求数据
            let currentVC = controller as! WOWOrderController
            if currentVC.isRequest == false { // 如果未请求，才去请求网络。
                currentVC.request()
            }
        }
    }
    // 滑动结束 再请求网络
    func didMoveToPage(_ controller: UIViewController, index: Int){
   
        
        let currentVC = controller as! WOWOrderController
        if currentVC.isRequest == false { // 如果未请求，才去请求网络。
            currentVC.request()
        }
        
        
    }

}
