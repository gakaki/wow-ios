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

    func showDataModel(model:WOWCategoryModel,isStore:Bool){
        var imageName = getImageName(model.categoryID ?? "5")
        imageName = isStore ? "store_" + imageName : imageName
        menuImageView.image = UIImage(named:imageName)
        menuNameLabel.text = model.categoryName
        menuCountLabel.text = "\(model.categoryCount ?? 0)件商品"
    }
    
    private func getImageName(categoryID:String) -> String{
        switch categoryID {
        case "5": //全部
            return "all"
        case "17"://装点
            return "zhuangdian"
        case "18"://家什
            return "jiashi"
        case "19"://灯光
            return "dengguang"
        case "20"://食居
            return "shiju"
        case "21"://儿童
            return "tongqu"
        default:
            return "  "
        }
    }
    
}
