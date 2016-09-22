//
//  WOWFavoriteController.swift
//  wowapp
//
//  Created by 小黑 on 16/6/7.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWFavoriteController: WOWBaseViewController {
    var pageMenu:CAPSPageMenu?
    var controllerArray : [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
     
        let productVC = UIStoryboard.initialViewController("Favorite", identifier:String(describing: WOWFavProduct.self)) as! WOWFavProduct
    
        productVC.title = "单品"
        
        productVC.parentNavigationController = self.navigationController
        let brandVC = UIStoryboard.initialViewController("Favorite", identifier:String(describing: WOWFavBrand.self)) as! WOWFavBrand
        brandVC.title = "品牌"
        brandVC.parentNavigationController = self.navigationController

        let designerVC = UIStoryboard.initialViewController("Favorite", identifier:String(describing: WOWFavDesigner.self)) as! WOWFavDesigner
        designerVC.title = "设计师"
        designerVC.parentNavigationController = self.navigationController

        controllerArray.append(productVC)
        controllerArray.append(brandVC)
        controllerArray.append(designerVC)
        
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.whiteColor),
            .menuHeight(40),
            .menuMargin((MGScreenWidth - 180)/4),
            .menuItemFont(UIFont.systemFontOfSize(14)),
            .unselectedMenuItemLabelColor(MGRgb(128, g: 128, b: 128)),
            .menuItemWidth(60),
            .selectionIndicatorColor(UIColor.blackColor),
            .selectedMenuItemLabelColor(UIColor.blackColor),
            .menuItemSeparatorPercentageHeight(0.1),
            .BottomMenuHairlineColor(MGRgb(234, g: 234, b: 234))
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        pageMenu?.delegate = self
        self.view.addSubview(pageMenu!.view)

        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //MARK:Private Method
    override func setUI() {
        super.setUI()
        configBuyBarItem()
        addObserver()
    }
    fileprivate func addObserver(){
        
        NotificationCenter.default.addObserver(self, selector:#selector(updateBageCount), name:NSNotification.Name(rawValue: WOWUpdateCarBadgeNotificationKey), object:nil)
        
    }
    

}
extension WOWFavoriteController:CAPSPageMenuDelegate{
    // 滑动结束 再请求网络
    func didMoveToPage(_ controller: UIViewController, index: Int){
        if index == 0 {
            let currentVC = controller as! WOWFavProduct
            guard currentVC.isRefresh else {
                currentVC.request()
                return
            }
        }else if index == 1 {
            let currentVC = controller as! WOWFavBrand
            guard currentVC.isRefresh else {
                currentVC.request()
                return
            }
        }else {
            let currentVC = controller as! WOWFavDesigner
            guard currentVC.isRefresh else {
                currentVC.request()
                return
            }
        }
    }
    
}
