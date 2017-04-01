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
    
    var categoryArr = [WOWEnjoyCategoryModel]()
    var vc_newEnjoy:WOWNewEnjoyController?
    var vc_masterpiece:WOWMasterpieceController?
    var isOpen: Bool = false
    var currentCategoryId = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
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
        v.categoryBtn.setTitle("ALL", for: .normal)
        return v
    }()
    lazy var backView:WOWCategoryBackView = {
        let v = WOWCategoryBackView(frame:CGRect(x: 0,y: 64,width: MGScreenWidth,height: MGScreenHeight - 64))
        v.selectView.delegate = self
        v.dismissButton.addTarget(self, action: #selector(categoryClick), for:.touchUpInside)
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
        
        
        vc_newEnjoy    = UIStoryboard.initialViewController("Enjoy", identifier:String(describing: WOWNewEnjoyController.self)) as? WOWNewEnjoyController
        vc_newEnjoy?.delegate = self
        vc_newEnjoy?.categoryId = self.currentCategoryId
        vc_masterpiece    = UIStoryboard.initialViewController("Enjoy", identifier:String(describing: WOWMasterpieceController.self)) as? WOWMasterpieceController
        vc_masterpiece?.categoryId = self.currentCategoryId
        vc_masterpiece?.delegate = self
        v.magicView.reloadData()
    }
    
    //MARK: -- NetWork
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(.api_getCategory, successClosure: {[weak self](result, code) in
            WOWHud.dismiss()
            
            if let strongSelf = self{
                let r                             =  JSON(result)
                strongSelf.categoryArr          =  Mapper<WOWEnjoyCategoryModel>().mapArray(JSONObject: r.arrayObject ) ?? [WOWEnjoyCategoryModel]()
                let category = WOWEnjoyCategoryModel(id: 0, categoryName: "ALL")
                strongSelf.categoryArr.insertAsFirst(category)
                for cate in strongSelf.categoryArr {
                    if cate.id == strongSelf.currentCategoryId {
                        cate.isSelect = true
                        strongSelf.navView.categoryBtn.setTitle(cate.categoryName ?? "ALL", for: .normal)
                        break
                    }
                }
                strongSelf.backView.selectView.categoryArr = strongSelf.categoryArr
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                WOWHud.showMsgNoNetWrok(message: errorMsg)
            }
        }


    }

  
    
    //MARK: --privite 
    func categoryClick()  {
      
        changeButtonState()
    }
        func changeButtonState() {
        if isOpen {
            backView.hideView()
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
    
    //MARK: - 弹出选择分类窗口
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



extension WOWEnjoyController:VTMagicViewDataSource, VTMagicViewDelegate{
    
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

        if (pageIndex == 0){
            return vc_masterpiece!
        }else{
            return vc_newEnjoy!
        }
      
    }
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

extension WOWEnjoyController:WOWSelectCategoryDelegate, WOWChideControllerDelegate{
    
    func selectCategory(model:WOWEnjoyCategoryModel) {
        
        currentCategoryId = model.id ?? 0
        
        vc_masterpiece?.categoryId = model.id ?? 0
        vc_newEnjoy?.categoryId = model.id ?? 0
        
        vc_masterpiece?.request()
        vc_newEnjoy?.refreshRequest()
        navView.categoryBtn.setTitle(model.categoryName ?? "ALL", for: .normal)
        changeButtonState()
    }
    
    func updateTabsRequsetData(){
        request()
    }
}
