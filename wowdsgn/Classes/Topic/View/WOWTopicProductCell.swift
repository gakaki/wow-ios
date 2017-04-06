//
//  WOWTopicProductCell.swift
//  wowdsgn
//
//  Created by 安永超 on 17/2/13.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWTopicProductCell: UITableViewCell {
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var originalpriceLabel: UILabel!
    @IBOutlet weak var productBgView: UIView!

//    var productId :Int?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showData(model: WOWProductModel?) {
        if let model = model {
            pictureImageView.set_webimage_url(model.productImg)
            // 修改来回上下加载 内存不减的问题
            desLabel.text = model.productTitle ?? ""
            if let price = model.sellPrice {
                let result = WOWCalPrice.calTotalPrice([price],counts:[1])
                priceLabel.text     = result//千万不用格式化了
                if let originalPrice = model.originalprice,model.originalprice > price{
                    
                    //显示下划线
                    let result = WOWCalPrice.calTotalPrice([originalPrice],counts:[1])
                    originalpriceLabel.setStrokeWithText(result)
                    
                }else {
                    originalpriceLabel.setStrokeWithText("")
                }
            }

            productBgView.addAction {
                VCRedirect.toVCProduct(model.productId)
            }
        }
        
    }

    
}
