//
//  WOWOtherHeaderView.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/29.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWOtherHeaderView: UICollectionReusableView {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var workNum: UILabel!
    @IBOutlet weak var praiseNum: UILabel!
    @IBOutlet weak var selfIntroduction: UILabel!
    @IBOutlet weak var userHeadImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        userHeadImg.setCornerRadius(radius: 40)
        // Initialization code
    }
    
    func configUserInfo(model: WOWStatisticsModel?) {
        if let model = model {
            
            userHeadImg.set_webimage_url(model.avatar)
            userName.text = model.nickName
            workNum.text = String(format: "%i", model.instagramCounts ?? 0)
            praiseNum.text = String(format: "%i", model.likeCounts ?? 0)
            selfIntroduction.text = model.selfIntroduction
        }
        
    }
}
