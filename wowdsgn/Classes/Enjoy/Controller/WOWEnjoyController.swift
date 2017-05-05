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
    var toMagicPage : Int = 0
    var isOpenRouter : Bool = false
    var categoryArr = [WOWEnjoyCategoryModel]()
    var chooseClassArr = [WOWEnjoyCategoryModel]()
    var vc_newEnjoy:WOWNewEnjoyController?
    var vc_masterpiece:WOWMasterpieceController?
    var isOpen: Bool = false
    var currentCategoryId = 0
    let categoryName = "全部"
    var classId : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .all

        request()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isOpenRouter {
          v.switch(toPage: UInt(toMagicPage), animated: true)
            isOpenRouter = false
        }
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar = true
        super.viewWillAppear(animated)

    }
    lazy var navView:WOWEnjoyNavView = {
        let v = Bundle.main.loadNibNamed(String(describing: WOWEnjoyNavView.self), owner: self, options: nil)?.last as! WOWEnjoyNavView
        v.categoryBtn.addTarget(self, action: #selector(categoryClick), for: .touchUpInside)
        v.lbTitle.text = "全部"
        return v
    }()
    
    lazy var rightNavItem:UIImageView = {
        let v = UIImageView.init(frame: CGRect.init(x: 0, y: 0, w: 50, h: 30))
        v.contentMode = .center
        v.image = UIImage.init(named: "camera_class")
        v.addTapGesture(action: { [weak self](sender) in
            if let strongSelf = self {
                 strongSelf.chooseClassAction()
            }
           
        })
        return v
    }()
    lazy var backView:WOWCategoryBackView = {[unowned self] in
        let v = WOWCategoryBackView(frame:CGRect(x: 0,y: 64,width: MGScreenWidth,height: MGScreenHeight - 64))
        v.selectView.delegate = self
        v.dismissButton.addTarget(self, action: #selector(dismissClick), for:.touchUpInside)
        return v
    }()
    lazy var chooseClassView:WOWChooseClassBackView = {[unowned self] in
//        let v = WOWChooseClassBackView(frame:CGRect(x: 0,y: 0,width: MGScreenWidth,height: MGScreenHeight)) self.chooseClassArr.count
        let v = WOWChooseClassBackView.init(frame: CGRect(x: 0,y: 0,width: MGScreenWidth,height: MGScreenHeight), cellNumber: self.chooseClassArr.count)
        v.dismissButton.addTarget(self, action: #selector(dismissChooseClassClick), for:.touchUpInside)
        v.delegate = self 
        return v
    }()
    override func setUI() {
        super.setUI()
        self.view.backgroundColor = UIColor.white

        v                               = VCVTMagic()
        v.magicView.dataSource          = self
        v.magicView.delegate            = self
        
        v.magicView.layoutStyle         = .center
        v.magicView.switchStyle         = .default
        v.magicView.itemSpacing         = 35
        v.magicView.sliderWidth         = 45.w
        v.magicView.sliderColor         = WowColor.black
        v.magicView.sliderHeight        = 3.w
        v.magicView.isSwitchAnimated        = false
        v.magicView.isScrollEnabled         = true
        v.magicView.isMenuScrollEnabled     = false 
        v.magicView.navigationInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 40)
        v.magicView.leftNavigatoinItem  = navView
        v.magicView.rightNavigatoinItem = rightNavItem
        v.magicView.isAgainstStatusBar = true
        v.magicView.navigationHeight = 44
        v.magicView.isSeparatorHidden = true
        self.addChildViewController(v)
        self.view.addSubview(v.magicView)
        v.magicView.snp.makeConstraints {[weak self] (make) -> Void in
            if let strongSelf = self {
                make.width.equalTo(strongSelf.view)
                make.top.equalTo(strongSelf.view)
                make.bottom.equalTo(strongSelf.view.snp.bottom).offset(0)
                make.left.equalTo(strongSelf.view)
            }
        }
        
        vc_newEnjoy    = UIStoryboard.initialViewController("Enjoy", identifier:String(describing: WOWNewEnjoyController.self)) as? WOWNewEnjoyController
        vc_newEnjoy?.delegate = self
        vc_masterpiece    = UIStoryboard.initialViewController("Enjoy", identifier:String(describing: WOWMasterpieceController.self)) as? WOWMasterpieceController
        vc_masterpiece?.categoryId = self.currentCategoryId
        vc_masterpiece?.delegate = self
        v.magicView.reloadData()

    }
    
    //MARK: -- NetWork
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(.api_getCategory_Has, successClosure: {[weak self](result, code) in
            
            if let strongSelf = self{
                let r                             =  JSON(result)
                strongSelf.categoryArr          =  Mapper<WOWEnjoyCategoryModel>().mapArray(JSONObject: r.arrayObject ) ?? [WOWEnjoyCategoryModel]()
                let category = WOWEnjoyCategoryModel(id: 0, categoryName: strongSelf.categoryName)
                strongSelf.categoryArr.insertAsFirst(category)
                for cate in strongSelf.categoryArr {
                    if cate.id == strongSelf.currentCategoryId {
                        cate.isSelect = true
                        strongSelf.navView.lbTitle.text = cate.categoryName ?? strongSelf.categoryName
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
        requestClass()

    }
    
    
   func requestClass() {
    
        
        WOWNetManager.sharedManager.requestWithTarget(.api_getCategory, successClosure: {[weak self](result, code) in
            WOWHud.dismiss()
            
            if let strongSelf = self{
                let r                             =  JSON(result)
                strongSelf.chooseClassArr          =  Mapper<WOWEnjoyCategoryModel>().mapArray(JSONObject: r.arrayObject ) ?? [WOWEnjoyCategoryModel]()
                strongSelf.chooseClassView.selectView.categoryArr = strongSelf.chooseClassArr
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                WOWHud.showMsgNoNetWrok(message: errorMsg)
            }
        }
        
        
    }
    func chooseClassAction() {
        guard WOWUserManager.loginStatus else{
            toLoginVC(true)
            return
        }
        let window = UIApplication.shared.windows.last
        
        window?.addSubview(chooseClassView)
        window?.bringSubview(toFront: chooseClassView)
        chooseClassView.show()
        
    }
    
    //MARK: --privite 
    func categoryClick()  {
        MobClick.e(.select_classification_masterpiece_page)
        changeButtonState()
    }
    
    func dismissClick()  {
        changeButtonState()

    }
    func dismissChooseClassClick()  {
         chooseClassView.hideView()
        
    }
    //更改箭头
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
                    strongSelf.v.magicView.menuBar?.isHidden = false
                    strongSelf.v.magicView.rightNavigatoinItem?.isHidden = false
                }else {
                    strongSelf.navView.arrowImg.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                    strongSelf.v.magicView.menuBar?.isHidden = true
                    strongSelf.v.magicView.rightNavigatoinItem?.isHidden = true

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
            let width           = 50
            let b               = UIButton(type: .custom)
            b.frame             = CGRect(x: 0, y: 0, width: width, height: 44)
            b.titleLabel!.font  =  UIFont.mediumScaleFontSize(17)
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
                break
            default:
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
        vc_masterpiece?.pageIndex = 1
        vc_masterpiece?.request()
        navView.lbTitle.text = model.categoryName ?? categoryName

        changeButtonState()
    }
    
    func updateTabsRequsetData(){
        request()
    }
}
extension WOWEnjoyController:TZImagePickerControllerDelegate,PhotoTweaksViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func cloosePhotos() {
        
        let imagePickerVc = TZImagePickerController.init(maxImagesCount: 1, columnNumber: 4, delegate: self, pushPhotoPickerVc: true)
        imagePickerVc?.isSelectOriginalPhoto            = false
        
        imagePickerVc?.barItemTextColor                 = UIColor.black
        imagePickerVc?.naviTitleColor                   = UIColor.black
        imagePickerVc?.navigationBar.barTintColor       = UIColor.black
        imagePickerVc?.navigationBar.tintColor          = UIColor.black
        
        imagePickerVc?.navigationController?.navigationBar.isTranslucent = false
        imagePickerVc?.automaticallyAdjustsScrollViewInsets = true
        
        
        imagePickerVc?.allowTakePicture     = true // 拍照按钮将隐藏,用户将不能在选择器中拍照
        imagePickerVc?.allowPickingVideo    = false// 用户将不能选择发送视频
        imagePickerVc?.allowPickingImage    = true // 用户可以选择发送图片
        imagePickerVc?.allowPickingOriginalPhoto = false// 用户不能选择发送原图
        imagePickerVc?.sortAscendingByModificationDate = false// 是否按照时间排序
        imagePickerVc?.autoDismiss = false // 不自动dismiss
        imagePickerVc?.allowPreview = true // 不预览图片
        imagePickerVc?.showSelectBtn = true // 展示完成按钮
        imagePickerVc?.didFinishPickingPhotosHandle = {[weak self](images,asstes,isupdete) in
            if let strongSelf = self,let imagePickerVc = imagePickerVc{
                MobClick.e(.finishpicturebutton)
                UIApplication.shared.statusBarStyle = .default
                
                strongSelf.getDispatchPhoto(asset: asstes?[0] as! PHAsset,nav: imagePickerVc)
                
            }
        }
        MobClick.e(.select_picture_page)
        present(imagePickerVc!, animated: true, completion: nil)
        
        
    }
    // 异步获取到原图
    func getDispatchPhoto(asset:PHAsset,nav:UINavigationController)  {
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: options) {[weak self] (result, info) -> Void in
            if let image = result,let strongSelf = self {
                // 处理获得的图片
                let h = image.size.height
                let w = image.size.width
                if h > 1000 && w > 1000 {
                    let photoTweaksViewController = PhotoTweaksViewController(image: image)
                    photoTweaksViewController?.delegate = strongSelf
                    photoTweaksViewController?.autoSaveToLibray = false
                    
                    nav.pushViewController(photoTweaksViewController!, animated: true)
                }else {
                    //                     print("请重新选择照片")
                    WOWHud.showMsg("请您上传大于1000*1000px的照片")
                }
                
            }
        }
    }
    
    func tz_imagePickerControllerDidCancel(_ picker: TZImagePickerController!) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func photoTweaksController(_ controller: PhotoTweaksViewController, didFinishWithCroppedImage croppedImage: UIImage!, clooseSizeImgId sizeId: Int32) {
        
        if categoryArr.count > 0 {
            VCRedirect.bingReleaseWorks(photo: croppedImage, indexRow: classId ?? 0, sizeImgId: Int(sizeId), categoryArray: chooseClassArr)
        }
        
        
    }
    
    func photoTweaksControllerDidCancel(_ controller: PhotoTweaksViewController) {
        controller.navigationController?.popViewController(animated: true)
        
    }


}

extension WOWEnjoyController:ChooseClassBackDelegate{
    func didSelectItem(_ classId:Int) {
         self.classId = classId
        dismissChooseClassClick()
        cloosePhotos()
    }
}
