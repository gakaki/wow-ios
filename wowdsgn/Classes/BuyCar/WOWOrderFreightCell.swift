//
//  WOWOrderFreightCell.swift
//  wowapp
//
//  Created by 安永超 on 16/8/4.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWOrderFreightCell: UITableViewCell {
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var freightInfoImage: UIImageView!
    @IBOutlet weak var freightPriceLabel: UILabel!
    @IBOutlet weak var couponLabel: UILabel!
    @IBOutlet weak var nextImage: UIImageView!
    @IBOutlet weak var lineView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}