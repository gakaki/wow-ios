//
//  WOWUserCommentVC.swift
//  wowdsgn
//
//  Created by 陈旭 on 2016/11/24.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit
import PhotosUI
import AssetsLibrary
import IQKeyboardManagerSwift
//  bottom cell 、 402 cell
protocol UserCommentSuccesDelegate:class {
    // 跳转产品详情代理
    func reloadTableViewCommentStatus()
    
}
class WOWUserCommentVC: WOWBaseViewController,TZImagePickerControllerDelegate,PushCommentDelegate {
    fileprivate var dataImageArr    = [UIImage]()// 存放选择的image对象
    
    fileprivate var dataArr         = [WOWProductPushCommentModel]()// 列表cell的数据源
    
    fileprivate var commentArr      = [UserCommentManage]() // 存放评论信息的数组
    
    
    fileprivate var productCommentDic : [String:AnyObject]?
    
    weak var delegate : UserCommentSuccesDelegate?
    var collectionViewOfDataSource  = Dictionary<Int, UserPhotoManage>() //空字典,记录每个 cell上面的选择图片的数据
    var orderCode   :String!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "评论"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
    }

    override func setUI() {
        self.tableView.register(UINib.nibName("WOWPushCommentCell"), forCellReuseIdentifier: "WOWPushCommentCell")
        self.tableView.delegate             = self
        self.tableView.dataSource           = self
        self.tableView.rowHeight            = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight   = 300
        self.tableView.backgroundColor      = GrayColorLevel5
        request()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(.api_OrderComment(orderCode: orderCode), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            if let strongSelf = self{
                
                let json = JSON(result)
                DLog(json)
                let bannerList = Mapper<WOWProductPushCommentModel>().mapArray(JSONObject:JSON(result)["saleOrderItemList"].arrayObject)
                
                if let bannerList = bannerList{
                    strongSelf.dataArr = bannerList
                    for commentModel in bannerList {
                        
                        let user = UserCommentManage()// 拿到统一的 评论对象
                        user.saleOrderItemId = commentModel.saleOrderItemId
                        strongSelf.commentArr.append(user)
                    }
                }
                
                strongSelf.endRefresh()
                strongSelf.tableView.reloadData()
                
     
                
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                WOWHud.showMsgNoNetWrok(message: errorMsg)
            }
        }

    }
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
                // 记录铺在CollectionView上面的数据，防止重用机制
                strongSelf.collectionViewOfDataSource[collectionViewTag] = model
                //                let indexPath = NSIndexPath.init(row: 0, section: collectionViewTag)
                //                strongSelf.tableView.reloadRows(at: [indexPath as IndexPath], with: .none)
                
                strongSelf.tableView.reloadData()
               
//                 点击完成即开始上传图片操作  传入 对应图片的信息
                WOWUploadManager.pushCommentPhotos(WOWGetImageInfo.printAssetsName(assets: asstes as [AnyObject], images: images), successClosure: {[weak self] (urlArray) in
                    if let strongSelf = self {
                        // 拿到url数组，赋值给Model数据层
                        strongSelf.commentArr[collectionViewTag].commentImgs = urlArray
                        
                        print(urlArray)
                        
                    }
                
                })

            }
        }
        present(imagePickerVc!, animated: true, completion: nil)
    }
    
    @IBAction func puchClickAction(_ sender: Any) {

        var commentParma      = [[String : Any]]()
        
        for model in self.commentArr{ // 遍历各个商品对应的评论信息
            
                if model.cheackCommentLength() {// 检查评论内容是否满足 需求
                    // 拼接字符串，对应接口的上传格式
                    let imgStr = WOWTool.jointImgStr(imgArray: model.commentImgs, spaceStr: ",")
                    
                    let parma = ["saleOrderItemId":model.saleOrderItemId ?? 0, "comments": model.comments ,"commentImgs":imgStr] as [String : Any]
                    
                    commentParma.append(parma)
                    
                }else if (model.comments == "" && model.commentImgs.count == 0){
 
            
                   
                }else {
                    return
                
                }
  

            
        }
        if commentParma.count > 0 {// 判断是否有评论信息
            requestPushComment(commentParma: commentParma)
        }else {
            WOWHud.showMsg("您的评论内容为空")
        }
        
       
    }
    func  requestPushComment(commentParma: [[String : Any]]){
        
        var params = [String: AnyObject]()
        
        params = ["commentDetails": commentParma as AnyObject]

        WOWHud.showLoadingSV()
        WOWNetManager.sharedManager.requestWithTarget(.api_OrderPushComment(params: params) , successClosure: {[weak self] (result, code) in
//            WOWHud.dismiss()
            if let strongSelf = self{
                if code == "0" {
                    
                   
                    WOWHud.showMsg("发布评论成功！")
                    let delayQueue = DispatchQueue.global()
                    delayQueue.asyncAfter(deadline: .now() + 1.0) {
                        
                        DispatchQueue.main.async {
                            WOWHud.dismiss()
                            strongSelf.popVC()

                        }
                        
                    }
                    if let del = strongSelf.delegate {
                        
                        del.reloadTableViewCommentStatus()
                        
                        
                    }
                    
                }else {
                    WOWHud.showWarnMsg("发布评论失败")
                }
                let json = JSON(result)
                DLog(json)
                
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                WOWHud.showMsgNoNetWrok(message: errorMsg)
            }
        }

    }
}
extension WOWUserCommentVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WOWPushCommentCell.self), for: indexPath) as! WOWPushCommentCell

        
        cell.modelData = self.dataArr[indexPath.section]
        cell.userCommentData = self.commentArr[indexPath.section]
        
        let model = self.collectionViewOfDataSource[indexPath.section]

        if let model = model{
            
            cell.showImageView(model)
            
        }else{// 如果无 给空，防止重用导致布局错误
            
            cell.dataImageArr = [UIImage]()
        }
       
        cell.indexPathSection   = indexPath.section
        cell.delegate           = self
        cell.selectionStyle     = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
////    MARK - 滚动就取消响应 只有scrollView的实际内容大于scrollView的尺寸时才会有滚动事件
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
////        UIApplication.shared.keyWindow?.endEditing(true)
//        self.view.endEditing(true)
//    }
}
