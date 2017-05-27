//
//  Cell_107_Item.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/3/8.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class Cell_107_Item: UICollectionViewCell {

    @IBOutlet weak var imgProductBanner: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbOriginalPrice: UILabel!
    var model : WOWProductModel? {
        didSet{
            if let imageName = model?.productImg{
                imgProductBanner.set_webimage_url(imageName)
            }
            lbTitle.text = model?.productTitle

            let sellPriceStr = "¥" + String(describing: NSDecimalNumber(value: model?.sellPrice ?? 0))
            lbPrice.text = sellPriceStr
            if let originalPrice = model?.originalprice { // 如果有 原价 且大于现价
                let  originalPriceStr = WOWCalPrice.calTotalPrice([originalPrice ],counts:[1])

                if originalPrice > model?.sellPrice {

                    lbOriginalPrice.setStrokeWithText(originalPriceStr)
                }else{
                    lbOriginalPrice.text = ""
                }
                
            }else{ // 没有原价 则显示现价
                lbOriginalPrice.text = ""
            }

        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
