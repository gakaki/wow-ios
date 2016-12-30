//
//  ColorCVCell.swift
//  wowapp
//
//  Created by 陈旭 on 16/9/23.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class ColorCVCell: UICollectionViewCell {
    @IBOutlet weak var imgColor: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgColor.borderRadius(15.w)
    }

}
