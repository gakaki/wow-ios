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
//        textLabel.borderRadius(20)
        textLabel.layer.borderWidth = 1
        textLabel.layer.borderColor = MGRgb(234, g: 234, b: 234).CGColor
    }

//    override var selected: Bool{
//        didSet{
//            if selected {
//                textLabel.backgroundColor = ThemeColor
//            }else{
//                textLabel.backgroundColor = MGRgb(255, g: 255, b: 255, alpha: 1)
//
//            }
//
//        }
//    
//    }
    
}
