//
//  WOWBaseStyleCell.swift
//  WowDsgn
//
//  Created by 小黑 on 16/5/18.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWBaseStyleCell: UITableViewCell {

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var centerTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
