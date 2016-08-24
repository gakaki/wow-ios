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
    var orderNewDetailModel : WOWNewOrderDetailModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func showUI(m:WOWNewOrderDetailModel,indexPath:NSIndexPath) {
        orderNewDetailModel = m
        if indexPath.row == 0 {
            let result = WOWCalPrice.calTotalPrice([orderNewDetailModel!.deliveryFee ?? 0],counts:[1])
            self.priceLabel.text       = result
            
            self.saidImageView.hidden  = true
            self.freightTypeLabel.text = "运费"
        }
        if indexPath.row == 1 {
            let result = WOWCalPrice.calTotalPrice([orderNewDetailModel!.couponAmount ?? 0],counts:[1])
            self.priceLabel.text       = "-" + result
            
            self.saidImageView.hidden  = true
            self.freightTypeLabel.text = "优惠券"
        }

    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
