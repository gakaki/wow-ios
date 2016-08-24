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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(hexString: "efeff4")
        
        self.title = "我的订单"
        
        let titleArray  = ["全部","待付款","待发货","待收货","以完成"]
        for index in 0..<titleArray.count {
            
            let orderListVC = UIStoryboard.initialViewController("User", identifier:String(WOWOrderController)) as! WOWOrderController
            orderListVC.title = titleArray[index]
            orderListVC.selectIndex = index
            controllerArray.append(orderListVC)
            orderListVC.parentNavigationController = self.navigationController
        }
        
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .MenuHeight(40),
            .MenuMargin(15),
            .MenuItemFont(UIFont.systemFontOfSize(12)),
            .MenuItemWidth(56),
            .SelectionIndicatorColor(UIColor.blackColor()),
            .SelectedMenuItemLabelColor(UIColor.blackColor()),
            .MenuItemSeparatorPercentageHeight(0.1),
            .BottomMenuHairlineColor(MGRgb(234, g: 234, b: 234))
            
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        pageMenu?.viewBackgroundColor = UIColor.init(hexString: "efeff4")!
        self.view.addSubview(pageMenu!.view)

    }
    override func navBack() {
        if entrance == .orderPay {
            self.navigationController?.popToRootViewControllerAnimated(true)
        }else{
            popVC()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationShadowImageView?.hidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationShadowImageView?.hidden = false
        
    }
    
    //MARK:Private Method
    override func setUI() {
        super.setUI()
    }
    


}
