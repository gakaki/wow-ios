//
//  WOWMasterpieceController.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/24.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWMasterpieceController: WOWBaseViewController {
    @IBOutlet weak var tableView: UITableView!
    let cellID = String(describing: WOWMasterpieceCell.self)
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationShadowImageView?.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationShadowImageView?.isHidden = false
    }
    override func setUI() {
        super.setUI()
        configTable()
    }
    
    fileprivate func configTable(){
        tableView.estimatedRowHeight = 200
        tableView.rowHeight          = UITableViewAutomaticDimension
        tableView.register(UINib.nibName(cellID), forCellReuseIdentifier:cellID)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.backgroundColor = UIColor.white
        self.tableView.separatorColor = UIColor.white
        
    }
    
    //MARK: -- Action
    //发布
    @IBAction func publishAction(_ sender: UIButton) {
        
        cloosePhotos()
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension WOWMasterpieceController:TZImagePickerControllerDelegate,PhotoTweaksViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
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
extension WOWMasterpieceController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! WOWMasterpieceCell
        
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //            UIApplication.currentViewController()?.bingWorksDetail()
    }

}
