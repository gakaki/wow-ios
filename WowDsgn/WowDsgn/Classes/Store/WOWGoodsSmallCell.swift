//
//  WOWGoodsSmallCell.swift
//  Wow
//
//  Created by 小黑 on 16/4/11.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWGoodsSmallCell: UICollectionViewCell {

    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        WOWBorderColor(contentView)
        desLabel.preferredMaxLayoutWidth = (MGScreenWidth - CGFloat(3)) / CGFloat(2)
    }
    
    func showData() {
        pictureImageView.image = UIImage(named: "testGoods")
        desLabel.text = "无知系列 | 茶桌 无知系列 | 茶桌 无知系列 | 茶桌 无知系列 | 茶桌 无知系列 | 茶桌"
        priceLabel.text = "¥ 10200.00"
    }
    
}
