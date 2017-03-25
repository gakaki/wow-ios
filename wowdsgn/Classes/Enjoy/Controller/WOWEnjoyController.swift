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
    
    var vc_newEnjoy:WOWNewEnjoyController?
    var vc_masterpiece:WOWMasterpieceController?
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
        v.selectView.delegate = self
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
        vc_masterpiece    = UIStoryboard.initialViewController("Enjoy", identifier:String(describing: WOWMasterpieceController.self)) as? WOWMasterpieceController
        
        v.magicView.reloadData()
    }

    
    //MARK: --privite 
    func categoryClick()  {
        print("全部分类")
        cloosePhotos()
//        changeButtonState()
    }
    
    func cloosePhotos() {
        //判断设置是否支持图片库
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //初始化图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //设置是否允许编辑
            picker.allowsEditing = false
            //弹出控制器，显示界面
            self.present(picker, animated: true, completion: {
                () -> Void in
            })
        }else{
            print("读取相册错误")
        }
//        let imagePickerVc = TZImagePickerController.init(maxImagesCount: 5, columnNumber: 5, delegate: self, pushPhotoPickerVc: true)
//        imagePickerVc?.isSelectOriginalPhoto            = false
//        
//        imagePickerVc?.barItemTextColor                 = UIColor.black
//        imagePickerVc?.navigationBar.barTintColor       = UIColor.black
//        imagePickerVc?.navigationBar.tintColor          = UIColor.black
//        
//        
//
//        imagePickerVc?.allowTakePicture     = true // 拍照按钮将隐藏,用户将不能在选择器中拍照
//        imagePickerVc?.allowPickingVideo    = false// 用户将不能选择发送视频
//        imagePickerVc?.allowPickingImage    = true // 用户可以选择发送图片
//        imagePickerVc?.allowPickingOriginalPhoto = false// 用户不能选择发送原图
//        imagePickerVc?.sortAscendingByModificationDate = false// 是否按照时间排序
//        
//        present(imagePickerVc!, animated: true, completion: nil)

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

extension WOWEnjoyController:TZImagePickerControllerDelegate,PhotoTweaksViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image: UIImage? = (info[UIImagePickerControllerOriginalImage] as? UIImage)
        let photoTweaksViewController = PhotoTweaksViewController(image: image)
        photoTweaksViewController?.delegate = self
        photoTweaksViewController?.autoSaveToLibray = true
        photoTweaksViewController?.maxRotationAngle = .pi
        //        picker.dismiss(animated: true, completion: nil)
        //        self.navigationController?.pushViewController(photoTweaksViewController!, animated: true)
        picker.pushViewController(photoTweaksViewController!, animated: true)
    }
    func photoTweaksController(_ controller: PhotoTweaksViewController, didFinishWithCroppedImage croppedImage: UIImage) {
//            VCRedirect.bingWorksDetails()
        VCRedirect.bingReleaseWorks(photo: croppedImage)
//        controller.navigationController?.popViewController(animated: true)
    }
    
    func photoTweaksControllerDidCancel(_ controller: PhotoTweaksViewController) {
        controller.navigationController?.popViewController(animated: true)
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
        
        let vc = magicView.dequeueReusablePage(withIdentifier: self.identifier_magic_view_page)
        
        if (vc == nil) {
            
            if (pageIndex == 0){
                return vc_masterpiece!
            }else if (pageIndex == 1){
                return vc_newEnjoy!
            }
        }
        
        return vc!
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

extension WOWEnjoyController:WOWSelectCategoryDelegate{
    
    func selectCategory() {
       changeButtonState()
    }
}
