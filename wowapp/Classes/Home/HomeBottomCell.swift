//
//  HomeBottomCell.swift
//  wowapp
//
//  Created by 陈旭 on 16/8/30.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class HomeBottomCell: UITableViewCell {
    
    var indexPath:NSIndexPath!
    
    @IBAction func clickOneBtn(sender: AnyObject) {
        print("-----\(indexPath.section)")
        print("你点击了第一个Item,tag : \(sender.tag + (indexPath.section%2 == 0 ? (indexPath.section) : (indexPath.section + 1)))")
    }
    @IBAction func clickTwoBtn(sender: AnyObject) {
         print("------\(indexPath.section)")
         print("你点击了第二个Item,tag : \(sender.tag + (indexPath.section%2 == 0 ? (indexPath.section) : (indexPath.section + 1)))")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
