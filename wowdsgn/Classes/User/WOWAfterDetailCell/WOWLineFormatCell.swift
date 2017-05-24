//
//  WOWLineFormatCell.swift
//  AfterDetail-demo
//
//  Created by 陈旭 on 2017/5/3.
//  Copyright © 2017年 陈旭. All rights reserved.
//

import UIKit
enum LineFormatUIType {
    case ServiceNumber  // 服务单号UI
    case RefundMoney    // 退款金额 UI
}
class WOWLineFormatCell: WOWStyleNoneCell {
    var formatType : LineFormatUIType = .RefundMoney{
        didSet{
            switch formatType {
            case .ServiceNumber:
                lbOne.text          = "服务单号:"
                lbTwo.text          = "提交时间:"
                btnMoney.isHidden   = true

            case .RefundMoney:
                lbOne.text          = "退款金额:"
                lbTwo.text          = "退款时间:"
                btnMoney.isHidden   = false
            }
        }
    }
    
    @IBOutlet weak var btnMoney: UIButton!
    @IBOutlet weak var lbOne: UILabel!
    @IBOutlet weak var lbTwo: UILabel!
    @IBOutlet weak var lbOneDescribe: UILabel!
    @IBOutlet weak var lbTwoDescribe: UILabel!
    var saleOrderItemRefundId:Int!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnMoney.addBorder(width: 0.5, color: UIColor.init(hexString: "cccccc")!)
    }
    
    @IBAction func lookMonryWhere(_ sender: Any) {
        
     VCRedirect.goMoneyFromController(saleOrderItemRefundId)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
