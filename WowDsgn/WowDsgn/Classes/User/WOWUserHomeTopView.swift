//
//  WOWUserHomeTopView.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/16.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWUserHomeTopView: UIView {

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var focusLabel: UILabel!
    @IBOutlet weak var fansLabel: UILabel!
    
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var focusButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageWidth.constant = 76 * scale
        headImageView.borderRadius(76 * scale / 2)
    }
    
    
    
}
