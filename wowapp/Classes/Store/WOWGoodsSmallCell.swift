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
           return ( MGScreenWidth - 0.5) / 2
        }
    }
    
    
    @IBOutlet weak var label_soldout: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var view_rightline: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        desLabel.preferredMaxLayoutWidth = (UIApplication.currentViewController()?.view.w)! / CGFloat(2) - 30
        
    }
    
    func set_sold_out_status(){
        self.label_soldout.hidden = false
//        self.pictureImageView.alpha = 0.4
    }
    
    func showData(model:WOWProductModel,indexPath:NSIndexPath) {
        let i = indexPath.item
//        print(i)
        if ( i % 2 != 0 && i != 0){
            view_rightline.hidden = true
        }else{
            view_rightline.hidden = false
        }
        
        
//        pictureImageView.set_webimage_url(model.productImg ?? "")
        // 修改来回上下加载 内存不减的问题
        pictureImageView.set_webimage_url_base(model.productImg, place_holder_name: "placeholder_product")
        
        let str = NSMutableAttributedString(string: model.productName ?? "")
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.5      //设置1.5倍行距
        style.lineBreakMode = .ByTruncatingTail
        str.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, str.length))
        desLabel.attributedText = str
        let result = WOWCalPrice.calTotalPrice([model.sellPrice ?? 0],counts:[1])
        priceLabel.text     = result//千万不用格式化了
 
    }
}
