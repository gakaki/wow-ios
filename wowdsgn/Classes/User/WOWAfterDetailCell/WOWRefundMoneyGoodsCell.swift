//
//  WOWRefundMoneyGoodsCell.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/5/15.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
typealias MaxMoneyStr = (_ str:String) -> ()
class WOWRefundMoneyGoodsCell: WOWStyleNoneCell,UITextFieldDelegate {
    var maxMontyStr:MaxMoneyStr?
    @IBOutlet weak var lbFreight: UILabel!
    @IBOutlet weak var lbMaxRefundMoney: UILabel!
    @IBOutlet weak var tfMoeny: UITextField!
    @IBOutlet weak var lbMark: UILabel!

    
    func showDataUI(afterType:ChooseAfterType,maxAmount:String = "0.0",freight:String = "0.0",orderAmount:Double = 0.0)  {
        switch afterType {
        case .SendNo_AllOrderRefund: // 整单退款 才包含运费
            let result = WOWCalPrice.totalPrice([orderAmount],counts:[1])
            tfMoeny.text                           =  result
            lbFreight.text                         = "含运费" + "¥" + freight
            
            lbMaxRefundMoney.isHidden              = true
            lbFreight.isHidden                     = false
            tfMoeny.isUserInteractionEnabled       = false
            lbMark.isHidden                        = true
        default:
            lbMaxRefundMoney.text   = "最多可退" + maxAmount
            lbFreight.isHidden     = true
            break
        }

    }
    override func awakeFromNib() {
        super.awakeFromNib()
     
        tfMoeny.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
    }
    func textFieldDidChange(_ textField: UITextField) {
        if let maxMontyStr = maxMontyStr {
            
            maxMontyStr(textField.text ?? "")
            
        }

    }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
