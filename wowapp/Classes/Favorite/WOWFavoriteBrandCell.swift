//
//  WOWFavoriteBrandCell.swift
//  wowapp
//
//  Created by 安永超 on 16/7/26.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWFavoriteBrandCell: UICollectionViewCell {
    class var itemWidth:CGFloat{
        get{
            return ( MGScreenWidth - 0.5) / 2
        }
    }
    @IBOutlet weak var logoImg:UIImageView!
    @IBOutlet weak var logoName:UILabel!
    @IBOutlet weak var logoDes:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
