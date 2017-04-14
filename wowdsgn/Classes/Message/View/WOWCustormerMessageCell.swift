//
//  WOWCustormerMessageCell.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/4/14.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWCustormerMessageCell: UITableViewCell {

    @IBOutlet weak var viewMessage: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewMessage.addSubview(WOWCustormMessageView.sharedInstance)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
