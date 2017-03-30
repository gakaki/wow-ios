//
//  WOWMasterpieceCell.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/24.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWMasterpieceCell: UITableViewCell {

    @IBOutlet weak var imgWroks: UIImageView!
    
    @IBOutlet weak var lbCategory: UILabel!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint! // 图片 的高度
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    func showData(_ m : WOWFineWroksModel)  {
        let width_works     = MGScreenWidth
        var height_works    = MGScreenWidth
        switch m.measurement ?? 0 {
        case 0:
            break
        case 1:
            break
        case 2:
            height_works = width_works * 0.67
            break
        case 3:
            height_works = width_works * 0.75
            break
        case 4:
            height_works = width_works * 0.56
            break
        default:
            break
        }
        
          heightConstraint.constant = CGFloat(height_works)
        
          imgWroks.set_webimage_url(m.pic ?? "")
          lbCategory.text = m.categoryName ?? ""
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
