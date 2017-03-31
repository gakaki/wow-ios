//
//  WOWHomeControllers.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/2/28.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
import SnapKit
import VTMagic

class WOWHomeControllers: WOWBaseViewController {
//    var pageMenu:CAPSPageMenu?
    var controllerArray : [UIViewController] = []
    var selectCurrentIndex : Int? = 0
    var v : VCVTMagic!

    var parameters: [CAPSPageMenuOption]? = nil
    var tabs : [WOWHomeTabs] = []{// 如果设置值 则说明 子首页tab接口请求成功 titleArray  controllerArray 清零 给新的值
        didSet {
            
            var tabIdArrray :[Int] = []
            titleArray.removeAll()
            controllerArray.removeAll()
            if tabs.count > 0 {
                for tab in tabs.enumerated() {
                    if tab.offset == 0 {
                        titleArray.append("推荐")
                        tabIdArrray.append(tab.element.id ?? 0)
                    }else {
                        titleArray.append(tab.element.name ?? "")
                        tabIdArrray.append(tab.element.id ?? 0)
                    }
                    
                    
                }
            }
            
            for index in 0..<titleArray.count {
                
                let HomeTabVC = UIStoryboard.initialViewController("Home", identifier:String(describing: WOWController.self)) as! WOWController
                HomeTabVC.title = titleArray[index]
                
                if index == 0 {
                    
                }else {
                    
                    HomeTabVC.tabId = tabIdArrray[index]
                }
                HomeTabVC.delegate = self
                controllerArray.append(HomeTabVC)
            }
//            self.configTabs()
            if tabs.count > 0 {
                let count = CGFloat(titleArray.count)
                if count > 5 {
                    v.magicView.layoutStyle         = .default

//                    v.magicView.itemWidth           = 80
                    v.magicView.itemSpacing         = 40

                }else {
                    v.magicView.layoutStyle         = .divide

//                    v.magicView.itemWidth           = MGScreenWidth / count

                }


                v.magicView.reloadData()

            }

        }
    }
    var titleArray  = ["推荐"] // 默认 一页
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "titleView"))
        self.view.backgroundColor = UIColor(hexString: "efeff4")
        
        
//        let width =  MGScreenWidth - CGFloat(53 * controllerArray.count)
//        let menuMargin = width/CGFloat(controllerArray.count + 1)
//    
//        let tabsWidth:CGFloat = 0.0
        
//        parameters = [
//            .scrollMenuBackgroundColor(UIColor.white),
//            .menuHeight(40),
//            .menuMargin(menuMargin),
//            .menuItemFont(UIFont.systemFont(ofSize: 14)),
//            .unselectedMenuItemLabelColor(MGRgb(128, g: 128, b: 128)),
//            .menuItemWidth(53),
//            .selectionIndicatorColor(UIColor.black),
//            .selectedMenuItemLabelColor(UIColor.black),
//            .menuItemSeparatorPercentageHeight(0.1),
//            .bottomMenuHairlineColor(MGRgb(234, g: 234, b: 234))
//        ]
//           pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
//        
//        self.view.addSubview(pageMenu!.view)

        addObserver()
        // Do any additional setup after loading the view.
    }
    // 配置顶部tab信息
//    func configTabs(){
//        
//        pageMenu?.view.removeFromSuperview()
//        pageMenu = nil
//        let width =  MGScreenWidth - CGFloat(53 * controllerArray.count)
//        var menuMargin = width/CGFloat(controllerArray.count + 1)
//        if controllerArray.count > 5 {
//            menuMargin = 15
//        }
//        parameters = [
//            .scrollMenuBackgroundColor(UIColor.white),
//            .menuHeight(40),
//            .menuMargin(menuMargin),
//            .menuItemFont(UIFont.systemFont(ofSize: 14)),
//            .unselectedMenuItemLabelColor(MGRgb(128, g: 128, b: 128)),
//            .menuItemWidth(53),
//            .selectionIndicatorColor(UIColor.black),
//            .selectedMenuItemLabelColor(UIColor.black),
//            .menuItemSeparatorPercentageHeight(0.1),
//            .bottomMenuHairlineColor(MGRgb(234, g: 234, b: 234))
//        ]
//
//        
//        
//        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
//        
//        
//        pageMenu?.delegate = self
//       
//        self.view.addSubview(pageMenu!.view)
//        
//
//    }
    
    fileprivate func addObserver(){
        /**
         添加通知
         */
  
        NotificationCenter.default.addObserver(self, selector:#selector(updateBageCount), name:NSNotification.Name(rawValue: WOWUpdateCarBadgeNotificationKey), object:nil)
        
        
    }

    override func setUI() {
        super.setUI()
        request()
        configBarItem()
        for index in 0..<titleArray.count {// 默认 为“推荐”
            
            let HomeTabVC = UIStoryboard.initialViewController("Home", identifier:String(describing: WOWController.self)) as! WOWController
            HomeTabVC.title = titleArray[index]
            
            HomeTabVC.delegate = self
            
            controllerArray.append(HomeTabVC)
            
        }
//        let count = CGFloat(titleArray.count)
        
        v                               = VCVTMagic()
        v.magicView.dataSource          = self
        v.magicView.delegate            = self
        
        v.magicView.layoutStyle         = .divide
        v.magicView.switchStyle         = .default
        v.magicView.needPreloading      = false
        v.magicView.sliderWidth         = 50.w
//        v.magicView.sliderExtension     = 10
//        v.magicView.itemWidth           = MGScreenWidth / count
        v.magicView.sliderColor         = WowColor.black
        v.magicView.sliderHeight        = 3.w
//        v.magicView.isSwitchAnimated        = true
        v.magicView.isScrollEnabled         = true
        v.magicView.isMenuScrollEnabled     = true
        self.addChildViewController(v)
        self.view.addSubview(v.magicView)
        
        v.magicView.snp.makeConstraints {[weak self] (make) -> Void in
            if let strongSelf = self {
                make.size.equalTo(strongSelf.view)
                
            }
        }
        
        
//        vc_product    = UIStoryboard.initialViewController("Favorite", identifier:String(describing: WOWFavProduct.self)) as? WOWFavProduct
//        vc_brand    = UIStoryboard.initialViewController("Favorite", identifier:String(describing: WOWFavBrand.self)) as? WOWFavBrand
//        vc_designer = UIStoryboard.initialViewController("Favorite", identifier:String(describing: WOWFavDesigner.self)) as? WOWFavDesigner
//        
//        addChildViewController(vc_product!)
//        addChildViewController(vc_brand!)
//        addChildViewController(vc_designer!)
        
        v.magicView.reloadData()

        
    }
    override func request() {
        super.request()
        requestTabs()
        requestMsgCount()
    }
    func requestTabs(){
        WOWNetManager.sharedManager.requestWithTarget(.api_Home_Tabs, successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            if let strongSelf = self{
//                let json = JSON(result)

                if let array = Mapper<WOWHomeTabs>().mapArray(JSONObject:JSON(result)["tabs"].arrayObject){
//                    if strongSelf.tabs.elementsEqual(array)  {
//                      
//                         print("equal two")
//                    }else {
                        var isEqual = true
                        if strongSelf.tabs.count != array.count {
                            isEqual = false
                        }else {
                            for model  in array.enumerated() {
//                                if strongSelf.tabs.count > model.offset {
                                    let oldModel = strongSelf.tabs[model.offset]
                                    if model.element.id == oldModel.id && model.element.name == oldModel.name {
                                        print("equal")
                                    }else{
                                        isEqual = false
                                        print("new")
                                    }
//                                }else {
//                                    isEqual = false
//                                    print("new")
//                                }
                            }
                        }
                    
                    if isEqual == false {
                        strongSelf.tabs = array
                        
                    }
 
                   
                }
               

            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self {
//                strongSelf.configTabs()
                WOWHud.showMsgNoNetWrok(message: errorMsg)
            }
        }

        
    }
    // 请求消息数量接口
    func requestMsgCount() {
        
        WOWNetManager.sharedManager.requestWithTarget(.api_MessageCount, successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            if let strongSelf = self{
                let json = JSON(result)
                let systemMsg = json["systemMessageUnReadCount"].int
                let userMsg = json["userMessageUnReadCount"].int
                WOWUserManager.systemMsgCount = systemMsg ?? 0
                WOWUserManager.userMsgCount = userMsg ?? 0
                NotificationCenter.postNotificationNameOnMainThread(WOWUpdateCarBadgeNotificationKey, object: nil)
                DLog(json)
                
            }
        }) { (errorMsg) in
            WOWHud.showMsgNoNetWrok(message: errorMsg)
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.e(.Home_Page)
        
        self.navigationShadowImageView?.isHidden = true
     
        self.navigationController?.setNavigationBarHidden(false, animated: true)
//        hidingNavBarManager?.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//          hidingNavBarManager?.viewWillDisappear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        hidingNavBarManager?.viewDidLayoutSubviews()
    }
//    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
//                //              hidingNavBarManager?.shouldScrollToTop()
//                hidingNavBarManager?.shouldScrollToTop()
//            return true
//    }


    fileprivate func configBarItem(){
        configBuyBarItem() // 购物车数量
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension WOWHomeControllers:WOWChideControllerDelegate{
    

//    // 滑动结束 再请求网络
//    func didMoveToPage(_ controller: UIViewController, index: Int){
//        
//        
//        let currentVC = controller as! WOWController
//        if currentVC.isRequest == false { // 如果未请求，才去请求网络。
//            currentVC.request()
//        }
//        
//        
//    }
    func updateTabsRequsetData(){
        print("request ...")
         requestTabs()
    }
}

extension WOWHomeControllers:VTMagicViewDataSource{
    
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
        return titleArray
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
        
//        let vc = magicView.dequeueReusablePage(withIdentifier: self.identifier_magic_view_page)
//        
//        if (vc == nil) {
            print(Int(pageIndex))
            return controllerArray[Int(pageIndex)]
//            if (pageIndex == 0){
//                return vc_product!
//            }else if (pageIndex == 1){
//                return vc_brand!
//            }else{
//                return vc_designer!
//            }
//        }
        
//        return vc!
    }
}

extension WOWHomeControllers:VTMagicViewDelegate{
    func magicView(_ magicView: VTMagicView, viewDidAppear viewController: UIViewController, atPage pageIndex: UInt){
        print("viewDidAppear:", pageIndex);
        
        if let b = magicView.menuItem(at: pageIndex) {
            print("  button asc is ", b)
            
            switch pageIndex {
            case  0:
                
                break
            case  1:
                //                MobClick.e(.Brands_List)
                break
            case  2:
                //                MobClick.e(.Designers_List)
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

