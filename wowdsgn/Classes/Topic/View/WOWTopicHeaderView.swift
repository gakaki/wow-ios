//
//  WOWTopicHeaderView.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/6.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWTopicHeaderView: UICollectionReusableView {
    @IBOutlet weak var topicImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var bottomSpace: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func showData(model: WOWModelVoTopic?) {
        if let model = model {
            topicImg.set_webimage_url(model.topicImg)
            titleLabel.text = model.topicName
            if model.topicDesc == nil || model.topicDesc == ""{
                bottomSpace.constant = 0
            }else {
                bottomSpace.constant = 30
            }

            descLabel.text = model.topicDesc
            descLabel.setLineHeightAndLineBreak(1.3)
        }
    }
    
}
