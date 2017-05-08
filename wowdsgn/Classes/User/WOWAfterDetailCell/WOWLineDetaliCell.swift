//
//  WOWLineDetaliCell.swift
//  AfterDetail-demo
//
//  Created by 陈旭 on 2017/5/5.
//  Copyright © 2017年 陈旭. All rights reserved.
//

import UIKit

let applyDefaultText             = "申请服务:"
let goodsTypeDefaultText         = "货物状态:"
let refundResaonDefaultText      = "退款原因:"
let refundMoneyDefaultText       = "退款金额:"
extension UILabel {
    func afterDetailFormat(defaultText:String,describeText:String){
        self.strokeWithText(defaultText , str2: describeText , str2Font: 14, str2Color: UIColor.init(hexString: "030303")!)
    }
}
class WOWLineDetaliCell: WOWStyleNoneCell {

    
    var applyText : String = applyDefaultText {
        didSet{
            
            lbApply.afterDetailFormat(defaultText: applyDefaultText, describeText: applyText)
            
        }
    }
    var goodsTypeText : String = goodsTypeDefaultText{
        didSet{
            
            lbGoodsType.afterDetailFormat(defaultText: goodsTypeDefaultText, describeText: goodsTypeText)
            
        }
    }
    var refundResaonText : String = refundResaonDefaultText{
        didSet{
            
            lbRefundResaon.afterDetailFormat(defaultText: refundResaonDefaultText, describeText: refundResaonText)

        }
    }
    var refundMoneyText : String = refundMoneyDefaultText{
        didSet{
            
            lbRefundMoney.afterDetailFormat(defaultText: refundMoneyDefaultText, describeText: refundMoneyText)
            
        }
    }

    @IBOutlet weak var lbApply: UILabel!
    @IBOutlet weak var lbGoodsType: UILabel!
    @IBOutlet weak var lbRefundResaon: UILabel!
    @IBOutlet weak var lbRefundMoney: UILabel!
    @IBOutlet weak var lbDescribe: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
