//
//  WOWReviewCell.swift
//  AfterDetail-demo
//
//  Created by 陈旭 on 2017/5/5.
//  Copyright © 2017年 陈旭. All rights reserved.
//

import UIKit
enum StyleType {
    case StyleDetail        // 售后明细
    case StyleProgress      // 售后状态
}
class WOWReviewCell: WOWStyleNoneCell {

    @IBOutlet weak var imgNextArrow: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbReviewType: UILabel!
    var styleType: StyleType = .StyleProgress {
        didSet {
            switch styleType {
            case .StyleDetail:
                lbTitle.text = "售后明细"
                lbReviewType.isHidden   = true
                imgNextArrow.isHidden   = false

            case .StyleProgress:
                lbTitle.text = "售后状态:  "
                lbReviewType.isHidden   = false
                imgNextArrow.isHidden   = true
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
