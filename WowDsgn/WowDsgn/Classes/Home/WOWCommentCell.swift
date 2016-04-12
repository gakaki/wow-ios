//
//  WOWCommentCell.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/21.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWCommentCell: UITableViewCell {

    
    @IBOutlet weak var headImageWidth: NSLayoutConstraint!
    @IBOutlet weak var headImageLeftMargin: NSLayoutConstraint!
    
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func hideHeadImage() {
        headImageView.hidden = true
        headImageWidth.constant = 0
        headImageLeftMargin.constant = 0
    }

}
