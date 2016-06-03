//
//  WOWProductDetailPicTextCell.swift
//  wowapp
//
//  Created by 小黑 on 16/6/3.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWProductDetailPicTextCell: UITableViewCell {

    @IBOutlet weak var cellHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var picImageView: UIImageView!
    @IBOutlet weak var itemSpacing: NSLayoutConstraint!
    @IBOutlet weak var productTextLabel: UILabel!
    @IBOutlet weak var moreContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        moreContainerView.addTapGesture {[weak self] (tap) in
            if let strongSelf = self{
                DLog("跳转到详情去")
            }
        }
    }
    
    func showData(model:WOWProductPicTextModel?) {
        productTextLabel.text = model?.text
        if let title = model?.text where title.isEmpty {
            itemSpacing.constant = 0
        }
        guard let imageUrl = model?.image where !imageUrl.isEmpty else{
            cellHeightConstraint.constant = 0
            return
        }
        cellHeightConstraint.constant = (MGScreenWidth-30) * 333 / 500
        picImageView.kf_setImageWithURL(NSURL(string:imageUrl)!, placeholderImage:UIImage(named: "placeholder_banner"))
    }
    
    
}
