//
//  WOWContentTopicTopCell.swift
//  wowapp
//
//  Created by 安永超 on 16/9/13.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWContentTopicTopCell: UITableViewCell {
    
    @IBOutlet weak var topicImg: UIImageView!
    @IBOutlet weak var topicTitle: UILabel!
    @IBOutlet weak var topicDesc: UILabel!
    @IBOutlet weak var aspect: NSLayoutConstraint!
    
    //内容图片的宽高比约束
    internal var aspectConstraint : NSLayoutConstraint? = nil{
        didSet {
            if oldValue != nil {
                topicImg.removeConstraint(oldValue!)
            }
            if aspectConstraint != nil {
                aspect.priority = 750
                topicImg.addConstraint(aspectConstraint!)
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
    
    func showData(_ model: WOWModelVoTopic?) {
        if let model = model {
            aspectConstraint = NSLayoutConstraint(item: self.topicImg,
                                                  attribute: .width, relatedBy: .equal,
                                                  toItem: self.topicImg, attribute: .height,
                                                  multiplier: model.imageAspect , constant: 0.0)
            self.updateConstraints()
            topicImg.updateConstraints()

            topicImg.set_webimage_url(model.topicImg)
            topicTitle.text = model.topicMainTitle
            topicDesc.text = model.topicDesc
            topicDesc.setLineHeightAndLineBreak(1.5)
        }
    }
}
