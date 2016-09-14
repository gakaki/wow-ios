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
     
        let productVC = UIStoryboard.initialViewController("Favorite", identifier:String(WOWFavProduct)) as! WOWFavProduct
    
        productVC.title = "单品"
        
        productVC.parentNavigationController = self.navigationController
        let brandVC = UIStoryboard.initialViewController("Favorite", identifier:String(WOWFavBrand)) as! WOWFavBrand
        brandVC.title = "品牌"
        brandVC.parentNavigationController = self.navigationController

        let designerVC = UIStoryboard.initialViewController("Favorite", identifier:String(WOWFavDesigner)) as! WOWFavDesigner
        designerVC.title = "设计师"
        designerVC.parentNavigationController = self.navigationController

        controllerArray.append(productVC)
        controllerArray.append(brandVC)
        controllerArray.append(designerVC)
        
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .MenuHeight(40),
            .MenuMargin((MGScreenWidth - 180)/4),
            .MenuItemWidth(60),
            .SelectionIndicatorColor(UIColor.blackColor()),
            .SelectedMenuItemLabelColor(UIColor.blackColor()),
            .MenuItemSeparatorPercentageHeight(0.1),
            .BottomMenuHairlineColor(MGRgb(234, g: 234, b: 234))
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        pageMenu?.delegate = self
        self.view.addSubview(pageMenu!.view)

        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //MARK:Private Method
    override func setUI() {
        super.setUI()
        configBuyBarItem()
        addObserver()
    }
    private func addObserver(){
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(updateBageCount), name:WOWUpdateCarBadgeNotificationKey, object:nil)
        
    }
    

}
extension WOWFavoriteController:CAPSPageMenuDelegate{
    // 滑动结束 再请求网络
    func didMoveToPage(controller: UIViewController, index: Int){
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
