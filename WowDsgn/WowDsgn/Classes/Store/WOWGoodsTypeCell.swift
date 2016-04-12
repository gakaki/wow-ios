//
//  WOWGoodsTypeCell.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/12.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWGoodsTypeCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var headImageView: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
     func showData() {
        //FIXME:测试数据
        titleLabel.text = "尖叫君...."
        summaryLabel.text = "结合东方礼仪的设计,特有的内嵌杯垫设计，使得咖啡杯在使用过程中保持静音。采用传统釉料与质朴的陶泥结合。丰富釉面变化，让杯子多一份自然的感觉。"
    }
}
