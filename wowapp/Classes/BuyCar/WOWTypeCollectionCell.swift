//
//  WOWTypeCollectionCell.swift
//  wowapp
//
//  Created by 安永超 on 16/8/3.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWTypeCollectionCell: UICollectionViewCell {

    @IBOutlet weak var textLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel.layer.cornerRadius = 5
    }
}
