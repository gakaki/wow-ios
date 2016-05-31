//
//  WOWTagCollectionViewCell.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/13.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWTagCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var textLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel.borderRadius(20)
    }

    override var selected: Bool{
        didSet{
            if selected {
                textLabel.backgroundColor = ThemeColor
            }else{
                textLabel.backgroundColor = MGRgb(3, g: 3, b: 3, alpha: 0.1)
            }
        }
    }
    
}
