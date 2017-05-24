//
//  WOWReturnGoodsCell.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/5/8.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
protocol WOWReturnGoodsDelegate:class {
    func submitSuccessAction()
}
class WOWReturnGoodsCell: WOWStyleNoneCell {
    weak var delegate : WOWReturnGoodsDelegate?
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbLogisticsCompany: UITextField!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbLogisticsNumber: UITextField!
    @IBOutlet weak var lbAddressDetail: UILabel!
    @IBOutlet weak var lbPhoneNumber: UILabel!
    var saleOrderItemRefundId :Int!
    var startIndex : Int?
    var companyStr = "" {
        didSet{
        lbLogisticsCompany.text = companyStr
        }
    }
    var companyNumber = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//           lbLogisticsNumber.addBorder(width: 1, color: UIColor.init(hexString: "eaeaea")!)
         lbLogisticsNumber.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
    }
    func textFieldDidChange(_ textField: UITextField) {
        companyNumber = textField.text ?? ""
    }
    @IBAction func commitClickAction(_ sender: Any) {
//        print("点击提交按钮")

        
        var deliveryCompanyCode = ""
        
        if let startIndex = startIndex {
            deliveryCompanyCode = WOWCompanyCodeArray[startIndex]
        }else {
            WOWHud.showMsg("请填写物流公司")
            return
        }
        if companyNumber == "" {
            WOWHud.showMsg("请填写物流单号")
            return
        }
        let params:[String : Any] = ["saleOrderItemRefundId": saleOrderItemRefundId,
                                     "returnLogisticsCode":companyNumber,
                                     "deliveryCompanyCode":deliveryCompanyCode]
        
   
        WOWNetManager.sharedManager.requestWithTarget(.api_EntryRefundInfo(params: params as [String : AnyObject]), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            let json = JSON(result)
            DLog(json)
            if let strongSelf = self{
                if let del = strongSelf.delegate {
                    del.submitSuccessAction()
                }
                
            }
        }) { (errorMsg) in
            WOWHud.dismiss()
        }

    }

    @IBAction func chooseCompanyAction(_ sender: Any) {
//        print("点击选择物流公司")
        VCRedirect.prentPirckerMask(dataArr: WOWCompanyArray, startIndex: startIndex ?? 0, block: {[unowned self] (str, index) in
            
            self.companyStr = str
            self.startIndex = index
            
        })

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
