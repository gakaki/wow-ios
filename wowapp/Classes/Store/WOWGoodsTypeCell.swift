//
//  WOWGoodsTypeCell.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/12.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWGoodsTypeCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var headImageView: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showData(model:WOWProductModel?) {
        titleLabel.text = model?.productName
        summaryLabel.text = model?.sellingPoint
        if let m = model {
            headImageView.kf_setBackgroundImageWithURL(NSURL(string:m.brandLogoImg ?? " ")!, forState: .Normal, placeholderImage:UIImage(named: "placeholder_product"))
        }
    }
    
}
