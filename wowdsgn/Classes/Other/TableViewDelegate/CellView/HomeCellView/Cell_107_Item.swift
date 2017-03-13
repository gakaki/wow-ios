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
    var model : WOWProductModel? {
        didSet{
            if let imageName = model?.productImg{
                imgProductBanner.set_webimage_url(imageName)
            }
            lbTitle.text = model?.productTitle

            let sellPriceStr = "¥" + ((model?.sellPrice?.toString) ?? "")
            
            if let originalPrice = model?.originalprice { // 如果有 原价 且大于现价
                
                if originalPrice > model?.sellPrice {
                    lbPrice.strokeWithText(sellPriceStr ?? "" , str2: "¥" + originalPrice.toString , str2Font: 11, str2Color: UIColor.init(hexString: "CCCCCC")!)
                }else{
                    lbPrice.text = sellPriceStr
                }
                
            }else{ // 没有原价 则显示现价
                lbPrice.text = sellPriceStr ?? ""
            }

        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
