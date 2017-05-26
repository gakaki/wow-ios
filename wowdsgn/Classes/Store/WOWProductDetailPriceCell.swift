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
    @IBOutlet weak var overseaView: UIView!
    @IBOutlet weak var overseaImg: UIImageView!
    @IBOutlet weak var overseaLabel: UILabel!
    
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
                lbLabel.text      = singModel.desc?.get_formted_Space()
            case 2:
                lbDiscount.isHidden = false
                lbDiscount.text     = ((singModel.desc ?? "") + "折").get_formted_Space()
            default: break
            }
        }
        //是否海购商品
        if model?.isOversea ?? false {
            overseaView.isHidden        = false
            let ImgStr = String(format: "countryflags_%i", model?.originCountryId ?? 0)
            let lbStr = model?.logisticsMode == 2 ? "保税区采购": ((model?.originCountry ?? "") + "直邮")
            overseaImg.image = UIImage(named: ImgStr)
            overseaLabel.text = lbStr
        }else {
            overseaView.isHidden        = true

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
