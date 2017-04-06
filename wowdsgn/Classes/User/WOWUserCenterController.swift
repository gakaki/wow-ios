//
//  WOWUserCenterController.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/27.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

import SnapKit
import VTMagic

class WOWUserCenterController: WOWBaseViewController {
    
    var v : VCVTMagic!
    var topIsHidden = false

    var vc_product:WOWWorkController?
    var vc_brand:WOWPraiseController?
    var vc_designer:WOWCollectController?
    
    @IBOutlet weak var selfIntroduction: UILabel!
    @IBOutlet weak var workNum: UILabel!
    @IBOutlet weak var praiseNum: UILabel!
    @IBOutlet weak var favoriteNum: UILabel!
    @IBOutlet weak var userHeadImg: UIImageView!
    @IBOutlet weak var cvTop: NSLayoutConstraint!
    @IBOutlet weak var topView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = WOWUserManager.userName
        request()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func setUI() {
        super.setUI()
        userHeadImg.borderRadius(40)

        v                               = VCVTMagic()
        v.magicView.dataSource          = self
        v.magicView.delegate            = self
        
        v.magicView.layoutStyle         = .divide
        v.magicView.switchStyle         = .default
        v.magicView.sliderWidth         = 30
        v.magicView.sliderColor         = WowColor.black
        v.magicView.sliderHeight        = 3
        v.magicView.isSwitchAnimated        = false
        v.magicView.isScrollEnabled         = true
        self.addChildViewController(v)
        self.view.addSubview(v.magicView)
        v.magicView.snp.makeConstraints {[weak self] (make) -> Void in
            if let strongSelf = self {
                make.width.equalTo(strongSelf.view)
                make.top.equalTo(strongSelf.topView.snp.bottom)
                make.bottom.equalTo(strongSelf.view.snp.bottom).offset(0)
                
            }
        }
        vc_product    = UIStoryboard.initialViewController("NewUser", identifier:String(describing: WOWWorkController.self)) as? WOWWorkController
        vc_brand    = UIStoryboard.initialViewController("NewUser", identifier:String(describing: WOWPraiseController.self)) as? WOWPraiseController
        vc_designer = UIStoryboard.initialViewController("NewUser", identifier:String(describing: WOWCollectController.self)) as? WOWCollectController
        

        v.magicView.reloadData()
    }
    //显示顶部视图
    func showBrand() {
        topIsHidden = false
        view.layoutIfNeeded()
        
        cvTop.constant = 0
        UIView.animate(withDuration: 10) {[weak self] in
            if let strongSelf = self {
                strongSelf.view.layoutIfNeeded()
            }
        }
    }
    
    //隐藏顶部视图
    func hiddenBrand() {
        topIsHidden = true
        view.layoutIfNeeded()
        cvTop.constant = -139
        UIView.animate(withDuration: 0.3) {[weak self] in
            if let strongSelf = self {
                strongSelf.view.layoutIfNeeded()
            }
        }
    }
    //MAERK: Net
    override func request() {
        super.request()
        let param = [String: AnyObject]()
        WOWNetManager.sharedManager.requestWithTarget(.api_UserStatistics(params: param), successClosure: { [weak self](result, code) in
            if let strongSelf = self{
                let model = Mapper<WOWStatisticsModel>().map(JSONObject:result)
                strongSelf.refreshUserInfo(model: model)
            }
            
        }) { (errorMsg) in
            WOWHud.showMsgNoNetWrok(message: errorMsg)
        }
        
    }
    func refreshUserInfo(model: WOWStatisticsModel?) {
        if let model = model {
            self.title = model.nickName
            
            userHeadImg.set_webUserPhotoimage_url(model.avatar ?? "")

            workNum.text = String(format: "%i", model.instagramCounts ?? 0)
            praiseNum.text = String(format: "%i", model.likeCounts ?? 0)
            favoriteNum.text = String(format: "%i", model.collectCounts ?? 0)
            selfIntroduction.text = model.selfIntroduction

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension WOWUserCenterController:VTMagicViewDataSource{
    
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
        return ["","",""]
    }
    func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton{
        
        let button = magicView .dequeueReusableItem(withIdentifier: self.identifier_magic_view_bar_item)
        
        if ( button == nil) {
            let width           = self.view.frame.width / 3
            let b               = UIButton(type: .custom)
            b.frame             = CGRect(x: 0, y: 0, width: width, height: 50)

            if itemIndex == 0 {
                b.setImage(UIImage(named: "upload_select"), for: .selected)
                b.setImage(UIImage(named: "upload_unselect"), for: .normal)
        
            }else if itemIndex == 1 {
                b.setImage(UIImage(named: "img_select"), for: .selected)
                b.setImage(UIImage(named: "img_unselect"), for: .normal)

            }else {
                b.setImage(UIImage(named: "collect_select"), for: .selected)
                b.setImage(UIImage(named: "collect_unselect"), for: .normal)

            }
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
                vc_product?.delegate = self
                return vc_product!
            }else if (pageIndex == 1){
                vc_brand?.delegate = self
                return vc_brand!
            }else{
                vc_designer?.delegate = self
                return vc_designer!
            }

    }
}

extension WOWUserCenterController:VTMagicViewDelegate{
    func magicView(_ magicView: VTMagicView, viewDidAppear viewController: UIViewController, atPage pageIndex: UInt){
        print("viewDidAppear:", pageIndex);
        
        if let b = magicView.menuItem(at: pageIndex),
            let _  = magicView.viewController(atPage: pageIndex) {
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

extension WOWUserCenterController: WOWChideControllerDelegate {
    func updateTabsRequsetData(){
        request()
    }
    
    func topView(isHidden: Bool) {
            if isHidden {
                if !topIsHidden {
                    hiddenBrand()
                }
                
            }else {
                if topIsHidden {
                    showBrand()
                }
            }
        }
        
}
