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
        //默认上架，1上架，2下架，10失效
        switch model.productStatus ?? 1 {
        case 1:
            logoLabel.isHidden = true
        case 2:
            logoLabel.text = "已下架"
            logoLabel.isHidden = false
        case 10:
            logoLabel.text = "已失效"
            logoLabel.isHidden = false
        default:
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
