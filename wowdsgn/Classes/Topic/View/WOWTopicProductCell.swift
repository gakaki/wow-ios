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

    var productId :Int?
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
            productId = model.productId
            
            let img_url            = "\(model.productImg ?? "")?imageView2/0/w/400/format/webp/q/85"
            let url_obj            = URL(string:img_url)
            let image_place_holder = UIImage(named: "placeholder_product")
            
            pictureImageView.yy_setImage(with: url_obj, placeholder: image_place_holder)
            
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

        }
        
    }
    
    @IBAction func buyAction(_ sender: UIButton) {
        VCRedirect.toVCProduct(productId)
    }
    
}
