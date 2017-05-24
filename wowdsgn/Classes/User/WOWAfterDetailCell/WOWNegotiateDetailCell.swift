//
//  WOWNegotiateDetailCell.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/5/8.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
// 协商详情
class WOWNegotiateDetailCell: WOWStyleNoneCell {
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbContent: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
