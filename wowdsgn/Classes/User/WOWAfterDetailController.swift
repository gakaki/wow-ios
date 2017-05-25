//
//  WOWAfterDetailController.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/5/5.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
enum CurrentUIStyle{ // 四种风格
    case ReviewingUI    //   审核中 or 申请服务：换货 -- 已确认 之后的UI 没有 钱款去向
    case SureUI         //   已确认 之后的UI 多一行 钱款去向 没有 提交物流信息单号的Cell
    case SendBackUI     //   待用户寄回货物 or 用户提交货物物流单号成功之后 和 ExchangeUI 区别在于 有无 “钱款去向” 的cell
    case ExchangeUI     //   换货 --- 待用户寄回货物 or 用户提交货物物流单号成功之后
}

enum AfterDetailProgress { // 售后明细 进度
    case Reviewing      // 审核中
    case Done           // 已确认 --- 确认之后， 就显示钱款去向UI
    case SendBack       // 待用户回寄商家
    case Sending        // 回寄中
    case AcceptGoods    // 已收货
    case Retunding      // 退款中
    case Finish         // 已完成
    case Rejected       // 已驳回  --- 在审核中 待用户回寄商家 回寄中 可以驳回
    case Cancel         // 已撤销  --- 只能在  审核中 撤销
}
class WOWAfterDetailController: WOWApplyAfterBaseController {
    
    var saleOrderItemRefundId : Int!
    var orderCode             : String!   // 订单号
    var cellStyle   : CurrentUIStyle = .ReviewingUI {
        didSet{
            switch cellStyle {
            case .ExchangeUI:   cellNumberSection = 6
            case .ReviewingUI:  cellNumberSection = 5
            case .SendBackUI:   cellNumberSection = 7
            case .SureUI:       cellNumberSection = 6
            }
        }
    }
    var afterDetailProgress : AfterDetailProgress = .Reviewing {
        didSet{
            cellStyle = configCellStyleUI()
        }
    }
    
    var modelData : WOWRefundDetailModel? {
        didSet{
            switch modelData?.refundStatus  ?? 1 {
            case 1:
                afterDetailProgress = .Reviewing
                break
            case 2:
                afterDetailProgress = .Done
                break
            case 3:
                afterDetailProgress = .SendBack
                break
            case 4:
                afterDetailProgress = .Sending
                break
            case 5:
                afterDetailProgress = .AcceptGoods
                break
            case 6:
                afterDetailProgress = .Retunding
                break
            case 7:
                afterDetailProgress = .Finish
                break
            case 8:
                afterDetailProgress = .Rejected
                break
            case 9:
                afterDetailProgress = .Cancel
                break
            default:
                break
            }
            if afterDetailProgress == .Reviewing {
                self.bottomView.isHidden = false
            }else{
                self.bottomView.isHidden = true
            }
        }
    }
    var cellNumberSection  : Int  = 0 { // UI布局 分组数量 根据不同的状态 不同的数量
        didSet{
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "售后详情"
     
    }
    lazy var cancelBtn: UIButton = {
        
        let btn = UIButton()
        btn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        btn.backgroundColor = tabBackColor
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setTitle("撤销申请", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.addBorder(width: 0.5, color: UIColor(hexString: "#CCCCCC")!)
        return btn
        
    }()
    func cancelAction(){
        WOWNetManager.sharedManager.requestWithTarget(.api_GetCancelRefund(saleOrderItemRefundId: saleOrderItemRefundId), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            let json = JSON(result)
            DLog(json)
            if let strongSelf = self{
                strongSelf.endRefresh()
                if code == "0" {
                    WOWHud.showMsg("撤销申请成功")
                    strongSelf.request()
                }
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                WOWHud.dismiss()
            }
        }
        

    }
    override func setUI() {
        super.setUI()
        self.bottomView.backgroundColor = tabBackColor
        self.bottomView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(35)
            make.right.equalTo(-15)
            make.bottom.equalTo(-8)
        }
        tableView.cellId_register("WOWLineDetaliCell")
        tableView.cellId_register("WOWLineFormatCell")
        tableView.cellId_register("WOWReviewCell")
        tableView.cellId_register("WOWTelCell")
        tableView.cellId_register("WOWReturnGoodsCell")
        tableView.cellId_register("WOWSubmitSuccess")
        
        request()
        
    }
    override func navBack() {
        
        if let nav = self.navigationController {
            if nav.viewControllers.count > 3 {
                _ = navigationController?.popToViewController((navigationController?.viewControllers[2])!, animated: true)
            }else{
                _ = navigationController?.popViewController(animated: true)
            }
        }
    }
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(.api_GetRefundDetail(refundId: saleOrderItemRefundId), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            let json = JSON(result)
            DLog(json)
            if let strongSelf = self{
                
                strongSelf.modelData = Mapper<WOWRefundDetailModel>().map(JSONObject:result)
                strongSelf.endRefresh()
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                WOWHud.dismiss()
            }
        }

    }
    // 配置整个tableView的风格
    func configCellStyleUI() -> CurrentUIStyle{
        let refundType = modelData?.refundType ?? 0  // =1 ：仅退款 。=2 : 退货退款 。 =3 : 换货。 当退货状态为换货时， 都没有 ”钱款去向“ 这一栏cell
        switch afterDetailProgress {
        case .Reviewing,.Cancel:
                return .ReviewingUI
        case .Done:// 确认之后 的UI
            if refundType == 3 {
                return .ReviewingUI
            }
                return .SureUI
        case .Rejected:
            if (modelData?.returnLogisticsCode) != nil { // 说明是在 “回寄中”  被驳回的
                if refundType == 3 {
                    return .ExchangeUI
                }
                    return .SendBackUI
            }else if (modelData?.returnAddress) != nil{ // 说明 是在“待用户回寄商家” 被驳回的
                if refundType == 3 {
                    return .ReviewingUI
                }
                    return .SureUI
            }else { // 说明是在 审核中 被驳回的
                  return .ReviewingUI
            }
        default:
            if refundType == 3 {
                return .ExchangeUI
            }
                return .SendBackUI
        }
    }
    // 审核中 or 申请服务：换货  已确认 之后的UI 没有 钱款去向
    func configReviewing(indexPath: IndexPath) -> UITableViewCell{
        let section = indexPath.section
        switch section {
        case 0: return getLineFormatCell(indexPath: indexPath, formatType: .ServiceNumber)
        case 1: return getReviewCell(indexPath: indexPath)
        case 2: return getReviewCell(indexPath: indexPath,style: .StyleDetail)
        case 3: return getLineDetailCell(indexPath: indexPath)
        case 4: return getCustomerPhoneCell(indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }
    // 已确认 之后的UI 多一行 钱款去向 没有 提交物流信息单号的Cell
    func configSureUI(indexPath: IndexPath) -> UITableViewCell{
        let section = indexPath.section
        switch section {
        case 0: return getLineFormatCell(indexPath: indexPath, formatType: .ServiceNumber)
        case 1: return getReviewCell(indexPath: indexPath)
        case 2: return getLineFormatCell(indexPath: indexPath)
        case 3: return getReviewCell(indexPath: indexPath,style: .StyleDetail)
        case 4: return getLineDetailCell(indexPath: indexPath)
        case 5: return getCustomerPhoneCell(indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }

    // 待用户寄回货物 or 用户提交货物物流单号成功之后
    func configSendBack(indexPath: IndexPath) -> UITableViewCell{
        let section = indexPath.section
        switch section {
        case 0: return getLineFormatCell(indexPath: indexPath, formatType: .ServiceNumber)
        case 1: return getReviewCell(indexPath: indexPath)
        case 2: return getLineFormatCell(indexPath: indexPath)
        case 3: return getReviewCell(indexPath: indexPath,style: .StyleDetail)
        case 4:
            switch afterDetailProgress {
            case .SendBack:
                return getReturnGoodsCell(indexPath: indexPath)
            default:
                return getSubmitSuccessCell(indexPath: indexPath)
            }
        case 5: return getLineDetailCell(indexPath: indexPath)
        case 6: return getCustomerPhoneCell(indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }
    // 换货--- 待用户寄回货物 or 用户提交货物物流单号成功之后
    func configExchangeSendBack(indexPath: IndexPath) -> UITableViewCell{
        let section = indexPath.section
        switch section {
        case 0: return getLineFormatCell(indexPath: indexPath, formatType: .ServiceNumber)
        case 1: return getReviewCell(indexPath: indexPath)
        case 2: return getReviewCell(indexPath: indexPath,style: .StyleDetail)
        case 3:
            switch afterDetailProgress {
            case .SendBack:
                return getReturnGoodsCell(indexPath: indexPath)
            default:
                return getSubmitSuccessCell(indexPath: indexPath)
            }
        case 4: return getLineDetailCell(indexPath: indexPath)
        case 5: return getCustomerPhoneCell(indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
   override func numberOfSections(in tableView: UITableView) -> Int {
        return cellNumberSection
    }
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cellStyle {
            case .ExchangeUI:   return  configExchangeSendBack(indexPath: indexPath)
            case .ReviewingUI:  return  configReviewing(indexPath: indexPath)
            case .SendBackUI:   return  configSendBack(indexPath: indexPath)
            case .SureUI:       return  configSureUI(indexPath: indexPath)
        }
    }

   override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
   override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // 需要帮助 UI
    func getCustomerPhoneCell(indexPath:IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: String(describing: WOWTelCell.self), for: indexPath) as! WOWTelCell
        cell.titleLabel.text = "需要帮助"
        cell.contentView.addTapGesture {[unowned self] (sender) in
//            MobClick.e(.contact_customer_service_order_detail)
            WOWCustomerNeedHelp.show("")
        }
        
        return cell
    }
    // 服务单号 Cell UI, formatType 退款金额 CellUI
    func getLineFormatCell(indexPath:IndexPath,formatType:LineFormatUIType = .RefundMoney) -> UITableViewCell {
        
        let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWLineFormatCell", for: indexPath) as! WOWLineFormatCell
        cell.saleOrderItemRefundId = self.saleOrderItemRefundId
        cell.formatType = formatType
        switch formatType {
        case .ServiceNumber:
            cell.lbOneDescribe.text = modelData?.serviceCode ?? ""
            cell.lbTwoDescribe.text = modelData?.serviceCreateTime ?? ""
        default:
            cell.lbOneDescribe.text = modelData?.actualRefundAmount?.toString ?? ""
            cell.lbTwoDescribe.text = modelData?.refundSuccessTime ?? ""
        }
   
        return cell
    }
    // 申请服务详情 Cell
    func getLineDetailCell(indexPath:IndexPath) -> UITableViewCell{
        
        let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWLineDetaliCell", for: indexPath) as! WOWLineDetaliCell
        cell.applyText          = modelData?.refundTypeName ?? ""
        cell.goodsTypeText      = (modelData?.received ?? false) ? "已收到" : "未收到"
        cell.refundMoneyText    = modelData?.refundAmount?.toString ?? ""
        cell.refundResaonText   = RefundTextArray[modelData?.refundReason ?? 0] ?? ""
        cell.refundDescribeText = modelData?.refundRemark ?? ""
        return cell

    }
    // 审核进度 Cell
    func getReviewCell(indexPath:IndexPath,style:StyleType = .StyleProgress) -> UITableViewCell{
        let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWReviewCell", for: indexPath) as! WOWReviewCell
        cell.lbReviewType.text = modelData?.refundStatusName ?? ""
        cell.styleType          = style
        if style == .StyleDetail {
            cell.addTapGesture {[unowned self] (sender) in
                
                 VCRedirect.goNogotiateDetails(self.saleOrderItemRefundId)
            }
        }
        switch afterDetailProgress {
        case .Reviewing:
                cell.lbReviewType.textColor = UIColor.black
        case .Rejected,.Cancel: // 红色
                cell.lbReviewType.textColor = UIColor.init(hexString: "#FF7070")!
        default:                // 绿色
                cell.lbReviewType.textColor = UIColor.init(hexString: "#5EBF86")!
        }
        return cell
    }
    // 填写物流单号 Cell
    func getReturnGoodsCell(indexPath:IndexPath) -> UITableViewCell{
        let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWReturnGoodsCell", for: indexPath) as! WOWReturnGoodsCell
        cell.lbPhoneNumber.text = modelData?.refundReceivePhone ?? ""
        cell.lbAddressDetail.text = modelData?.returnAddress ?? ""
        cell.lbName.text        = modelData?.refundReceiveName ?? ""
        cell.saleOrderItemRefundId = saleOrderItemRefundId
        cell.lbTime.text        = "请于" + (modelData?.maxRefundableTime ?? "") + "发往以下地址，否则退款将被取消"
        cell.delegate           = self
        return cell
    }
    // 物流信息提交成功 Cell
    func getSubmitSuccessCell(indexPath:IndexPath) -> UITableViewCell{
        let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWSubmitSuccess", for: indexPath) as! WOWSubmitSuccess
        cell.lbCompany.text = modelData?.returnDeliveryCompanyName ?? ""
        cell.lbNumber.text = modelData?.returnLogisticsCode ?? ""
        return cell
    }
}
extension WOWAfterDetailController:WOWReturnGoodsDelegate{
    func submitSuccessAction() {
        request()
    }
}
