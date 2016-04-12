//
//  WOWGoodsSmallCell.swift
//  Wow
//
//  Created by 小黑 on 16/4/11.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWGoodsSmallCell: UICollectionViewCell {
     class var itemWidth:CGFloat{
        get{
           return (MGScreenWidth - 3) / 2
        }
    }
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        WOWBorderColor(contentView)
        desLabel.preferredMaxLayoutWidth = (MGScreenWidth - CGFloat(3)) / CGFloat(2) - 30
    }
    
    func showData(model:WOWGoodsModel) {
        //FIXME:测试数据
        pictureImageView.image = UIImage(named: "testGoods")
        desLabel.text = model.des
        priceLabel.text = "¥ 10200.00"
    }
    
}
