//
//  WOWOnlyRefundViewController.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/5/3.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
enum ChooseAfterType {
    
    case SendNo_OnlyRefund          // 未发货  仅退款
    case SendNo_AllOrderRefund      // 未发货  整单退款
    /*---以发货--*/
    case ExchangGoods               // 换货
    case OnlyRefund                 // 仅退款
    case RefundMoney                // 退货退款
    
}
let goodsType_NO    = "未收到"
let goodsType_YES   = "已收到"
class WOWOnlyRefundViewController: WOWApplyAfterBaseController {

    var commentManage           : UserCommentManage = UserCommentManage() // 记录用户的 操作信息 ，包括 评论， 图片的选择
    var photoMange              : UserPhotoManage?  // 记录选择 图片 的信息，

    var afterType:ChooseAfterType   = .SendNo_OnlyRefund {// 默认仅退款
        didSet{
            switch afterType {
            case .SendNo_OnlyRefund:
                self.title                  = "仅退款"
                params_refundType           = 1
                goodsTypeStr                = goodsType_NO
                chooseReasonArray           = WOWOnlyRefund
            case .SendNo_AllOrderRefund:
                self.title                  = "整单退款"
                self.cellSectionNumber      = 3
                params_refundType           = 1
                goodsTypeStr                = goodsType_NO
                chooseReasonArray           = WOWOnlyRefund
            case .OnlyRefund:
                self.title                  = "仅退款"
                goodsTypeStr                = goodsType_NO
                params_refundType           = 1
                chooseReasonArray           = WOWOnlyRefundNoReceived
            case .RefundMoney:
                self.title                  = "退货退款"
                params_refundType           = 2
                goodsTypeStr                = goodsType_YES
                chooseReasonArray           = WOWRefundAllReceived
            case .ExchangGoods:
                self.title                  = "换货"
                params_refundType           = 3
                goodsTypeStr                = goodsType_YES
                chooseReasonArray           = WOWReturnGoodsReceived
            }
        }
    }
    var chooseReasonArray           : [[Any]] = WOWOnlyRefund
    
    var cellSectionNumber           : Int = 1   //  分组数量，  整单退款 = 3组 ，其他都是 一组
    var freightSectionNumber        : Int = 2   //  运费分组行数， 有改价 = 3  行， 没有改价 = 2行
    var orderCode                   : String!   // 订单号
    var saleOrderItemId             : Int!      // 单个商品 在订单中Id
    var maxAllowedRefundAmount      : String = "0.0" // 最大退款金额
    var deliveryFee                 : String = "0.0" // 运费
    var mainDataModel               : WOWNewOrderDetailModel?{ // 主数据源
        didSet{
            switch mainDataModel?.changedAmountType ?? 0 {
            case 0:
                freightSectionNumber = 2
            default:
                freightSectionNumber = 3
            }

            self.tableView.reloadData()
        }
    }
    var goodsTypeStr                : String = goodsType_NO{ // 货物状态
        didSet{
            if  goodsTypeStr == goodsType_YES {
                switch afterType {
                case .OnlyRefund:
                    chooseReasonArray          = WOWOnlyRefundReceived
                default:
                    break
                }
                goodsTypeIndex = 1
            }else {
                goodsTypeIndex = 0
            }
        }
    }
    var goodsTypeIndex              : Int = 0{
        didSet{
            if goodsTypeIndex == 0 {
                params_received = false
            }else{
                params_received = true
            }
        }
    } // 货物状态在piker Index

    var refundReasonStr             : String? = "请选择退款原因"{ // 退款原因
        didSet{ tableView.reloadData() }
    }
    var refundReasonIndex           : Int = 0 { // 退款原因在 在piker Index
        didSet{
            params_resonId          = chooseReasonArray[refundReasonIndex][0] as! Int
        }
    }
    /* ------params 参数Key -------- */
    var params_received             : Bool      = false
    var params_resonId              : Int       = 0
    var params_maxMoney             : String    = "0.0"
    var params_refundType           : Int       = 1
    /* -------------- */
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    lazy var commitBtn: UIButton = {
        
        let btn = UIButton(frame:CGRect.init(x: 0, y: 0, width: MGScreenWidth, height: 50))
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
        self.bottomView.isHidden = false
        self.bottomView.backgroundColor = tabBackColor
        self.bottomView.addSubview(commitBtn)
        
        tableView.cellId_register("WOWGoodsTypeCell")
        tableView.cellId_register("WOWRefundReasonCell")
        tableView.cellId_register("WOWRefundTextCell")
        tableView.cellId_register("WOWPushCommentCell")
        tableView.cellId_register("WOWRefundMoneyGoodsCell")
        tableView.cellId_register("WOWChooseListCell")
        tableView.cellId_register("WOWOrderDetailCostCell")
        
        request()
    }
    override func request() {
        super.request()
        switch afterType {
        case .SendNo_AllOrderRefund: // 整单退款  传订单号 ，其他同意 用Id
            self.requestCurrentData(itemId: saleOrderItemId,isWholeRefund:true)
        default:
            self.requestCurrentData(itemId: saleOrderItemId)
            break
        }
        
    }
    
    func requestCurrentData(itemId: Int, isWholeRefund: Bool? = nil){
        WOWNetManager.sharedManager.requestWithTarget(.api_GetRefundMoney(saleOrderItemId: itemId, isWholeRefund: isWholeRefund), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            if let strongSelf = self{
                strongSelf.endRefresh()
                let json = JSON(result)
                DLog(json)

                strongSelf.maxAllowedRefundAmount = json["maxAllowedRefundAmount"].stringValue
                strongSelf.deliveryFee            = json["deliveryFee"].stringValue
              
                strongSelf.mainDataModel = Mapper<WOWNewOrderDetailModel>().map(JSONObject:  json["orderDetailResultVo"].object)
                
               
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
//                WOWHud.dismiss()
            }
        }

    }
    func requestCreatRefund(){
        if params_resonId == 0  {
            WOWHud.showMsg("请您填写退款原因")
            return
        }
        if params_maxMoney.hasSuffix(".") == true {
            WOWHud.showMsg("请输入正确格式的金额")
            return
        }
        let moneyArray = params_maxMoney.components(separatedBy: ".")
        if moneyArray.count > 1 {
            let pointNumber = moneyArray[1]
            if pointNumber.length > 2 {
                WOWHud.showMsg("小数点后不超过2位")
                return
            }
        }
        if let maxMoney = params_maxMoney.toFloat(),let maxAmout = maxAllowedRefundAmount.toFloat() {
            switch afterType {
                
            case .SendNo_AllOrderRefund: // 整单退款  用 最大 退款金额 作为参数传递 其他 则使用用户输入金额参数传递
                if maxAmout <= 0 {
                    WOWHud.showMsg("请输入正确的金额")
                    return
                }
            case .ExchangGoods:
                break
            default:
                if maxMoney <= 0 {
                    WOWHud.showMsg("请输入正确的金额")
                    return
                }
                if maxMoney > maxAmout{
                    WOWHud.showMsg("超过最大退款金额")
                    return
                }
                break
            }
        }

        if commentManage.commentsLength > 140 {
            WOWHud.showMsg("退款理由的最大字数为140字，请您删减")
            return
        }
        // 拼接字符串，对应接口的上传格式
        let imgStr = WOWTool.jointImgStr(imgArray: commentManage.commentImgs, spaceStr: ",")
        var params:[String : Any] = [
                                    "saleOrderItemId"   : saleOrderItemId,
                                     "refundType"       : params_refundType,
                                     "refundAmount"     : params_maxMoney,
                                     "received"         : params_received,
                                     "refundReason"     : params_resonId,
                                     "refundRemark"     : commentManage.comments,
                                     "refundImgs"       : imgStr
                                     ]
        
        switch afterType {
        case .SendNo_AllOrderRefund: // 整单退款 传递orderCode 其他 传 ID
            params["isWholeRefund"]         = true
            params["refundAmount"]          = maxAllowedRefundAmount
        default:
            break
        }

        WOWNetManager.sharedManager.requestWithTarget(.api_CreatRefund(params: params as [String : AnyObject]), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            let json = JSON(result)
            DLog(json)
            if let strongSelf = self{
                if code == "0" {
                    if strongSelf.afterType == .SendNo_AllOrderRefund { //整单退款 跳列表
                         VCRedirect.goRefundListController()
                    }else{ // 单个退款跳详情
                      let id = json["saleOrderItemRefundId"].int
                        if let id = id {
                            VCRedirect.goAfterDetail(id)
                        }
                        
                    }
                }
                strongSelf.endRefresh()
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                WOWHud.showMsg(errorMsg ?? "")
                strongSelf.endRefresh()

            }
        }
        

    }
    // MARK: - tableViewDelegate
   override func numberOfSections(in tableView: UITableView) -> Int {
        return cellSectionNumber
    }
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if afterType == .ExchangGoods { return 3}
            return 4
        }
        if section == 1 { return (mainDataModel?.orderItemVos?.count) ?? 0 }
        if section == 2 { return freightSectionNumber }
        return 0
    }
    
    override  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0:
                switch afterType {
                case .SendNo_OnlyRefund,.SendNo_AllOrderRefund,.OnlyRefund,.RefundMoney: // 换货 没有最大退款金额Cell 一栏 其他都有
                    return configSctionCellUI(indexPath:indexPath)
                case .ExchangGoods:
                    return configExchangeSctionCellUI(indexPath:indexPath)
                }
         
            case 1:
                let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWChooseListCell", for: indexPath) as! WOWChooseListCell
                    if let model =  mainDataModel?.orderItemVos?[indexPath.row] {
                        cell.showData(model: model)
                    }
                return cell
            case 2:
                return getCostCell(indexPath:indexPath)
            default:
                return UITableViewCell()
        }
    
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }else if section == 2 {
           return 54
        }else{return 0.01}
    }
    func configFooterView() -> UIView {
        
        let v = UIView.init(x: 0, y: 0, w: MGScreenWidth, h: 54)
        v.backgroundColor = UIColor.white
        let lb = UILabel.initLable("合计", titleColor: GrayFontColor, textAlignment: .left, font: 14)
        lb.frame = CGRect.init(x: 15, y: 0, w: 30, h: 53)
        let result = WOWCalPrice.calTotalPrice([mainDataModel?.orderAmount ?? 0],counts:[1])
        let lbNumber = UILabel.initLable(result, titleColor: UIColor.black, textAlignment: .right, font: 13)
        let lbLine = UILabel.init(frame: CGRect.init(x: 15, y: 0, w: MGScreenWidth - 15, h: 0.5))
        lbLine.backgroundColor = BorderMColor
        v.addSubview(lb)
        v.addSubview(lbNumber)
        v.addSubview(lbLine)
        lbNumber.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(v)
            
        }
        return v

    }
    func configHeaderView() -> UIView {
        
        let v = UIView.init(x: 0, y: 0, w: MGScreenWidth, h: 50)
        v.backgroundColor = UIColor.white
        let lb = UILabel.initLable("以下订单将被取消", titleColor: UIColor.black, textAlignment: .left, font: 16)
        lb.frame = CGRect.init(x: 15, y: 0, w: MGScreenWidth - 15, h: 50)
        let lbLine = UILabel.init(frame: CGRect.init(x: 15, y: 49, w: MGScreenWidth - 15, h: 0.5))
        lbLine.backgroundColor = BorderMColor
        v.addSubview(lb)
        v.addSubview(lbLine)
        return v
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 2 {
            return configFooterView()
        }else{return nil}
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            return configHeaderView()
        }else{return nil}
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 50
        }else{return 0.01}
    }
    // 仅退款 整单退款 布局
    func configSctionCellUI(indexPath: IndexPath) -> UITableViewCell{
        let index = indexPath.row
        switch index {
        case 0:     return getGoodsTypeCell(indexPath)
        case 1:     return getRefundReasonCell(indexPath)
        case 2:     return getRefundMoneyCell(indexPath)
        case 3:     return getInputReasonCell(indexPath)
        default:    return UITableViewCell()
            
        }
    }
    // 换货 布局
    func configExchangeSctionCellUI(indexPath: IndexPath) -> UITableViewCell{
        let index = indexPath.row
        switch index {
        case 0:     return getGoodsTypeCell(indexPath)
        case 1:     return getRefundReasonCell(indexPath)
        case 2:     return getInputReasonCell(indexPath)
        default:    return UITableViewCell()
        }
    }
    //  运费 和 邮费 的 UI
    func getCostCell(indexPath:IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WOWOrderDetailCostCell", for: indexPath) as! WOWOrderDetailCostCell
        if let orderNewDetailModel = mainDataModel {
            cell.freightTypeLabel.textColor = GrayFontColor
            cell.rightConstraint.constant   = 15
            cell.heightConstraint.constant  = 40
            cell.showUI(orderNewDetailModel, indexPath: indexPath)
            
        }
        return cell
    }
    // 货物状态
    func getGoodsTypeCell(_ indexPath:IndexPath) -> UITableViewCell {
        let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWGoodsTypeCell", for: indexPath) as! WOWGoodsTypeCell
        cell.lbType.text        = self.goodsTypeStr
        switch afterType {
        case .SendNo_AllOrderRefund:
            cell.lbSing.isHidden = true
        default:
            cell.lbSing.isHidden = false
        }
        return cell
    }
    // 退款原因 or 退货原因
    func getRefundReasonCell(_ indexPath:IndexPath) -> UITableViewCell {
        let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWRefundReasonCell", for: indexPath) as! WOWRefundReasonCell
        cell.lbRefundReason.text = refundReasonStr
        if refundReasonStr == "请选择退款原因" {
            cell.lbRefundReason.textColor = CCCFontColor
        }else {
            cell.lbRefundReason.textColor = UIColor.black
        }
        return cell
    }
    //  退款金额Cell
    func getRefundMoneyCell(_ indexPath:IndexPath) -> UITableViewCell {
        let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWRefundMoneyGoodsCell", for: indexPath) as! WOWRefundMoneyGoodsCell
        cell.showDataUI(afterType: afterType, maxAmount: maxAllowedRefundAmount, freight: deliveryFee, orderAmount: mainDataModel?.orderAmount ?? 0)
        cell.maxMontyStr = {[unowned self] (maxStr)in
            self.params_maxMoney = maxStr
        }
        return cell
    }
    // 输入说明cell
    func getInputReasonCell(_ indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WOWPushCommentCell.self), for: indexPath) as! WOWPushCommentCell
        cell.cellType           = .RefundReason
        cell.delegate           = self
        cell.userCommentData    = self.commentManage
        if let model = photoMange{
            cell.showImageView(model)
        }else{// 如果无 给空，防止重用导致布局错误
            cell.dataImageArr = [UIImage]()
        }
        switch afterType {
        case .SendNo_OnlyRefund,.SendNo_AllOrderRefund: // 未发货都隐藏   待收货 都出现
            cell.collectionView.isHidden = true
        default:
            cell.collectionView.isHidden = false
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        switch row {
        case 0:
            switch afterType {
            case .OnlyRefund: // 只有 已发货 仅退款 可以选择 其他 不允许修改状态
                break
            default:
                return
            }
            VCRedirect.prentPirckerMask(dataArr: [goodsType_NO,goodsType_YES], startIndex: goodsTypeIndex, block: {[unowned self] (str, index) in
//                print(str,index)
                self.goodsTypeStr = str
                self.goodsTypeIndex = index
                if index == 0 {
                    self.params_received = false
                }else {
                    self.params_received = true
                }
                self.tableView.reloadData()

            })
        case 1:
            var strArray :[String] = []
            for a in chooseReasonArray {
                strArray.append(a[1] as! String)
            }
            VCRedirect.prentPirckerMask(dataArr: strArray, startIndex: refundReasonIndex, block: {[unowned self] (str, index) in
//                print(str,index)
                self.refundReasonStr = str
                self.refundReasonIndex = index
            })

        default:
       
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
                WOWUploadManager.pushCommentPhotos(WOWGetImageInfo.printAssetsName(assets: asstes as [AnyObject], images: images),pushQiNiuPath: .AfterBack, successClosure: {[weak self] (urlArray) in
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

