//
//  WOWTransLineCell.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/16.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWTransLineCell: UITableViewCell {

    @IBOutlet weak var spotView: UIView!
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        spotView.borderRadius(6)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
