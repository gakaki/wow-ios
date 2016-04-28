//
//  WOWValue1Cell.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/15.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

 /// value1 样式的cell  图片 + label + check

class WOWValue1Cell: UITableViewCell {

    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightCheckButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        rightCheckButton.selected = selected
    }
    
}
