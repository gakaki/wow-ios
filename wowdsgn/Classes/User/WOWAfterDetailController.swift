//
//  WOWAfterDetailController.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/5/5.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
enum RefundDetailType {
    case Reviewing  // 审核中
    case Successful // 已通过
    case Rejected   // 已驳回
    case Cancel     // 已撤销
}
class WOWAfterDetailController: WOWApplyAfterBaseController {
    
    var saleOrderItemRefundId : Int!
    var refundType: RefundDetailType = .Reviewing
    var modelData : WOWRefundDetailModel?
    var cellNumberSection  : Int  = 4
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
        print("撤销申请")
    }
    override func setUI() {
        super.setUI()
        self.bottomView.isHidden = false
        self.bottomView.backgroundColor = tabBackColor
        self.bottomView.addSubview(cancelBtn)
     
        cancelBtn.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(35)
            make.right.equalTo(-15)
            make.bottom.equalTo(-8)
        }
        
        tableView.register(UINib.nibName("WOWLineDetaliCell"), forCellReuseIdentifier: "WOWLineDetaliCell")
        tableView.register(UINib.nibName("WOWLineFormatCell"), forCellReuseIdentifier: "WOWLineFormatCell")
        tableView.register(UINib.nibName("WOWReviewCell"), forCellReuseIdentifier: "WOWReviewCell")
        tableView.register(UINib.nibName("WOWTelCell"), forCellReuseIdentifier: "WOWTelCell")
        tableView.register(UINib.nibName("WOWReturnGoodsCell"), forCellReuseIdentifier: "WOWReturnGoodsCell")
        request()
        
    }
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(.api_GetRefundDetail(refundId: saleOrderItemRefundId), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            let json = JSON(result)
            DLog(json)
            if let strongSelf = self{
                
                strongSelf.modelData = Mapper<WOWRefundDetailModel>().map(JSONObject:result)
                strongSelf.tableView.reloadData()
                strongSelf.endRefresh()
                
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                WOWHud.dismiss()
            }
        }
        

    }
    // 仅退款
    func configOnlyRefundMoney(indexPath: IndexPath) -> UITableViewCell{
        let section = indexPath.section
        switch section {
        case 0: return getLineFormatCell(indexPath: indexPath)
        case 1: return getReviewCell(indexPath: indexPath)
        case 2: return getLineDetailCell(indexPath: indexPath)
        case 3: return getCustomerPhoneCell(indexPath: indexPath)
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
    
        guard refundType != .Reviewing else {
            return  configOnlyRefundMoney(indexPath: indexPath)
        }
    
        let section = indexPath.section
        switch section {
        case 0:

            return getLineFormatCell(indexPath: indexPath)
            
        case 1:

            return getReviewCell(indexPath: indexPath)
            
        case 2:

            return getLineFormatCell(indexPath: indexPath, formatType: .ServiceNumber)
            
        case 3:
            let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWReviewCell", for: indexPath) as! WOWReviewCell
            
            return cell
        case 4:
            
            return getReturnGoodsCell(indexPath: indexPath)
            
        case 5:
            
            return getLineDetailCell(indexPath: indexPath)
            
        default:
            return getCustomerPhoneCell(indexPath: indexPath)
        }
      
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        VCRedirect.goNogotiateDetails()
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
    // 服务单号 Cell UI, formatType 
    func getLineFormatCell(indexPath:IndexPath,formatType:LineFormatUIType = .RefundMoney) -> UITableViewCell {
        
        let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWLineFormatCell", for: indexPath) as! WOWLineFormatCell
        
        cell.formatType = formatType
        switch formatType {
        case .RefundMoney:
            cell.lbOneDescribe.text = modelData?.serviceCode ?? ""
            cell.lbTwoDescribe.text = modelData?.serviceCreateTime ?? ""
        default:
            cell.lbOneDescribe.text =  modelData?.refundAmount?.toString ?? ""
            cell.lbTwoDescribe.text = "2017-03-10 15:26:23"
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
    func getReviewCell(indexPath:IndexPath) -> UITableViewCell{
        let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWReviewCell", for: indexPath) as! WOWReviewCell
        cell.lbReviewType.text = modelData?.refundStatusName ?? ""
        return cell
    }
    // 填写物流单号 Cell
    func getReturnGoodsCell(indexPath:IndexPath) -> UITableViewCell{
        let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWReturnGoodsCell", for: indexPath) as! WOWReturnGoodsCell
        
        return cell
    }
}
