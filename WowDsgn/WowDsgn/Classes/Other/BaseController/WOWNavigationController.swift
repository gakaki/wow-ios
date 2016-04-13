//
//  WOWNavigationController.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/17.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.translucent = false
        interactivePopGestureRecognizer?.delegate = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if (self.viewControllers.count > 0) {
            var forwardVCTitle = self.topViewController?.navigationItem.title
            forwardVCTitle = forwardVCTitle ?? ""
            viewController.makeBackButton(forwardVCTitle)
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: true)
    }
}



extension UIViewController{
    func makeBackButton(title:String!){
        let button = UIButton(type:.System)
        let size = title.size(FontMediumlevel003)
        button.titleLabel?.font = FontMediumlevel003
        button.frame = CGRectMake(0, 0, size.width + 36, 32)
        let image = UIImage(named: "backButtonBack")
        button.addTarget(self, action:#selector(backButtonClick), forControlEvents:.TouchUpInside)
        button.setImage(UIImage(named: "nav_backArrow"), forState:.Normal)
        button.setTitle(title, forState:.Normal)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5)
        button.setBackgroundImage(image?.stretchableImageWithLeftCapWidth(Int((image?.size.width)! * 0.5), topCapHeight:0), forState:.Normal)
        let barItem = UIBarButtonItem(customView:button)
        self.navigationItem.leftBarButtonItem = barItem
        
        //取消左侧的margin
        let item2 = UIBarButtonItem(barButtonSystemItem:.FixedSpace, target: nil, action: nil)
//        item2.width -= 16
        item2.width = UIDevice.deviceType.rawValue > 3 ? -20 : -16
        self.navigationItem.leftBarButtonItems = [item2,barItem]
    }
    
    /// 返回按钮点击事件
    func backButtonClick() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}