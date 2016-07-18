//
//  WOWFavoriteController.swift
//  wowapp
//
//  Created by 小黑 on 16/6/7.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWFavoriteController: WOWBaseViewController {
    var menuView:WOWTopMenuTitleView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationShadowImageView?.hidden = true
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
        configCheckView()
    }
    
    private func configCheckView(){
        WOWCheckMenuSetting.defaultSetUp()
        WOWCheckMenuSetting.fill = true
        menuView = WOWTopMenuTitleView(frame:CGRectMake(0, 0, self.view.w, 40), titles: ["单品","场景","品牌","设计师"])
        menuView.delegate = self
        menuView.addBorderBottom(size:0.5, color:BorderColor)
        self.view.addSubview(menuView)
    }
}


//MARK:Delegate
extension WOWFavoriteController:TopMenuProtocol{
    func topMenuItemClick(index: Int) {
        DLog("\(index)")
    }
}
