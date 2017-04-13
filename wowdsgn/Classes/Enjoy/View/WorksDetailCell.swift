//
//  TextDetailCell.swift
//  PhotoTweaks-Demo
//
//  Created by 陈旭 on 2017/3/24.
//  Copyright © 2017年 陈旭. All rights reserved.
//

import UIKit
protocol WorksDetailCellDelegate: class {
    func doubleTapThumb()
}

class WorksDetailCell: UITableViewCell {

    @IBOutlet weak var imgPhoto: UIImageView!
    
    @IBOutlet weak var imgMyPhoto: UIImageView!
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var lbDes: UILabel!
    
    @IBOutlet weak var lbMyName: UILabel!
    
    @IBOutlet weak var lbMyIntro: UILabel!
    
    @IBOutlet weak var lbPushTime: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    weak var delegate: WorksDetailCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgMyPhoto.borderRadius(28)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapClick(tap:)))
        tap.numberOfTapsRequired = 2
        imgPhoto.addGestureRecognizer(tap)

    }

    func showData(_ m : WOWWorksDetailsModel)  {

        imgMyPhoto.set_webUserPhotoimage_url(m.avatar ?? "")
        imgMyPhoto.addTapGesture { (sender) in
            MobClick.e(.avatars_clicks_picture_details_page)
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
    
    func tapClick(tap: UITapGestureRecognizer)  {
        if let del = delegate {
            del.doubleTapThumb()
        }
        imgPhoto.isUserInteractionEnabled = false
        thumbImg.isHidden = false
        thumbImg.alpha = 0
        thumbImg.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveLinear, animations: {[unowned self] in
            self.thumbImg.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.thumbImg.alpha = 1
        }) { (finish) in
            
        }
        UIView.animate(withDuration: 1/8, delay: 7/8, options: .curveLinear, animations: { [unowned self] in
            self.thumbImg.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.thumbImg.alpha = 0
        }) { [unowned self](finish)  in
            self.thumbImg.isHidden = true
            self.imgPhoto.isUserInteractionEnabled = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
