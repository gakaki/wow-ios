//
//  WOWChoiceClassController.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/3/28.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWChoiceClassController: WOWBaseViewController {
    var categoryArr = [WOWEnjoyCategoryModel]()
    @IBOutlet weak var collectionView: UICollectionView!
    var px = (MGScreenWidth - (80 * 3)) / 4
    var instagramCategoryId:Int?
    var btnRright = UIButton()
//    var imgSizeId : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择上传分类"

    
        
        let item = UIBarButtonItem(image:UIImage(named: "nav_backArrow"), style:.plain, target: self, action:#selector(navBack))
        navigationItem.leftBarButtonItem = item
    
        
        // Do any additional setup after loading the view.
    }
    override func setUI() {
        super.setUI()
        
        configCollectionView()
        configNavItem()
        configNextBarItem()
        request()
    }
    func configNextBarItem(){
  
        btnRright = UIButton(frame:CGRect.init(x: 0, y: 0, width: 50, height: 18))
        btnRright.setTitle("下一步", for: .normal)
        btnRright.setTitleColor(UIColor.darkGray, for: .normal)
        btnRright.setTitleColor(UIColor.black, for: .selected)
        btnRright.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        btnRright.isEnabled = true
        btnRright.addTarget(self,action:#selector(nextAction),for:.touchUpInside)
//
        let barItem = UIBarButtonItem.init(customView: btnRright)
        self.navigationItem.rightBarButtonItem = barItem
        btnRright.isEnabled     = false
    }
    func configCollectionView() {
        
        collectionView.register(UINib.nibName(String(describing: WOWChoiseClassCell.self)), forCellWithReuseIdentifier: "WOWChoiseClassCell")
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false


    }
    fileprivate func configNavItem(){
        makeCustomerImageNavigationItem("close", left:true) {[weak self] in
            if let strongSelf = self{

//                    strongSelf.dismiss(animated: true, completion: nil)
                strongSelf.popVC()
                
            }
        }
    }
    override func request() {
        super.request()
    
            WOWNetManager.sharedManager.requestWithTarget(.api_getCategory, successClosure: {[weak self](result, code) in
                WOWHud.dismiss()
                
                if let strongSelf = self{
                    let r                             =  JSON(result)
                    strongSelf.categoryArr          =  Mapper<WOWEnjoyCategoryModel>().mapArray(JSONObject: r.arrayObject ) ?? [WOWEnjoyCategoryModel]()

                    strongSelf.collectionView.reloadData()
        
                }
            }) {[weak self] (errorMsg) in
                if let strongSelf = self{
                    strongSelf.endRefresh()
                    WOWHud.showMsgNoNetWrok(message: errorMsg)
                }
            }
        

    }
    func nextAction()  {
           cloosePhotos()
        
        print("点击了下一步")
    }
    func cloosePhotos() {

                let imagePickerVc = TZImagePickerController.init(maxImagesCount: 1, columnNumber: 5, delegate: self, pushPhotoPickerVc: true)
                imagePickerVc?.isSelectOriginalPhoto            = false
        
                imagePickerVc?.barItemTextColor                 = UIColor.black
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
                imagePickerVc?.allowPreview = false // 不预览图片
                imagePickerVc?.showSelectBtn = true // 展示完成按钮
                imagePickerVc?.didFinishPickingPhotosHandle = {[weak self](images,asstes,isupdete) in
                    if let strongSelf = self,let images = images {
                        
                        UIApplication.shared.statusBarStyle = .default
                        let photoTweaksViewController = PhotoTweaksViewController(image: images[0])
                        photoTweaksViewController?.delegate = strongSelf
                        photoTweaksViewController?.autoSaveToLibray = false

                        
                        imagePickerVc?.pushViewController(photoTweaksViewController!, animated: true)
//
                
                    }
                }

                present(imagePickerVc!, animated: true, completion: nil)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension WOWChoiceClassController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return dataArr.count > 3 ? 3 : dataArr.count
        return categoryArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WOWChoiseClassCell", for: indexPath) as! WOWChoiseClassCell
      
        cell.showData(categoryArr[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
            return CGSize(width: 80 ,height: 127)
    
    }
    //第一个cell居中显示
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(30, px,0, px)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return px
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
        let m = categoryArr[indexPath.row]
        for model in categoryArr {
            if model == m {
                if model.isSelect {
                    btnRright.isSelected    = false
                    btnRright.isEnabled     = false
                    model.isSelect          = false
                    
                }else {
                    btnRright.isSelected    = true
                    btnRright.isEnabled     = true
                    model.isSelect          = true
                    
                }
            }else {
                model.isSelect = false
            }
        }

        
       collectionView.reloadData()
        
    }
    
}


extension WOWChoiceClassController:TZImagePickerControllerDelegate,PhotoTweaksViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
 
    
    func tz_imagePickerControllerDidCancel(_ picker: TZImagePickerController!) {
        picker.dismiss(animated: true, completion: nil)
    }
//    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
//      
//        let photoTweaksViewController = PhotoTweaksViewController(image: photos[0])
//        photoTweaksViewController?.delegate = self
//        photoTweaksViewController?.autoSaveToLibray = true
//  
//        
//        picker?.pushViewController(photoTweaksViewController!, animated: true)
//
//    }
    
    func photoTweaksController(_ controller: PhotoTweaksViewController, didFinishWithCroppedImage croppedImage: UIImage!, clooseSizeImgId sizeId: Int32) {
      
        if categoryArr.count > 0 {
            VCRedirect.bingReleaseWorks(photo: croppedImage, instagramCategoryId: categoryArr[0].id ?? 0, sizeImgId: Int(sizeId))
        }
        
   
    }
    
    func photoTweaksControllerDidCancel(_ controller: PhotoTweaksViewController) {
        controller.navigationController?.popViewController(animated: true)
        
    }
    
    
}
