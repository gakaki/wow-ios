//
//  WOWProductDetailCell.swift
//  wowapp
//
//  Created by 安永超 on 16/7/28.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWProductDetailCell: UITableViewCell {
    @IBOutlet weak var productImg:UIImageView!
    @IBOutlet weak var imgDescLabel:UILabel!
    @IBOutlet weak var space: NSLayoutConstraint!
//    @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    @IBOutlet weak var aspect: NSLayoutConstraint!
    
    //内容图片的宽高比约束
    internal var aspectConstraint : NSLayoutConstraint? {
        didSet {
            if oldValue != nil {
                productImg.removeConstraint(oldValue!)
            }
            if aspectConstraint != nil {
                aspect.priority = 750
                productImg.addConstraint(aspectConstraint!)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func showData(_ secondaryImg: WOWProductPicTextModel?) {
        if let secondaryImg = secondaryImg {
            if let img = secondaryImg.image {
                aspectConstraint = NSLayoutConstraint(item: self.productImg,
                                                      attribute: .width, relatedBy: .equal,
                                                      toItem: self.productImg, attribute: .height,
                                                      multiplier: secondaryImg.imageAspect , constant: 0.0)
//                self.updateConstraints()
//                productImg.updateConstraints()
                productImg.kf.setImage(with: URL(string:img), placeholder:UIImage(named: "placeholder_product"), options: nil, progressBlock: nil, completionHandler: { (image, error, chcheTypr, imageUrl) in
                    if let image = image {
//                        secondaryImg.imageAspect = image.size.width / image.size.height
                    }
                })
                
//                productImg.kf.setImage(with: URL(string:img), placeholder:UIImage(named: "placeholder_product"))
                space.constant = 15
            }else {
                space.constant = 0
            }
            imgDescLabel.text = secondaryImg.text
            if secondaryImg.text == "" {
                space.constant = 0
            }else {
                space.constant = 15
            }
            imgDescLabel.setLineHeightAndLineBreak(1.5)
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        //清除内容图片的宽高比约束
        aspectConstraint = nil
    }

}
