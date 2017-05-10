//
//  WOWLineFormatCell.swift
//  AfterDetail-demo
//
//  Created by 陈旭 on 2017/5/3.
//  Copyright © 2017年 陈旭. All rights reserved.
//

import UIKit
enum ReviewProgressType {
    case Finished
    case unFinished
}
class WOWLineFormatCell: WOWStyleNoneCell {
    var progressType : ReviewProgressType = .unFinished{
        didSet{
            switch progressType {
            case .Finished:
                lbOne.text          = "退款金额:"
                lbTwo.text          = "退款时间:"
                btnMoney.isHidden   = false
            case .unFinished:
                lbOne.text          = "服务单号:"
                lbTwo.text          = "提交时间:"
                btnMoney.isHidden   = true
            }
        }
    }
    
    @IBOutlet weak var btnMoney: UIButton!
    @IBOutlet weak var lbOne: UILabel!
    @IBOutlet weak var lbTwo: UILabel!
    @IBOutlet weak var lbOneDescribe: UILabel!
    @IBOutlet weak var lbTwoDescribe: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnMoney.addBorder(width: 0.5, color: UIColor.init(hexString: "cccccc")!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}