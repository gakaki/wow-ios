//
//  WOWLeaveTipsController.swift
//  wowapp
//
//  Created by 小黑 on 16/6/1.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWLeaveTipsController: WOWBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: KMPlaceholderTextView!
    
    var photoMange              : UserPhotoManage?  // 记录选择 图片 的信息， 
    var clooseType              : Int = 1
    var commentManage           : UserCommentManage = UserCommentManage() // 记录用户的 操作信息 ，包括 评论， 图片的选择
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setUI() {
        super.setUI()
        navigationItem.title = "意见反馈"
//        view.backgroundColor = UIColor.red
        cofigTableView()
    }
    func cofigTableView()  {
        
        self.tableView.backgroundColor      = GrayColorLevel5
        self.tableView.rowHeight            = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight   = 410
        self.tableView.delegate             = self
        self.tableView.dataSource           = self
        self.tableView.register(UINib.nibName("WOWFeedBackCell"), forCellReuseIdentifier: "WOWFeedBackCell")
        self.tableView.register(UINib.nibName("WOWPushCommentCell"), forCellReuseIdentifier: "WOWPushCommentCell")
        
    }
    
    lazy var footerView: PhoneTextView = {
        let view = PhoneTextView()
        
        return view
    }()

    @IBAction func commitAction(_ sender: Any) {
        
        if !WOWUserManager.loginStatus { // 未登陆状态下， 显示"输入手机"的一栏。 检查是否输入手机，和评论
            // 检车格式是否正确
            if WOWTool.cheakPhone(phontStr: footerView.tvPhone.text) && commentManage.cheackCommentLength(){
                if commentManage.comments == "" {
                    WOWHud.showMsg("请输入反馈内容")
                }else {
                    requestCommitLeave()
                }
                
            }

        }else{// 登陆状态下， 不显示“输入手机”一栏。 检查评论是否 符合要求
            if commentManage.cheackCommentLength(){
                if commentManage.comments == "" {
                    WOWHud.showMsg("请输入反馈内容")
                }else {
                    requestCommitLeave()
                }
                
            }
        }
    }
    func requestCommitLeave()  {
        var params = [String: AnyObject]()
        // 拼接字符串，对应接口的上传格式
        let imgStr = WOWTool.jointImgStr(imgArray: commentManage.commentImgs, spaceStr: ",")
        
        params = ["feedbackType": clooseType as AnyObject, "comments": commentManage.comments as AnyObject,"endUserMobile":footerView.tvPhone.text as AnyObject,"commentImgs":imgStr as AnyObject]
        
        
        WOWNetManager.sharedManager.requestWithTarget(.api_userFeedBack(params:params), successClosure: {[weak self] (result, code) in

                DLog("成功")
            if let strongSelf = self{
                strongSelf.popVC()
            }
            
        }) {[weak self] (errorMsg) in
            if let strongSelf = self {
                strongSelf.endRefresh()
            }
        }

    }
}
extension WOWLeaveTipsController:PushCommentDelegate,TZImagePickerControllerDelegate{
  
    func pushImagePickerController(collectionViewTag: Int){
        
        let imagePickerVc = TZImagePickerController.init(maxImagesCount: 5, columnNumber: 5, delegate: self, pushPhotoPickerVc: true)
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
                        print(urlArray)
                        
                    }
                    
                })
                
            }
        }
        present(imagePickerVc!, animated: true, completion: nil)

    }
}
extension WOWLeaveTipsController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWFeedBackCell", for: indexPath) as! WOWFeedBackCell
            cell.selectionStyle     = .none
//            cell.clooseType         = self.clooseType
            cell.clooseType = {[weak self](type) in
                if let strongSelf = self{
                    strongSelf.clooseType = type ?? 1
                }
            }
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WOWPushCommentCell.self), for: indexPath) as! WOWPushCommentCell
            cell.cellType           = .FeebdBack
            cell.delegate           = self

            cell.userCommentData    = self.commentManage
            
            if let model = photoMange{
                
                cell.showImageView(model)
                
            }else{// 如果无 给空，防止重用导致布局错误
                
                cell.dataImageArr = [UIImage]()
            }

            cell.selectionStyle     = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 15
        case 1:
            if !WOWUserManager.loginStatus {
                return 78
            }else{
                return 0.01
            }
        default:
            return 0.01
            
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
        case 1:
            if !WOWUserManager.loginStatus {
                
                footerView.tvPhone.text = WOWUserManager.userMobile
                return footerView
            }else{
                return nil
            }
//            return footerView
        default:
            return nil
            
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
  
}

class PhoneTextView: UIView {
    
    var tvPhone: UITextField!
    var lbLine : UILabel!

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tvPhone = UITextField()
        
        lbLine  = UILabel()
        lbLine.backgroundColor = GrayColorLevel5
        
        self.addSubview(lbLine)
        self.addSubview(tvPhone)
        self.backgroundColor    = UIColor.white

        tvPhone.placeholder     = "请输入您的联系方式"
        tvPhone.font            = UIFont.systemFont(ofSize: 15)
        tvPhone.keyboardType    = .numberPad

        lbLine.snp.makeConstraints {[weak self] (make) -> Void in
            if  let strongSelf = self {
                
                
                make.width.equalTo(MGScreenWidth)
                make.height.equalTo(15)
                make.top.right.equalTo(strongSelf)
                
            }
            
        }

        tvPhone.snp.makeConstraints {[weak self] (make) -> Void in
            if  let _ = self {
                
                make.width.equalTo(MGScreenWidth)
                make.height.equalTo(63)
                make.top.equalTo(15)
                make.right.equalTo(15)
    
            }
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

