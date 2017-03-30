//
//  WOWUserHeaderView.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/23.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWUserHeaderView: UIView {

    @IBOutlet weak var userBack: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var workNum: UILabel!
    @IBOutlet weak var praiseNum: UILabel!
    @IBOutlet weak var favoriteNum: UILabel!
    @IBOutlet weak var userHeadImg: UIImageView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        self.frame = CGRect(x: 0, y: 0, width: MGScreenWidth, height: 9/16*MGScreenWidth)
        
    }
    
    func configUserInfo(model: WOWStatisticsModel?) {
        if let model = model {
            userHeadImg.set_webimage_url_base(model.avatar?.webp_url(), place_holder_name: "defaultHead")

            userName.text = model.nickName
            workNum.text = String(format: "%i", model.instagramCounts ?? 0)
            praiseNum.text = String(format: "%i", model.likeCounts ?? 0)
            favoriteNum.text = String(format: "%i", model.collectCounts ?? 0)
            
        }else {
            userHeadImg.set_webimage_url("")
            userName.text = ""
            workNum.text = "0"
            praiseNum.text = "0"
            favoriteNum.text = "0"
        }
        
    }

    
}
