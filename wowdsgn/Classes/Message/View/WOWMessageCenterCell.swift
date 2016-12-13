//
//  WOWMessageCenterCell.swift
//  wowdsgn
//
//  Created by 安永超 on 16/12/8.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit

class WOWMessageCenterCell: UITableViewCell {
    @IBOutlet weak var newView: UIView!
    @IBOutlet weak var msgImg: UIImageView!
    @IBOutlet weak var msgTitle: UILabel!
    @IBOutlet weak var msgContent: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        newView.setCornerRadius(radius: 4)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
