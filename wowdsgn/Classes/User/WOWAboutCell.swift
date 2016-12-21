//
//  WOWAboutCell.swift
//  wowdsgn
//
//  Created by 安永超 on 16/12/21.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit

class WOWAboutCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var arrowImg: UIImageView!
    @IBOutlet weak var space: NSLayoutConstraint!
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
