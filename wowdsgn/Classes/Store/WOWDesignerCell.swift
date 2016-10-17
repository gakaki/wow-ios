//
//  WOWDesignerCell.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/25.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWDesignerCell: UITableViewCell {

    @IBOutlet weak var designerImageView: UIImageView!
    @IBOutlet weak var designerNameLabel: UILabel!
    @IBOutlet weak var designerDesLabel: UILabel!
    @IBOutlet weak var designerImageHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showData(_ model:WOWProductModel?) {
        designerDesLabel.text   = model?.designerName
        designerNameLabel.text  = model?.designerName
        //暂时不要设计师图片
//        guard let url = model?.designer_image where !url.isEmpty else{
            designerImageHeight.constant = 0
//            return
//        }
//        designerImageHeight.constant = MGScreenWidth
//        designerImageView.kf_setImageWithURL(NSURL(string:url)!, placeholderImage:UIImage(named: "placeholder_product"))
    }
    
    
}
