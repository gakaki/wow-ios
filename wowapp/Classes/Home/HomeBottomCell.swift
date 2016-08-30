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
    var currentIndexPath : Int = 0
       @IBOutlet weak var oneBtn: UIButton!
       @IBOutlet weak var twoBtn: UIButton!
        @IBOutlet weak var twoLb: UILabel!
    
    @IBAction func clickOneBtn(sender: AnyObject) {
        print("==\(sender.tag)")
     
//        print("你点击了第一个Item,tag : \((sender.tag + currentIndexPath.getParityCellNumber())*2)")
    }
    @IBAction func clickTwoBtn(sender: AnyObject) {
         print("==\(sender.tag)")
//         print("你点击了第二个Item,tag : \((sender.tag + currentIndexPath.getParityCellNumber())*2)")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        if let indexPath = indexPath {
//              currentIndexPath = indexPath.section - 10
//        }
        
      
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
