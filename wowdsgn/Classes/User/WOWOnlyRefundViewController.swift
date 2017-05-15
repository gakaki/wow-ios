//
//  WOWOnlyRefundViewController.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/5/3.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWOnlyRefundViewController: WOWApplyAfterBaseController {


    var commentManage           : UserCommentManage = UserCommentManage() // 记录用户的 操作信息 ，包括 评论， 图片的选择
    var photoMange              : UserPhotoManage?  // 记录选择 图片 的信息，
    var reasonArray  = ["不喜欢","不开心","不要了"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "仅退款"
        
        // Do any additional setup after loading the view.
    }
    override func setUI() {
        super.setUI()

        tableView.register(UINib.nibName("WOWGoodsTypeCell"), forCellReuseIdentifier: "WOWGoodsTypeCell")
        tableView.register(UINib.nibName("WOWRefundReasonCell"), forCellReuseIdentifier: "WOWRefundReasonCell")
        tableView.register(UINib.nibName("WOWRefundTextCell"), forCellReuseIdentifier: "WOWRefundTextCell")
        tableView.register(UINib.nibName("WOWPushCommentCell"), forCellReuseIdentifier: "WOWPushCommentCell")

    }
    lazy var backView:WOWPickerBackView = {[unowned self] in
        let v = WOWPickerBackView(frame:CGRect(x: 0,y: 0,width: MGScreenWidth,height: MGScreenHeight))
        v.pickerView.pickerView.delegate = self
        v.pickerView.sureButton.addTarget(self, action:#selector(surePicker), for:.touchUpInside)
        return v
        }()
    
    //显示分类选择
    fileprivate func showPickerView(){
        backView.pickerView.pickerView.selectRow(0, inComponent: 0, animated: true)
        backView.pickerView.pickerView.reloadComponent(0)
        let window = UIApplication.shared.windows.last
        
        window?.addSubview(backView)
        window?.bringSubview(toFront: backView)
        backView.show()
        
    }
    //确认选择
    func surePicker() {
        let row = backView.pickerView.pickerView.selectedRow(inComponent: 0)
//        indexRow = row
//        let model = categoryArr[row]
//        categoryLabel.text = model.categoryName
//        instagramCategoryId = model.id
        backView.hideView()
    }

   override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
  override  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        switch index {
        case 0:
            let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWGoodsTypeCell", for: indexPath) as! WOWGoodsTypeCell
            
            return cell
        case 1:
            let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWRefundReasonCell", for: indexPath) as! WOWRefundReasonCell
            
            return cell
        case 2:
            
            let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWGoodsTypeCell", for: indexPath) as! WOWGoodsTypeCell
            cell.lbGoodsType.text   = "退款金额"
            cell.lbType.text        = "298.00"
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WOWPushCommentCell.self), for: indexPath) as! WOWPushCommentCell
            cell.cellType           = .RefundReason
            cell.delegate           = self
            cell.lbPlaceholder      = "请输入退款说明"
            cell.userCommentData    = self.commentManage
            
            if let model = photoMange{
                
                cell.showImageView(model)
                
            }else{// 如果无 给空，防止重用导致布局错误
                
                cell.dataImageArr = [UIImage]()
            }
            cell.collectionView.isHidden = true

            return cell
            
        }
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        switch row {
        case 1:
          self.showPickerView()
        default:
            VCRedirect.goAfterDetail()
            break
        }
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension WOWOnlyRefundViewController:PushCommentDelegate,TZImagePickerControllerDelegate{
    
    func pushImagePickerController(collectionViewTag: Int){
        
        let imagePickerVc = TZImagePickerController.init(maxImagesCount: 5, columnNumber: 4, delegate: self, pushPhotoPickerVc: true)
        imagePickerVc?.isSelectOriginalPhoto            = false
        
        imagePickerVc?.barItemTextColor                 = UIColor.black
        imagePickerVc?.navigationBar.barTintColor       = UIColor.black
        imagePickerVc?.navigationBar.tintColor          = UIColor.black
        
        //        let model = collectionViewOfDataSource[collectionViewTag]
        
        imagePickerVc?.selectedAssets       = NSMutableArray.init(array: (photoMange?.assetsArr) ?? [])
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
                // 记录铺在CollectionView上面的数据，防止重用机制
                //                strongSelf.collectionViewOfDataSource[collectionViewTag] = model
                
                strongSelf.photoMange   = model
                strongSelf.tableView.reloadData()
                //  点击完成即开始上传图片操作
                WOWUploadManager.pushCommentPhotos(WOWGetImageInfo.printAssetsName(assets: asstes as [AnyObject], images: images),pushQiNiuPath: .FeebdBack, successClosure: {[weak self] (urlArray) in
                    if let strongSelf = self {
                        // 拿到url数组，赋值给Model数据层
                        //                        strongSelf.commentArr[collectionViewTag].commentImgs = urlArray
                        strongSelf.commentManage.commentImgs = urlArray
                        DLog(urlArray)
                        
                    }
                    
                })
                
            }
        }
        present(imagePickerVc!, animated: true, completion: nil)
        
    }
}
extension WOWOnlyRefundViewController: UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reasonArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let model = reasonArray[row]
        return model
        
    }
    
}
