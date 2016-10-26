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
    @IBOutlet weak var logoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        logoLabel.borderRadius(28)
        // Initialization code
    }
    func showData(_ model:WOWProductModel,indexPath:IndexPath) {
        let url             = model.productImg ?? ""
//        imageView.kf_setImageWithURL(NSURL(string: url)!, placeholderImage: UIImage(named: "placeholder_product"))

        imageView.set_webimage_url( url)
        //默认上架，1上架，2下架
        if model.productStatus == 2 {
            logoLabel.isHidden = false
        }else {
            logoLabel.isHidden = true
        }
        
//        switch indexPath.item {
//        case 0,1:
//            topLine.hidden = false
//        default:
//            topLine.hidden = true
//        }
    }
    
    
}
