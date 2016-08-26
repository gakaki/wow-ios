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
        
    }
    
    func showData(imgUrl:String?,imgDesc:String?) {
        let str = NSMutableAttributedString(string: imgDesc ?? "")
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.5      //设置1.5倍行距
        style.lineBreakMode = .ByTruncatingTail
        str.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, str.length))
        productTextLabel.attributedText = str

        if let title = imgDesc where title.isEmpty {
            itemSpacing.constant = 0
        }
        guard let imageUrl = imgUrl where !imageUrl.isEmpty else{
            cellHeightConstraint.constant = 0
            return
        }
        cellHeightConstraint.constant = (MGScreenWidth-30) * 333 / 500
//        picImageView.kf_setImageWithURL(NSURL(string:imageUrl)!, placeholderImage:UIImage(named: "placeholder_product"))
        picImageView.set_webimage_url_base(imgUrl, place_holder_name: "placeholder_product")

    }
    
    
}
