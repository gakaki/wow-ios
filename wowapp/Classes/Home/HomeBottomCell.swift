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
    
    @IBOutlet weak var priceLbOne: UILabel!
    @IBOutlet weak var priceLbTwo: UILabel!
    
    
    @IBAction func clickOneBtn(sender: AnyObject) {
        print("==\(sender.tag)")
     
    }
    @IBAction func clickTwoBtn(sender: AnyObject) {
         print("==\(sender.tag)")

    }
    override func awakeFromNib() {
        super.awakeFromNib()

        
        priceLbOne.strokeWithText("¥1666.00", str2: "¥1600.00", str2Font: 11, str2Color: UIColor.init(hexString: "CCCCCC")!)
        priceLbTwo.strokeWithText("¥1666.00", str2: "¥1600.00", str2Font: 11, str2Color: UIColor.init(hexString: "CCCCCC")!)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
       
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
