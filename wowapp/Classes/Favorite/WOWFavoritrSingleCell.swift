//
//  WOWFavoritrSingleCell.swift
//  wowapp
//
//  Created by 安永超 on 16/7/26.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWFavoritrSingleCell: UICollectionViewCell {
    class var itemWidth:CGFloat{
        get{
            return ( MGScreenWidth - 0.5) / 2
        }
    }
    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var topLine:UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func showData(model:WOWProductModel,indexPath:NSIndexPath) {
        let url             = model.productImg ?? ""
//        imageView.kf_setImageWithURL(NSURL(string: url)!, placeholderImage: UIImage(named: "placeholder_product"))

        imageView.set_webimage_url( url)

        switch indexPath.item {
        case 0,1:
            topLine.hidden = false
        default:
            topLine.hidden = true
        }
    }
}
