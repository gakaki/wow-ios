//
//  WOWCategoryCell.swift
//  wowapp
//
//  Created by 安永超 on 16/8/17.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWCategoryCell: UICollectionViewCell {

    class var itemWidth:CGFloat{
        get{
            return ( MGScreenWidth - 0.5) / 2
        }
    }
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        desLabel.preferredMaxLayoutWidth = (UIApplication.currentViewController()?.view.w)! / CGFloat(2) - 30
    }
    
    func showData(model:WOWProductModel,indexPath:NSIndexPath) {
        pictureImageView.set_webimage_url(model.productImg ?? "")
        let str = NSMutableAttributedString(string: model.productName ?? "")
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.5      //设置1.5倍行距
        style.lineBreakMode = .ByTruncatingTail
        str.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, str.length))
        desLabel.attributedText = str
        let result = WOWCalPrice.calTotalPrice([model.sellPrice ?? 0],counts:[1])
        priceLabel.text     = result //千万不用格式化了
        
    }
    
    // 改变cell的背景颜色
    func updateCellStatus( is_selected selected:Bool ){
        
        let alpha                = CGFloat( selected ?  0.4 : 0.2 )
        let borderWidth          = CGFloat( selected ?  1 :  0.8 )
        
        let color                = UIColor.whiteColor().colorWithAlphaComponent(alpha)
       backgroundColor           = color
       layer.borderWidth         = borderWidth
       layer.borderColor         = color.CGColor
       layer.cornerRadius        = 4
    }
}
