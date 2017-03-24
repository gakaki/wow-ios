//
//  WOWFavoriteController.swift
//  wowapp
//
//  Created by 小黑 on 16/6/7.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
import SnapKit
import VTMagic

class WOWEnjoyController: WOWBaseViewController {
    
    var v : VCVTMagic!
    
    var vc_product:WOWNewEnjoyController?
    var vc_brand:WOWFavBrand?
    var isOpen: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        self.navigationShadowImageView?.isHidden = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        self.navigationShadowImageView?.isHidden = true
        //        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    lazy var navView:WOWEnjoyNavView = {
        let v = Bundle.main.loadNibNamed(String(describing: WOWEnjoyNavView.self), owner: self, options: nil)?.last as! WOWEnjoyNavView
        v.categoryBtn.addTarget(self, action: #selector(categoryClick), for: .touchUpInside)
        return v
    }()
    lazy var backView:WOWCategoryBackView = {
        let v = WOWCategoryBackView(frame:CGRect(x: 0,y: 64,width: MGScreenWidth,height: MGScreenHeight - 64))
        return v
    }()
    
    override func setUI() {
        super.setUI()
        self.navigationItem.titleView = navView
        
//        configBuyBarItem()
        
        v                               = VCVTMagic()
        v.magicView.dataSource          = self
        v.magicView.delegate            = self
        
        v.magicView.layoutStyle         = .divide
        v.magicView.switchStyle         = .default
        
        v.magicView.sliderWidth         = 50.w
        v.magicView.sliderColor         = WowColor.black
        v.magicView.sliderHeight        = 3.w
        v.magicView.isSwitchAnimated        = false
        v.magicView.isScrollEnabled         = true
        self.addChildViewController(v)
        self.view.addSubview(v.magicView)
        
        v.magicView.snp.makeConstraints {[weak self] (make) -> Void in
            if let strongSelf = self {
                make.size.equalTo(strongSelf.view)
                
            }
        }
        
        
        vc_product    = UIStoryboard.initialViewController("Enjoy", identifier:String(describing: WOWNewEnjoyController.self)) as? WOWNewEnjoyController
        vc_brand    = UIStoryboard.initialViewController("Favorite", identifier:String(describing: WOWFavBrand.self)) as? WOWFavBrand
        
        v.magicView.reloadData()
    }

    
    //MARK: --privite 
    func categoryClick()  {
        print("全部分类")
        changeButtonState()
    }
    
    func changeButtonState() {
        if isOpen {
            backView.hidePayView()
        }else {
            chooseStyle()
        }
        UIView.animate(withDuration: 0.25) { [weak self] in
            if let strongSelf = self {
                if strongSelf.isOpen {
                    strongSelf.navView.arrowImg.transform = CGAffineTransform.identity

                }else {
                    strongSelf.navView.arrowImg.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))

                }
            }
        
        }
        isOpen = !isOpen
    }
    
    //MARK: - 弹出选择支付窗口
    func chooseStyle() {
        let window = UIApplication.shared.windows.last
        
        window?.addSubview(backView)
        window?.bringSubview(toFront: backView)
        backView.show()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension WOWEnjoyController:VTMagicViewDataSource{
    
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
        return ["佳作","最新"]
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
        print("button")
    }
    
    func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController{
        
        let vc = magicView.dequeueReusablePage(withIdentifier: self.identifier_magic_view_page)
        
        if (vc == nil) {
            
            if (pageIndex == 0){
                return vc_brand!
            }else if (pageIndex == 1){
                return vc_product!
            }
        }
        
        return vc!
    }
}

extension WOWEnjoyController:VTMagicViewDelegate{
    func magicView(_ magicView: VTMagicView, viewDidAppear viewController: UIViewController, atPage pageIndex: UInt){
        print("viewDidAppear:", pageIndex);
        
        if let b = magicView.menuItem(at: pageIndex) {
            print("  button asc is ", b)
            
            switch pageIndex {
            case  0: break
            case  1:
                //                MobClick.e(.Brands_List)
                break
            default:
                //                MobClick.e(.Shopping)
                break
            }
            
        }
    }
    func magicView(_ magicView: VTMagicView, didSelectItemAt itemIndex: UInt){
        print("didSelectItemAtIndex:", itemIndex);
        
    }
    
}
