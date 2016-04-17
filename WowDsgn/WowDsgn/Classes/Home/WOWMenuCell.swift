//
//  WOWMenuCell.swift
//  Wow
//
//  Created by dcpSsss on 16/4/3.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWMenuCell: UITableViewCell {

    @IBOutlet var menuImageView: UIImageView!
    @IBOutlet var menuNameLabel: UILabel!
    @IBOutlet var menuCountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet var imageName: UIImageView!

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func showDataModel(model:WOWCategoryModel){
        menuImageView.image = UIImage(named:getImageName(model.categoryID))
        menuNameLabel.text = model.categoryName
        menuCountLabel.text = "\(model.categoryCount)"
    }
    
    private func getImageName(categoryID:String) -> String{
        switch categoryID {
        case "5": //全部
            return "all"
        case "17"://装点
            return  "jiashi"
        case "18"://家什
            return "dengguang"
        case "19"://灯光
            return "zhuangdian"
        case "20"://食居
            return "shiju"
        case "21"://童趣
            return "tongqu"
        case "216"://活动
            return "  "
        default:
            return "  "
        }
    }
    
}
