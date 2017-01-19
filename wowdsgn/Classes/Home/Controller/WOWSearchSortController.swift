//
//  WOWSearchSortController.swift
//  wowdsgn
//
//  Created by 安永超 on 17/1/16.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
import VTMagic
import RxSwift

class WOWSearchSortController: BaseScreenViewController{
    
    var isLoadPrice: Bool = false
    var dataArr = [WOWProductModel]()
    var ob_cid                                  = Variable(10)
    var ob_tab_index                            = Variable(UInt(0))
    var index                                   = 0
    var keyword :String = ""
    var brandArray = [WOWBrandV1Model]()
    var brandH: CGFloat = 0
    var brandIsHidden = false

    fileprivate var keyWords = [AnyObject](){
        didSet{
            
        }
    }
    
    fileprivate var searchArray = [String](){
        didSet{
            
        }
    }
    
    //MARK:Life
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    deinit {
        print("销毁")
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
     
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    lazy var v_bottom: VCVTMagic = { [weak self] in
        let v = VCVTMagic()

        if let strongSelf = self {
            v.magicView.dataSource = self
            v.magicView.delegate = self
            v.magicView.backgroundColor = UIColor.white
//            strongSelf.addChildViewController(v)
            v.magicView.frame = CGRect(x: 0, y: strongSelf.brandH,width: MGScreenWidth,height: MGScreenHeight - 64)
        }
        
        return v
    }()
    
    lazy var brandHead: WOWSearchBrandView = {[weak self] in
        let view = Bundle.main.loadNibNamed(String(describing: WOWSearchBrandView.self), owner: self, options: nil)?.last as! WOWSearchBrandView
        if let strongSelf = self {
            view.frame = CGRect(x: 0, y: 0, width: MGScreenWidth, height: strongSelf.brandH + 64)
            view.brandArray = strongSelf.brandArray
            print(view.frame.height)
        }
        return view
        
    }()
    
    //MARK:Private Method
    override func setUI() {
        super.setUI()
        configBrand()
        configScreen()
        self.view.backgroundColor = UIColor.white
        self.view.insertSubview(v_bottom.magicView, belowSubview: screenBtnimg)
        
        
        //         self.view.insertSubview(emptyView, belowSubview: screenBtnimg)
    }
    
    func configBrand() {
        if self.brandArray.count > 0 {
            brandH = CGFloat(45 + brandArray.count * 60)
            self.view.addSubview(brandHead)
        }
    }
    
    func configScreen() {
        screenView.screenAction = {[unowned self] (dic) in
            print(dic)
            let dicResult = dic as! [String:AnyObject]
            if dicResult["colorList"] != nil{
                self.screenColorArr  = dicResult["colorList"] as? [String]
            }else{
                self.screenColorArr?.removeAll()
            }
            if dicResult["priceObj"] != nil {
                self.screenPriceArr  = dicResult["priceObj"] as! Dictionary
                self.screenMinPrice = self.screenPriceArr["minPrice"]
                self.screenMaxPrice = self.screenPriceArr["maxPrice"]
            }else{
                self.screenMinPrice = nil
                self.screenMaxPrice = nil
            }
            
            if dicResult["styleList"] != nil{
                self.screenStyleArr  = dicResult["styleList"] as? [String]
            }else{
                self.screenStyleArr?.removeAll()
            }
            
            self.refreshSubView(self.ob_tab_index.value)
        }
    }
    
    func showBrand() {
        brandIsHidden = false
        UIView.animate(withDuration: 0.3) {[weak self] in
            if let strongSelf = self {
                strongSelf.brandHead.frame = CGRect(x: 0, y: 0, width: MGScreenWidth, height: strongSelf.brandH)
                strongSelf.v_bottom.magicView.frame = CGRect(x: 0, y: strongSelf.brandH,width: MGScreenWidth,height: MGScreenHeight - 64)
                
            }
        }
    }
    
    func hiddenBrand() {
        brandIsHidden = true
        UIView.animate(withDuration: 0.3) {[weak self] in
            if let strongSelf = self {
                strongSelf.brandHead.frame = CGRect(x: 0, y: -strongSelf.brandH, width: MGScreenWidth, height: strongSelf.brandH)
                strongSelf.v_bottom.magicView.frame = CGRect(x: 0, y: 0,width: MGScreenWidth,height: MGScreenHeight - 64)
                
            }
        }
    }

}




/**********************搜索结果的searchView********************************/


extension WOWSearchSortController:VTMagicViewDataSource{
    
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
    override func vtm_prepareForReuse() {
        
    }
    //获取所有菜单名，数组中存放字符串类型对象
    func menuTitles(for magicView: VTMagicView) -> [String] {
        return ["上新","销量","价格"]
    }
    func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton{
        
        
        //        let button = magicView .dequeueReusableItem(withIdentifier: self.identifier_magic_view_bar_item)
        
        //        if ( button == nil) {
        //
        let b = TooglePriceBtn(title:"价格\(itemIndex)",frame: CGRect(x: 0, y: 0, width: self.view.frame.width / 3, height: 50)) { (asc) in
            print("you clicket status is "  , asc)
        }
        b.btnIndex = itemIndex
        if ( itemIndex <= 1) {
            b.image_is_show = false
        }else{
            b.image_is_show = true
        }
        return b
        //
        //        }
        //
        //        return button!
        
        
    }
    
    func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController{
        
        let vc = magicView.dequeueReusablePage(withIdentifier: self.identifier_magic_view_page)
        
        if ((vc == nil)) {
            
            let vc_me = UIStoryboard.initialViewController("Home", identifier:String(describing: WOWSearchChildController.self)) as! WOWSearchChildController
            addChildViewController(vc_me)

            return vc_me
        }
        
        return vc!;
    }
    func touchClick(_ btn:UIButton){
        DLog(btn.state)
    }
}

extension WOWSearchSortController:VTMagicViewDelegate, WOWSearchChildControllerDelegate{
    
    func refreshSubView( _ tab_index:UInt )
    {
        DLog("cid \(ob_cid.value) tab_index \(tab_index)")
        
        if let b    = self.v_bottom.magicView.menuItem(at: tab_index) as? TooglePriceBtn ,
            let vc  = self.v_bottom.magicView.viewController(atPage: tab_index) as? WOWSearchChildController
        {
            let query_sortBy       = Int(tab_index) + 1 //从0开始呀这个 viewmagic的 tab_index
            //            let query_cid          = ob_cid.value
            var query_asc          = 0
            if ( tab_index == 2){ //价格的话用他的排序 其他 正常升序
                if b.asc {
                    query_asc = 1
                }else {
                    query_asc = 0
                }
            }else{
                query_asc          = 0
            }
            
            vc.pageVc           = query_sortBy
            vc.asc              = query_asc
            vc.seoKey           = keyword
            vc.pageIndex        = 1 //每次点击都初始化咯
            vc.entrance         = .searchEntrance
            vc.screenMinPrice     = self.screenMinPrice
            vc.screenMaxPrice     = self.screenMaxPrice
            vc.screenColorArr     = self.screenColorArr
            vc.screenStyleArr     = self.screenStyleArr
            vc.delegate = self
            
            vc.request()
        }
    }
    
    func magicView(_ magicView: VTMagicView, viewDidAppear viewController: UIViewController, atPage pageIndex: UInt){
        self.ob_tab_index.value = pageIndex
        if abs(index) > 1 {
            refreshSubView(pageIndex)
        }
    }
    
    func magicView(_ magicView: VTMagicView, didSelectItemAt itemIndex: UInt){
        index = Int(ob_tab_index.value) - Int(itemIndex)
        self.ob_tab_index.value = itemIndex
        refreshSubView(itemIndex)
    }
    
    func brandView(isHidden: Bool) {
        if isHidden {
            if !brandIsHidden {
                hiddenBrand()
            }
            
        }else {
            if brandIsHidden {
                showBrand()
            }
        }
    }
    
}
