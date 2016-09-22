//
//  WOWOrderDetailPayCell.swift
//  wowapp
//
//  Created by 陈旭 on 16/8/8.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWOrderDetailPayCell: UITableViewCell {
    @IBOutlet weak var payTypeImageView: UIImageView!
    @IBOutlet weak var payTypeLabel: UILabel!
    @IBOutlet weak var isClooseImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
