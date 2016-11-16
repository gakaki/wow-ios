//
//  WOWHotPeopleCell.swift
//  wowdsgn
//
//  Created by 陈旭 on 2016/11/15.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit

class WOWHotPeopleCell: UITableViewCell {

    @IBOutlet weak var tagListView: TagListView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tagListView.textFont = UIFont.systemFont(ofSize: 14)
        for i in 0..<30 {
            
            tagListView.addTag("aaaaa")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
//class WOWBaseTableViewCell: <#super class#> {
//    <#code#>
//}
