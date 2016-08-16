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
            .MenuMargin((MGScreenWidth - 240)/3),
            .MenuItemWidth(60),
            .SelectionIndicatorColor(UIColor.blackColor()),
            .SelectedMenuItemLabelColor(UIColor.blackColor()),
            .MenuItemSeparatorPercentageHeight(0.1),
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)

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
        configBarItem()
    }
    
    private func configBarItem(){
        
//                makeCustomerImageNavigationItem("search", left:true) {[weak self] () -> () in
//                    if let strongSelf = self{
//                        let vc = UIStoryboard.initialViewController("Home", identifier: String(WOWSearchsController))
//                        let transition = CATransition.init()
//                        transition.duration = 0.3
//                        transition.subtype = kCATransitionFromBottom
//                        strongSelf.navigationController?.view.layer.addAnimation(transition, forKey: nil)
//                        strongSelf.navigationController?.pushViewController(vc, animated: true)
//                    }
//                }
        
        makeCustomerImageNavigationItem("buy", left:false) {[weak self] () -> () in
            if let strongSelf = self{
                let vc = UIStoryboard.initialViewController("BuyCar", identifier:String(WOWBuyCarController)) as! WOWBuyCarController
                vc.hideNavigationBar = false
                strongSelf.navigationController?.pushViewController(vc, animated: true)            }
        }
    }

}

