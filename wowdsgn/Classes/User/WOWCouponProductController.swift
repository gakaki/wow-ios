//
//  WOWCouponProductController.swift
//  wowdsgn
//
//  Created by 安永超 on 16/12/22.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit
import VTMagic


class WOWCouponProductController: WOWBaseViewController {
    var ob_cid:UInt                                  = 10
    var ob_tab_index:UInt                            = 0
    var index                                   = 0
    var couponId                                = 0
    var navTitle: String?
    
    lazy var v_bottom: VCVTMagic = {
        let v = VCVTMagic()
        v.magicView.dataSource = self
        v.magicView.delegate = self
 
        v.magicView.backgroundColor = UIColor.white
        self.addChildViewController(v)
        v.magicView.frame = CGRect(x: 0, y: 0,width: MGScreenWidth,height: MGScreenHeight - 64)
       
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func setUI() {
        super.setUI()
        navigationItem.title = navTitle
        self.view.addSubview(v_bottom.magicView)
        self.navigationShadowImageView?.isHidden = true
        v_bottom.magicView.reloadData(toPage: 0)
        refreshSubView(0)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
extension WOWCouponProductController:VTMagicViewDataSource{
    
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
        
        
        let button = magicView .dequeueReusableItem(withIdentifier: self.identifier_magic_view_bar_item)
        
        if ( button == nil) {
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
        }
        //
        return button!
        
        
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

extension WOWCouponProductController:VTMagicViewDelegate{
    
    func refreshSubView( _ tab_index:UInt )
    {
        DLog("cid \(ob_cid) tab_index \(tab_index)")
        
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
            
            vc.pageVc        = query_sortBy
            vc.asc           = query_asc
            vc.couponId      = couponId
            vc.pageIndex           = 1 //每次点击都初始化咯
            vc.entrance      = .couponEntrance
            vc.request()
        }
    }
    
    func magicView(_ magicView: VTMagicView, viewDidAppear viewController: UIViewController, atPage pageIndex: UInt){
        self.ob_tab_index = pageIndex
        if abs(index) > 1 {
            refreshSubView(pageIndex)
        }
    }
    
    func magicView(_ magicView: VTMagicView, didSelectItemAt itemIndex: UInt){
        index = Int(ob_tab_index) - Int(itemIndex)
        self.ob_tab_index = itemIndex
        refreshSubView(itemIndex)
    }
    
}

