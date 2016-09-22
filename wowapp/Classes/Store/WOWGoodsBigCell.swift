//
//  WOWGoodsBigCell.swift
//  Wow
//
//  Created by 小黑 on 16/4/8.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

protocol ProductCellDelegate :class{
    func productCellAction(_ tag:Int,model:WOWProductModel,cell:WOWGoodsBigCell)
}


class WOWGoodsBigCell: UICollectionViewCell {

    @IBOutlet weak var bigPictureImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var desLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var priceBackImageView: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    fileprivate var model:WOWProductModel!
    
    weak var delegate : ProductCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func actionButtonClick(_ sender: UIButton) {
        if let del = self.delegate{
            del.productCellAction(sender.tag, model:self.model,cell: self)
        }
    }
    
    func showData(_ model:WOWProductModel){
        self.model = model
        let priceImage = UIImage(named: "yellow_corner_back")
        priceBackImageView.image = priceImage?.stretchableImage(withLeftCapWidth: 15, topCapHeight:Int((priceImage?.size.height)!)/2)
        let url = model.productImg ?? ""
//        bigPictureImageView.kf_setImageWithURL(NSURL(string:url)!, placeholderImage: UIImage(named: "placeholder_product"))
        bigPictureImageView.set_webimage_url(url)
        
        titleLabel.text = model.productName
        desLabel.text   = model.sellingPoint
        let result = WOWCalPrice.calTotalPrice([model.sellPrice ?? 0],counts:[1])
        priceLabel.text  = result
    }
}
