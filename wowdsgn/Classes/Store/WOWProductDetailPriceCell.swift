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
        lbDiscount.isHidden         = true
        lbLabel.isHidden            = true
        for singModel in model?.sings ?? []{
            switch singModel.id ?? 0{
            case 4:
                
                lbLabel.isHidden  = false
                lbLabel.text      = singModel.desc
            case 2:
                lbDiscount.isHidden = false
                lbDiscount.text     = ((singModel.desc ?? "") + "折").get_formted_Space()
            default: break
            }
        }
//        if let discount = model?.discount {
//            lbDiscount.isHidden  = false
//            lbDiscount.text      = (discount + "折").get_formted_Space()
//        }else {
//            lbDiscount.isHidden = true
//            lbDiscount.text = ""
//        }
//        for singModel in model?.sings ?? []{
//            switch singModel.id ?? 0{
//            case 4:
//                
//                lbLabel.isHidden  = false
//                lbLabel.text      = singModel.desc?.get_formted_Space()
//            default: break
//            }
//        }
        if lbDiscount.isHidden && !lbLabel.isHidden{
            
            self.LeftConstraint.constant = 0
            
        }else {
            LeftConstraint.constant = 5
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
