//
//  WOWGoodsBigCell.swift
//  Wow
//
//  Created by 小黑 on 16/4/8.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

protocol ProductCellDelegate :class{
    func productCellAction(tag:Int,model:WOWProductModel)
}


class WOWGoodsBigCell: UICollectionViewCell {

    @IBOutlet weak var bigPictureImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var desLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var brandButton: UIButton!
    
    @IBOutlet weak var priceBackImageView: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    private var model:WOWProductModel!
    
    weak var delegate : ProductCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func actionButtonClick(sender: UIButton) {
        if let del = self.delegate{
            del.productCellAction(sender.tag, model:self.model)
        }
    }
    
    func showData(model:WOWProductModel){
        self.model = model
        let priceImage = UIImage(named: "yellow_corner_back")
        priceBackImageView.image = priceImage?.stretchableImageWithLeftCapWidth(15, topCapHeight:Int((priceImage?.size.height)!)/2)
        let url = model.productImage ?? ""
        bigPictureImageView.kf_setImageWithURL(NSURL(string:url)!, placeholderImage: UIImage(named: "placeholder_product"))
        titleLabel.text = model.productName
        desLabel.text   = model.productShortDes
        
        let url2 = model.brandImage ?? ""
        brandButton.kf_setImageWithURL(NSURL(string:url2)!, forState:.Normal, placeholderImage:UIImage(named: "placeholder_product"))
        priceLabel.text  = model.price
    }
}
