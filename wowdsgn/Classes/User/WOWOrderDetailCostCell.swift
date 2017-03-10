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
    var orderNewDetailModel : WOWNewOrderDetailModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func showUI(_ m:WOWNewOrderDetailModel,indexPath:IndexPath) {
        orderNewDetailModel = m
        if (indexPath as NSIndexPath).row == 0 {
            let result = WOWCalPrice.calTotalPrice([orderNewDetailModel.deliveryFee ?? 0],counts:[1])
            self.priceLabel.text       = result
            
            self.saidImageView.isHidden  = true
            self.freightTypeLabel.text = "运费"
        }
        if (indexPath as NSIndexPath).row == 1 {
            let result = WOWCalPrice.calTotalPrice([orderNewDetailModel.couponAmount ?? 0],counts:[1])
            self.priceLabel.text       = "-" + result
            
            self.saidImageView.isHidden  = true
            self.freightTypeLabel.text = "优惠"
        }

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
