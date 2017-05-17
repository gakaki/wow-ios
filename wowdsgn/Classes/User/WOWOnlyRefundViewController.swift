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

    
    var orderCode                   : String! // 订单号
    var saleOrderItemId             : Int! // 单个商品 在订单中Id
    var maxAllowedRefundAmount      : String = "0.0" // 最大退款金额
    var goodsTypeStr                : String = "未收到"{ // 货物状态
        didSet{
            
            tableView.reloadData()
        }
    }
    var goodsTypeIndex              : Int = 0 // 货物状态在piker Index

    var refundReasonStr             : String? = "请选择退款原因"{ // 退款原因
        didSet{ tableView.reloadData() }
    }
    var refundReasonIndex           : Int = 0 { // 退款原因在 在piker Index
        didSet{
            params_resonId          = WOWOnlyRefund[refundReasonIndex][0] as! Int
        }
    }

    /* ------params 参数Key -------- */
    var params_received             : Bool      = false
    var params_resonId              : Int       = 0
    var params_maxMoney             : String    = "0.0"
    /* -------------- */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "仅退款"
        self.view.insertSubview(commitBtn, aboveSubview: tableView)
        
        // Do any additional setup after loading the view.
    }
    lazy var commitBtn: UIButton = {
        
        let btn = UIButton(frame:CGRect.init(x: 0, y: MGScreenHeight - 64 - 50, width: MGScreenWidth, height: 50))
        btn.addTarget(self, action: #selector(commitClickAction), for: .touchUpInside)
        btn.backgroundColor = YellowColor
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setTitle("提交", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return btn

    }()
    // 提交退换货订单
    func commitClickAction(){
        requestCreatRefund()
    }
    override func setUI() {
        super.setUI()

        tableView.register(UINib.nibName("WOWGoodsTypeCell"), forCellReuseIdentifier: "WOWGoodsTypeCell")
        tableView.register(UINib.nibName("WOWRefundReasonCell"), forCellReuseIdentifier: "WOWRefundReasonCell")
        tableView.register(UINib.nibName("WOWRefundTextCell"), forCellReuseIdentifier: "WOWRefundTextCell")
        tableView.register(UINib.nibName("WOWPushCommentCell"), forCellReuseIdentifier: "WOWPushCommentCell")
        tableView.register(UINib.nibName("WOWRefundMoneyGoodsCell"), forCellReuseIdentifier: "WOWRefundMoneyGoodsCell")
        request()
    }
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(.api_GetRefundMoney(orderCode: orderCode, saleOrderItemId: saleOrderItemId), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            if let strongSelf = self{
                strongSelf.endRefresh()
                let json = JSON(result)
                let maxStr = json["maxAllowedRefundAmount"].stringValue
          
                strongSelf.maxAllowedRefundAmount = maxStr
                strongSelf.tableView.reloadData()
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                WOWHud.dismiss()
            }
        }
        

    }
    func requestCreatRefund(){
        
        let params:[String : Any] = [
//            "orderCode": orderCode,
                                     "saleOrderItemId"  : saleOrderItemId,
                                     "refundType"       : 1,
                                     "refundAmount"     : params_maxMoney,
                                     "received"         : params_received,
                                     "refundReason"     : params_resonId,
                                     "refundRemark"     : commentManage.comments
//                                     "refundImgs":""
                                     ]
        
        WOWNetManager.sharedManager.requestWithTarget(.api_CreatRefund(params: params as [String : AnyObject]), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            let json = JSON(result)
            DLog(json)
            if let strongSelf = self{
                
                strongSelf.endRefresh()
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                WOWHud.dismiss()
            }
        }
        

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
            cell.lbType.text        = self.goodsTypeStr
            return cell
        case 1:
            let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWRefundReasonCell", for: indexPath) as! WOWRefundReasonCell
            cell.lbRefundReason.text = refundReasonStr
            return cell
        case 2:
            let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWRefundMoneyGoodsCell", for: indexPath) as! WOWRefundMoneyGoodsCell
            cell.lbMaxRefundMoney.text = "最多可退" + maxAllowedRefundAmount
            cell.lbFreight.isHidden    = true
            cell.maxMontyStr = {[unowned self] (maxStr)in
//                print(maxStr)
//                if let money = maxStr.toFloat() {
                    self.params_maxMoney = maxStr
//                    print(self.params_maxMoney)
//                }

            }
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
        case 0:
            let vc = WOWBasePickerViewController()
            
            vc.showPicker(arr: ["未收到","已收到"],index: goodsTypeIndex)
            vc.selectBlock = {[unowned self](str,index) in
                print(str,index)
                self.goodsTypeStr = str
                self.goodsTypeIndex = index
                if index == 0 {
                    self.params_received = false
                }else {
                    self.params_received = true
                }
                
            }
            self.presentToMaskViewController(viewControllerToPresent: vc)

        case 1:
            let vc = WOWBasePickerViewController()
            var strArray :[String] = []
            for a in WOWOnlyRefund {
                strArray.append(a[1] as! String)
            }
            vc.showPicker(arr: strArray,index: refundReasonIndex)
            vc.selectBlock = {[unowned self](str,index) in
                print(str,index)
                self.refundReasonStr = str
                self.refundReasonIndex = index
            }
            self.presentToMaskViewController(viewControllerToPresent: vc)

        default:
//            VCRedirect.goAfterDetail()
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

