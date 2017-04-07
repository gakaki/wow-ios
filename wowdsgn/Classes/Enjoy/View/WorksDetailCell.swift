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
    
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var lbDes: UILabel!
    
    @IBOutlet weak var lbMyName: UILabel!
    
    @IBOutlet weak var lbMyIntro: UILabel!
    
    @IBOutlet weak var lbPushTime: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgMyPhoto.borderRadius(28)
        
    }

    func showData(_ m : WOWWorksDetailsModel)  {

        imgMyPhoto.set_webUserPhotoimage_url(m.avatar ?? "")
        imgMyPhoto.addTapGesture { (sender) in
            VCRedirect.goOtherCenter(endUserId: m.endUserId ?? 0)
        }
        heightConstraint.constant = m.picHeight
        categoryName.text = (m.categoryName ?? "").get_formted_Space()
        lbDes.text = m.des ?? ""
        lbMyName.text = m.nickName ?? ""
        imgPhoto.set_webimage_url(m.pic ?? "")
        lbPushTime.text = "发布于" + (m.pubTime ?? "")
        lbMyIntro.text = (m.instagramCounts?.toString)!  + "件作品／" + (m.totalLikeCounts?.toString)! + "次被赞"
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
