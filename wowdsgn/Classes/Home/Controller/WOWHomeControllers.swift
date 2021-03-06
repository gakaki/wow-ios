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
    var controllerArray : [UIViewController] = []
    var selectCurrentIndex : Int? = 0
    var v : VCVTMagic!
    var hidingNavBarManager: HidingNavigationBarManager?
    @IBOutlet weak var magicView: UIView!

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
                 HomeTabVC.TabsIndex = index
                HomeTabVC.delegate = self
                controllerArray.append(HomeTabVC)
            }
            if tabs.count > 0 {
                let count = CGFloat(titleArray.count)
                if count > 5 {
                    v.magicView.layoutStyle         = .default
                    v.magicView.itemSpacing         = 40

                }else {
                    v.magicView.layoutStyle         = .divide
                }


                v.magicView.reloadData()

            }

        }
    }
    var titleArray  = ["推荐"] // 默认 一页
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "titleView"))
        self.view.backgroundColor = UIColor.white
        addObserver()
        // Do any additional setup after loading the view.
    }

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
            HomeTabVC.TabsIndex = index
            controllerArray.append(HomeTabVC)
            
        }
        
        v                               = VCVTMagic()
        v.magicView.dataSource          = self
        v.magicView.delegate            = self
        
        v.magicView.layoutStyle         = .divide
        v.magicView.switchStyle         = .default
        v.magicView.needPreloading      = false
        v.magicView.sliderWidth         = 50.w
        v.magicView.sliderColor         = WowColor.black
        v.magicView.sliderHeight        = 3.w
        v.magicView.isScrollEnabled         = true
        v.magicView.isMenuScrollEnabled     = true
        self.addChildViewController(v)
        self.view.addSubview(v.magicView)
        
        v.magicView.snp.makeConstraints {[weak self] (make) -> Void in
            if let strongSelf = self {
                make.width.equalTo(strongSelf.view)
                make.top.equalTo(strongSelf.magicView)
                make.bottom.equalTo(strongSelf.magicView)
                
            }
        }
        
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

                if let array = Mapper<WOWHomeTabs>().mapArray(JSONObject:JSON(result)["tabs"].arrayObject){

                        var isEqual = true
                        if strongSelf.tabs.count != array.count {
                            isEqual = false
                        }else {
                            for model  in array.enumerated() {
                                    let oldModel = strongSelf.tabs[model.offset]
                                    if model.element.id == oldModel.id && model.element.name == oldModel.name {
                                        DLog("equal")
                                    }else{
                                        isEqual = false
                                        DLog("new")
                                    }

                            }
                        }
                    
                    if isEqual == false {
                        strongSelf.tabs = array
                        
                    }
 
                   
                }
               

            }
        }) {[weak self] (errorMsg) in
            if self != nil {
                WOWHud.showMsgNoNetWrok(message: errorMsg)
            }
        }

        
    }
    // 请求消息数量接口
    func requestMsgCount() {
        
        WOWNetManager.sharedManager.requestWithTarget(.api_MessageCount, successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            if self != nil{
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
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }



    fileprivate func configBarItem(){
        configBuyBarItem() // 购物车数量
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension WOWHomeControllers:WOWChideControllerDelegate, UIGestureRecognizerDelegate{

    func updateTabsRequsetData(){
        DLog("request ...")
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
        DLog("button")
    }
    
    func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController{

        return controllerArray[Int(pageIndex)]

    }
}

extension WOWHomeControllers:VTMagicViewDelegate{
    func magicView(_ magicView: VTMagicView, viewDidAppear viewController: UIViewController, atPage pageIndex: UInt){
        
        if let b = magicView.menuItem(at: pageIndex) {
            
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
        
    }
    
}

