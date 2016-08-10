//
//  WOWOrderDetailFourCell.swift
//  wowapp
//
//  Created by 陈旭 on 16/8/8.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWOrderDetailCostCell: UITableViewCell {
    @IBOutlet weak var freightTypeLabel: UILabel!// 邮费 / 优惠券
    @IBOutlet weak var priceLabel: UILabel!// 相关费用
    @IBOutlet weak var saidImageView: UIImageView!// 相关费用
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
