//
//  WOWUserCommentVC.swift
//  wowdsgn
//
//  Created by 陈旭 on 2016/11/24.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit
// 记录用户选择的图片的数据
class UserPhotoManage: NSObject {
    
    var imageArr = [UIImage]()
    var userIndexSection : Int?
    var assetsArr = [AnyObject]()
    
}

class WOWUserCommentVC: WOWBaseViewController,TZImagePickerControllerDelegate,PushCommentDelegate {
    fileprivate var dataImageArr = [UIImage]()// 存放选择的image对象
    
    var collectionViewOfDataSource = Dictionary<Int, UserPhotoManage>() //空字典,记录每个 cell上面的选择图片的数据
    var orderCode   :String!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }

    override func setUI() {
        self.tableView.register(UINib.nibName("WOWPushCommentCell"), forCellReuseIdentifier: "WOWPushCommentCell")
        self.tableView.delegate             = self
        self.tableView.dataSource           = self
        self.tableView.rowHeight            = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight   = 300
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    lazy var imagePicker:UIImagePickerController = {
//        let v = UIImagePickerController()
//        v.delegate = self
//        return v
//    }()
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
//        
//        print(image)
//        
//        picker.dismiss(animated: true, completion: nil)
//        
//        
//    }
    // 选择照片
    func pushImagePickerController(collectionViewTag: Int)  {
        
        let imagePickerVc = TZImagePickerController.init(maxImagesCount: 5, columnNumber: 5, delegate: self, pushPhotoPickerVc: true)
        imagePickerVc?.isSelectOriginalPhoto            = false
        
        imagePickerVc?.barItemTextColor                 = UIColor.black
        imagePickerVc?.navigationBar.barTintColor       = UIColor.black
        imagePickerVc?.navigationBar.tintColor          = UIColor.black
        
        let model = collectionViewOfDataSource[collectionViewTag]
        
        imagePickerVc?.selectedAssets       = NSMutableArray.init(array: (model?.assetsArr) ?? [])
        imagePickerVc?.allowTakePicture     = true // 拍照按钮将隐藏,用户将不能在选择器中拍照
        imagePickerVc?.allowPickingVideo    = false// 用户将不能选择发送视频
        imagePickerVc?.allowPickingImage    = true // 用户可以选择发送图片
        imagePickerVc?.allowPickingOriginalPhoto = false// 用户不能选择发送原图
        imagePickerVc?.sortAscendingByModificationDate = false// 是否按照时间排序
        
        
        
        imagePickerVc?.didFinishPickingPhotosHandle = {[weak self](images,asstes,isupdete) in
            if let strongSelf = self,let images = images,let asstes = asstes {
                
                let model = UserPhotoManage()
                
                model.imageArr          = images
                model.assetsArr         = asstes as [AnyObject]
                model.userIndexSection  = collectionViewTag
                
                strongSelf.collectionViewOfDataSource[collectionViewTag] = model
                //                let indexPath = NSIndexPath.init(row: 0, section: collectionViewTag)
                //                strongSelf.tableView.reloadRows(at: [indexPath as IndexPath], with: .none)
                strongSelf.tableView.reloadData()
                
            }
        }
        present(imagePickerVc!, animated: true, completion: nil)
    }

}
extension WOWUserCommentVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WOWPushCommentCell.self), for: indexPath) as! WOWPushCommentCell

        let model = self.collectionViewOfDataSource[indexPath.section]

        if let model = model{
            
            cell.showImageView(model)
            
        }else{// 如果无 给空，防止重用导致布局错误
            
            cell.dataImageArr = [UIImage]()
        }
       
        cell.indexPathSection   = indexPath.section
        cell.delegate           = self
        return cell
    }
}
