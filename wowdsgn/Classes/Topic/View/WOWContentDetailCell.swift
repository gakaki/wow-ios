//
//  WOWContentDetailCell.swift
//  wowdsgn
//
//  Created by 安永超 on 16/11/21.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit

class WOWContentDetailCell: UITableViewCell {
    @IBOutlet weak var productImg:UIImageView!
    @IBOutlet weak var imageDesc: UILabel!
    @IBOutlet weak var space: NSLayoutConstraint!
    @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    @IBOutlet weak var aspect: NSLayoutConstraint!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var midSpace: NSLayoutConstraint!
    
    
    //内容图片的宽高比约束
    internal var aspectConstraint : NSLayoutConstraint? {
        didSet {
            if oldValue != nil {
                //删除旧的约束
                LayoutConstraint.deactivate([oldValue!])
            }
            if aspectConstraint != nil {
                LayoutConstraint.activate([aspectConstraint!])
                
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
    func showData(_ secondaryImg: WOWImages?) {
        if let secondaryImg = secondaryImg {
            if let img = secondaryImg.url {
                if img.isEmpty {
                    self.productImg.isHidden = true
                    aspectConstraint = NSLayoutConstraint(item: self.productImg,
                                                          attribute: .width, relatedBy: .equal,
                                                          toItem: self.productImg, attribute: .height,
                                                          multiplier: 1000 , constant: 0.0)
                    space.constant = -7
                    
                }else {
                    self.productImg.isHidden = false
                    aspectConstraint = NSLayoutConstraint(item: self.productImg,
                                                          attribute: .width, relatedBy: .equal,
                                                          toItem: self.productImg, attribute: .height,
                                                          multiplier: secondaryImg.imageAspect , constant: 0.0)
                    
                    productImg.set_webimage_url(img)
//                    productImg.kf.setImage(with: URL(string:img), placeholder:UIImage(named: "placeholder_product"))
                    aspect.constant = 0
                    space.constant = 8
                    
                }
                
            }else {
                self.productImg.isHidden = true
                aspectConstraint = NSLayoutConstraint(item: self.productImg,
                                                      attribute: .width, relatedBy: .equal,
                                                      toItem: self.productImg, attribute: .height,
                                                      multiplier: 1000 , constant: 0.0)
                space.constant = -7
            }
            if let text = secondaryImg.desc {
                descLabel.text = text
                if text == "" {
                    bottomSpace.constant = 7
                }else {
                    bottomSpace.constant = 15
                }
            }else {
                descLabel.text = ""
                bottomSpace.constant = 7
                
            }
            if let text = secondaryImg.note {
                imageDesc.text = text
                if text == "" {
                    midSpace.constant = 0
                }else {
                    midSpace.constant = 8
                }
            }else {
                imageDesc.text = ""
                midSpace.constant = 0
                
            }
            //            imgDescLabel.text = secondaryImg.text
            //            if secondaryImg.text == "" {
            //                bottomSpace.constant = 7
            //            }else {
            //                bottomSpace.constant = 15
            //            }
            imageDesc.setLineHeightAndLineBreak(1.5)
            descLabel.setLineHeightAndLineBreak(1.5)
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        //清除内容图片的宽高比约束
        aspectConstraint = nil
    }
}
