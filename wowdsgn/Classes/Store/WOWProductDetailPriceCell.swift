//
//  WOWProductDetailPriceCell.swift
//  wowapp
//
//  Created by 小黑 on 16/6/3.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWProductDetailPriceCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var actualPriceLabel: UILabel!
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var lbLabel: UILabel!
    @IBOutlet weak var lbDiscount: UILabel!
    @IBOutlet weak var LeftConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        actualPriceLabel.font   = UIFont.priceFont(22)
        originalPriceLabel.font = UIFont.priceFont(14)
       
        
    }
    func showData(_ model:WOWProductModel?){
        let discoutStr  = "5.5折"
        let labelStr    = "冬季促销"
        lbDiscount.text = discoutStr.get_formted_Space()
        lbLabel.text    = labelStr.get_formted_Space()
        if discoutStr.isEmpty {
            
            lbDiscount.isHidden       = true
            LeftConstraint.constant = 0
            
        }

        nameLabel.text = model?.productTitle ?? ""
        if let price = model?.sellPrice {
            let result = WOWCalPrice.calTotalPrice([price],counts:[1])
            actualPriceLabel.text = result
            if let originalPrice = model?.originalprice {
                if originalPrice > price{
                    //显示下划线
                    let result = WOWCalPrice.calTotalPrice([originalPrice],counts:[1])
                    
                    originalPriceLabel.setStrokeWithText(result)
                    
                }else {
                    originalPriceLabel.text = ""
                }
            }
        }
    
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
