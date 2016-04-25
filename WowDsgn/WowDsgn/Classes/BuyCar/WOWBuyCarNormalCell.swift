//
//  WOWBuyCarNormalCell.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/14.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWBuyCarNormalCell: UITableViewCell {

    @IBOutlet weak var checkWidth: NSLayoutConstraint!
    @IBOutlet weak var checkRightSpace: NSLayoutConstraint!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var goodsImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var perPriceLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkButton.selected = selected
    }
    
    @IBAction func checkButtonClick(sender: UIButton) {
        
        
    }
    
    func hideLeftCheck(){
        checkWidth.constant = 0
        checkRightSpace.constant = 0
    }
    
    func showData(model:WOWBuyCarModel) {
        goodsImageView.kf_setImageWithURL(NSURL(string:model.skuProductImageUrl ?? "")!, placeholderImage:UIImage(named: "placeholder_product"))
        nameLabel.text = model.skuProductName
        typeLabel.text = model.skuName
        countLabel.text = "x \(model.skuProductCount)"
        perPriceLabel.text = model.skuProductPrice.priceFormat()
    }
}
