//
//  WOWProductDetailPriceCell.swift
//  wowapp
//
//  Created by 小黑 on 16/6/3.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWProductDetailPriceCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var actualPriceLabel: UILabel!
    @IBOutlet weak var originalPriceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        actualPriceLabel.font   = UIFont.priceFont(17)
        originalPriceLabel.font = UIFont.priceFont(12)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
