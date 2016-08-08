//
//  WOWGoodsDetailCell.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/12.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWGoodsDetailCell: UITableViewCell {

    @IBOutlet weak var cellHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var goodsImageView: UIImageView!
    @IBOutlet weak var goodsDesLabel: UILabel!
    @IBOutlet weak var itemSpacing: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func showData(model:WOWProductPicTextModel?) {
        goodsDesLabel.text = model?.text
        if let title = model?.text where title.isEmpty {
            itemSpacing.constant = 0
        }
        guard let imageUrl = model?.image where !imageUrl.isEmpty else{
            cellHeightConstraint.constant = 0
            return
        }
        cellHeightConstraint.constant = (MGScreenWidth-30) * 333 / 500
        goodsImageView.kf_setImageWithURL(NSURL(string:imageUrl)!, placeholderImage:UIImage(named: "placeholder_product"))
        
    }
}
