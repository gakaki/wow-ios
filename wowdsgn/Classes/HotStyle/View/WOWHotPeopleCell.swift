//
//  WOWHotPeopleCell.swift
//  wowdsgn
//
//  Created by 陈旭 on 2016/11/15.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit
// 人气标签 热门标签
class WOWHotPeopleCell: UITableViewCell,ModuleViewElement {
    static func isNib() -> Bool { return true }
    static func cell_type() -> Int {
        return 1001
    }
//    var tagArr:[WOWHomeHot_1001_title]!
    
    @IBOutlet weak var tagListView: TagListView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tagListView.textFont = UIFont.systemFont(ofSize: 14)
        
    }
    func showData(_ tagArr:[WOWHomeHot_1001_title])  {
        tagListView.removeAllTags()
        for m in tagArr{
            tagListView.addTag(m.name ?? "")
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
