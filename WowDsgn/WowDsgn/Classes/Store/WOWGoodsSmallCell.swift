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
           return (MGScreenWidth) / 2
        }
    }
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        desLabel.preferredMaxLayoutWidth = (MGScreenWidth - CGFloat(0)) / CGFloat(2) - 30
    }
    
    func showData(model:WOWProductModel,indexPath:NSIndexPath) {
        let url             = model.productImage ?? ""
        pictureImageView.kf_setImageWithURL(NSURL(string: url)!, placeholderImage: UIImage(named: "placeholder_product"))
        desLabel.text       = model.productName
        priceLabel.text     = model.price
        switch indexPath.row {
        case 0,1:
            topLine.hidden = false
        default:
            topLine.hidden = true
        }
    }
}
