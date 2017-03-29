//
//  TextDetailCell.swift
//  PhotoTweaks-Demo
//
//  Created by 陈旭 on 2017/3/24.
//  Copyright © 2017年 陈旭. All rights reserved.
//

import UIKit

class WorksDetailCell: UITableViewCell {

    @IBOutlet weak var imgPhoto: UIImageView!
    
    @IBOutlet weak var imgMyPhoto: UIImageView!
    
    @IBOutlet weak var lbDes: UILabel!
    
    @IBOutlet weak var lbMyName: UILabel!
    
    @IBOutlet weak var lbMyIntro: UILabel!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         imgMyPhoto.set_webimage_url_user( WOWUserManager.userHeadImageUrl )
        
    }
    func showData(_ m : WOWWorksDetailsModel)  {
        lbDes.text = m.des ?? ""
        lbMyName.text = m.nickName ?? ""
        imgPhoto.set_webimage_url(m.pic ?? "")
        lbMyIntro.text = (m.instagramCounts?.toString)!  + "件作品／" + (m.likeCounts?.toString)! + "次被赞"
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
