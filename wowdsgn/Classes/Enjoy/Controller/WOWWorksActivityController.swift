//
//  WOWWorksActivityController.swift
//  wowdsgn
//
//  Created by 安永超 on 2017/5/2.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWWorksActivityController: WOWBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var publishBtn: UIButton!
    
    let titleCellID = "WOWWorksTitleCell"
    var topicId: Int = 1            //专题id
    var fineWroksArr = [WOWWorksListModel]()        //作品数组
    var topicModel: WOWActivityModel?   //专题model
    let pageSize   = 10     //每页加载多少数据
    var cellHeight: CGFloat = 0     //cell高度
    var titleHeight: CGFloat = 400        //专题高度
    var line = 0                //描述行数
    var sortType: Int = 0       //排序规则
    var itemWidth:CGFloat{
        get{
            return ( MGScreenWidth - 9) / 2
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MobClick.e(.post_picture_activity_page)
    }
    override func setUI() {
        super.setUI()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.mj_header = mj_header
        tableView.mj_footer = mj_footer
        tableView.clearRestCell()
        tableView.register(UINib.nibName(titleCellID), forCellReuseIdentifier:titleCellID)
        self.makeCustomerImageNavigationItem("share-black", left: false, handler: {[weak self] in

            if let strongSelf = self {
                MobClick.e(.share_post_picture_activity_page)
                let shareUrl = WOWShareUrl + "/instagram/community/\(strongSelf.topicId )"
                WOWShareManager.share(strongSelf.topicModel?.subhead, shareText: strongSelf.topicModel?.content, url:shareUrl,shareImage:strongSelf.topicModel?.img ?? UIImage(named: "me_logo")!)
            }

        })

    }

    @IBAction func publishAction(sender: UIButton) {
        guard WOWUserManager.loginStatus else{
            toLoginVC(true)
            return
        }
        cloosePhotos()
    }
    
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
            if let strongSelf = self{
                MobClick.e(.finishpicturebutton)
                UIApplication.shared.statusBarStyle = .default
                
                strongSelf.getDispatchPhoto(asset: asstes?[0] as! PHAsset)
                
            }
        }
        MobClick.e(.select_picture_page)
        present(imagePickerVc!, animated: true, completion: nil)
        
        
    }
    // 异步获取到原图
    func getDispatchPhoto(asset:PHAsset)  {
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
                    FNUtil.currentTopViewController().pushVC(photoTweaksViewController!)
                }else {
                    //                     print("请重新选择照片")
                    WOWHud.showMsg("请您上传大于1000*1000px的照片")
                }
                
            }
        }
    }
    
    //MARK: -- NET
    override func request() {
        super.request()
        
        if pageIndex == 1 {
            requestTitle()
        }else {
            requestList()
        }
        
    }

    func requestList()  {
        
        var params = [String: Any]()
        params = ["categoryId": topicModel?.instagramCategoryId ?? 0 ,"startRows":(pageIndex-1) * 10,"pageSize":pageSize, "sortType": sortType]
        
        WOWNetManager.sharedManager.requestWithTarget(.api_InstagramList(params: params), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            if let strongSelf = self{
                strongSelf.endRefresh()
                
                let arr = Mapper<WOWWorksListModel>().mapArray(JSONObject:JSON(result).arrayObject)
                if let array = arr{
                    
                    if strongSelf.pageIndex == 1{
                        strongSelf.fineWroksArr = []
                    }
                    strongSelf.fineWroksArr.append(contentsOf: array)
                    //如果请求的数据条数小于totalPage，说明没有数据了，隐藏mj_footer
                    if array.count < strongSelf.pageSize {
                        strongSelf.tableView.mj_footer.endRefreshingWithNoMoreData()
                        
                    }else {
                        strongSelf.tableView.mj_footer = strongSelf.mj_footer
                    }
                    
                }else {
                    if strongSelf.pageIndex == 1{
                        strongSelf.fineWroksArr = []
                    }
                    strongSelf.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                //collectionview的行数。用来计算cell高度的
                let rows: Int = Int(strongSelf.fineWroksArr.count/2) + strongSelf.fineWroksArr.count%2
                if rows > 0 {
                    strongSelf.cellHeight = strongSelf.titleHeight + CGFloat(rows) * (strongSelf.itemWidth + 3) + 52
                }else {
                    strongSelf.cellHeight = strongSelf.titleHeight + MGScreenHeight/2 + 52

                }
                strongSelf.tableView.reloadData()
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                WOWHud.showWarnMsg(errorMsg)
                if strongSelf.pageIndex > 1 {
                    strongSelf.pageIndex -= 1
                }
            }
        }
    }
    func requestTitle() {
        WOWNetManager.sharedManager.requestWithTarget(.api_Works_Topic(topicId: topicId), successClosure: {[weak self] (result, code) in
            
            if let strongSelf = self{
                let r                             =  JSON(result)
                strongSelf.topicModel          =  Mapper<WOWActivityModel>().map(JSONObject: r.object )
                //计算label高度
                //标题高度
                let titleH = strongSelf.topicModel?.subhead?.heightWithConstrainedWidth(MGScreenWidth - 30, font: UIFont.mediumScaleFontSize(20), lineSpace: 1) ?? 0
                //内容高度
                var contentH = strongSelf.topicModel?.content?.heightWithConstrainedWidth(MGScreenWidth - 30, font: UIFont.systemFont(ofSize: 15), lineSpace: 1) ?? 0
                //单行高度
                let lineH = (strongSelf.topicModel?.content?.size(UIFont.systemFont(ofSize: 15)).height ?? 1) + 1
                //计算一共多少行
                strongSelf.line = Int(contentH/lineH)
                if strongSelf.line > 4 {
                    contentH = 4 * lineH
                    strongSelf.titleHeight = titleH + contentH + 94 + (strongSelf.topicModel?.picHeight ?? 0)
                }else {
                    strongSelf.titleHeight = titleH + contentH + 55 + (strongSelf.topicModel?.picHeight ?? 0)
                }
                
                //按钮显示状态
                strongSelf.publishBtn.isHidden = false
                switch strongSelf.topicModel?.status ?? 0 {
                case 0:
                    strongSelf.publishBtn.setTitle("活动未开始", for: .normal)
                    let color = UIColor.init(hexString: "#000000", alpha: 0.3)
                    strongSelf.publishBtn.setTitleColor(color, for: .normal)
                    strongSelf.publishBtn.setBackgroundColor(UIColor.init(hexString: "#FFD444")!, forState: .normal)
                    strongSelf.publishBtn.isUserInteractionEnabled = false
                case 1:
                    strongSelf.publishBtn.setTitle("提交作品", for: .normal)
                    strongSelf.publishBtn.setTitleColor(UIColor.black, for: .normal)
                    strongSelf.publishBtn.setBackgroundColor(UIColor.init(hexString: "#FFD444")!, forState: .normal)
                    strongSelf.publishBtn.isUserInteractionEnabled = true

                case 2:
                    strongSelf.publishBtn.setTitle("已结束", for: .normal)
                    strongSelf.publishBtn.setTitleColor(UIColor.init(hexString: "#FFFFFF"), for: .normal)
                    strongSelf.publishBtn.setBackgroundColor(UIColor.init(hexString: "#CCCCCC")!, forState: .normal)
                    strongSelf.publishBtn.isUserInteractionEnabled = false

                default:
                    strongSelf.publishBtn.setTitle("活动未开始", for: .normal)
                    let color = UIColor.init(hexString: "#000000", alpha: 0.3)
                    strongSelf.publishBtn.setTitleColor(color, for: .normal)
                    strongSelf.publishBtn.setBackgroundColor(UIColor.init(hexString: "#FFD444")!, forState: .normal)
                    strongSelf.publishBtn.isUserInteractionEnabled = false

                    
                }
                strongSelf.title = strongSelf.topicModel?.title
                strongSelf.requestList()
            }

        }) { [weak self](errorMsg) in
            if let strongSelf = self{
                strongSelf.requestList()
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
extension WOWWorksActivityController:UITableViewDelegate,UITableViewDataSource, WOWWorksTitleCellDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell                = tableView.dequeueReusableCell(withIdentifier: titleCellID, for: indexPath) as! WOWWorksTitleCell
        cell.showData(topic: topicModel, array: fineWroksArr, lineN: line)
        cell.delegate = self
        return cell

    }
    //delegate:排序呢
    func sortType(sort: Int) {
        sortType = sort
        pageIndex = 1
        requestList()
    }
    

}
extension WOWWorksActivityController:TZImagePickerControllerDelegate,PhotoTweaksViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    func tz_imagePickerControllerDidCancel(_ picker: TZImagePickerController!) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func photoTweaksController(_ controller: PhotoTweaksViewController, didFinishWithCroppedImage croppedImage: UIImage!, clooseSizeImgId sizeId: Int32) {
        

        VCRedirect.goReleaseWorks(photo: croppedImage, instagramCategoryId: topicModel?.instagramCategoryId, sizeImgId:  Int(sizeId), instagramCategoryName: topicModel?.categoryName, type: 1, topicId: topicId, activityName: topicModel?.title)
        
    }
    
    func photoTweaksControllerDidCancel(_ controller: PhotoTweaksViewController) {
        controller.navigationController?.popViewController(animated: true)
        
    }
    
    
}

