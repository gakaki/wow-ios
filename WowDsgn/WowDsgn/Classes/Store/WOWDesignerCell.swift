//
//  WOWDesignerCell.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/25.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWDesignerCell: UITableViewCell {

    @IBOutlet weak var designerImageView: UIImageView!
    @IBOutlet weak var designerNameLabel: UILabel!
    @IBOutlet weak var designerDesLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
