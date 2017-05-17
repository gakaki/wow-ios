//
//  WOWLoginController.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/19.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit
import SnapKit
import VTMagic


class WOWLoginController: WOWBaseViewController {
    var v : VCVTMagic!
    
    var vc_code:WOWCodeLoginController?
    var vc_pwd:WOWPwdLoginController?

    var isPresent:Bool = false
    
    var isPopRootVC:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        MobClick.e(.Guide_Login)

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
            
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationShadowImageView?.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationShadowImageView?.isHidden = false
        
    }
//MARK:Private Method
    override func setUI() {
        configNavItem()
        self.title = "登录"
        
        
        v                               = VCVTMagic()
        v.magicView.dataSource          = self
        v.magicView.delegate            = self
        
        v.magicView.layoutStyle         = .divide
        v.magicView.switchStyle         = .default
        
        v.magicView.sliderWidth         = 50.w
        v.magicView.itemWidth           = MGScreenWidth / 2
        v.magicView.sliderColor         = WowColor.black
        v.magicView.sliderHeight        = 3.w
        v.magicView.isSeparatorHidden   = true
        
        
        self.addChildViewController(v)
        self.view.addSubview(v.magicView)
        
        v.magicView.snp.makeConstraints {[weak self] (make) -> Void in
            if let strongSelf = self {
                make.size.equalTo(strongSelf.view)
                
            }
        }
        
        
        vc_code    = UIStoryboard.initialViewController("Login", identifier:String(describing: WOWCodeLoginController.self)) as? WOWCodeLoginController
        vc_code?.isPresent = isPresent
        vc_pwd    = UIStoryboard.initialViewController("Login", identifier:String(describing: WOWPwdLoginController.self)) as? WOWPwdLoginController
        vc_pwd?.isPresent = isPresent
        
        v.magicView.reloadData()

    }
    
    fileprivate func configNavItem(){
        makeCustomerImageNavigationItem("close", left:true) {[weak self] in
            if let strongSelf = self{
                if strongSelf.isPopRootVC {
                    strongSelf.dismiss(animated: true, completion: {
                       _ = UIApplication.currentViewController()?.navigationController?.popToRootViewController(animated: true)
                    })

                }else{
                    strongSelf.dismiss(animated: true, completion: nil)
                }
                if WOWTool.lastTabIndex == 3 || WOWTool.lastTabIndex == 4{
                    WOWTool.lastTabIndex = 0
                }
                UIApplication.appTabBarController.selectedIndex = WOWTool.lastTabIndex
                
                
            }
        }
    }
    
    
}

extension WOWLoginController:VTMagicViewDataSource{
    
    var identifier_magic_view_bar_item : String {
        get {
            return "identifier_magic_view_bar_item"
        }
    }
    var identifier_magic_view_page : String {
        get {
            return "identifier_magic_view_page"
        }
    }
    
    //获取所有菜单名，数组中存放字符串类型对象
    func menuTitles(for magicView: VTMagicView) -> [String] {
        return ["短信登录","密码登录"]
    }
    func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton{
        
        let button = magicView .dequeueReusableItem(withIdentifier: self.identifier_magic_view_bar_item)
        
        if ( button == nil) {
            let width           = self.view.frame.width / 3
            let b               = UIButton(type: .custom)
            b.frame             = CGRect(x: 0, y: 0, width: width, height: 50)
            b.titleLabel!.font  =  UIFont.systemFont(ofSize: 14)
            b.setTitleColor(WowColor.grayLight, for: UIControlState())
            b.setTitleColor(WowColor.black, for: .selected)
            b.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
            return b
        }
        
        return button!
    }
    
    func buttonAction(){
        DLog("button")
    }
    
    func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController{
        
        let vc = magicView.dequeueReusablePage(withIdentifier: self.identifier_magic_view_page)
        
        if (vc == nil) {
            
            if (pageIndex == 0){
                return vc_code!
            }else{
                return vc_pwd!
            }
        }
        
        return vc!
    }
}

extension WOWLoginController:VTMagicViewDelegate{
    func magicView(_ magicView: VTMagicView, viewDidAppear viewController: UIViewController, atPage pageIndex: UInt){
        
        if let b = magicView.menuItem(at: pageIndex) {
            
        }
    }
    func magicView(_ magicView: VTMagicView, didSelectItemAt itemIndex: UInt){
        
    }
    
}




