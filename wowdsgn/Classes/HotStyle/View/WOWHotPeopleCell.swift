//
//  WOWHotPeopleCell.swift
//  wowdsgn
//
//  Created by 陈旭 on 2016/11/15.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit
protocol HotPeopleTitleDelegate:class {
    
    func tagPressedWithToVC(titleId: Int, title: String?)
    
}
// 人气标签 热门标签
class WOWHotPeopleCell: UITableViewCell,ModuleViewElement,TagListViewDelegate {
    static func isNib() -> Bool { return true }
    static func cell_type() -> Int {
        return 1001
    }
//    var tagArr:[WOWHomeHot_1001_title]!
    
    @IBOutlet weak var tagListView: TagListView!
    fileprivate var dataArr:[WOWHomeHot_1001_title] = []
    weak var delegate :HotPeopleTitleDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tagListView.delegate = self
        tagListView.textFont = UIFont.systemFont(ofSize: 14)
        
    }
    func showData(_ tagArr:[WOWHomeHot_1001_title])  {
        tagListView.removeAllTags()
        dataArr = tagArr
        for m in tagArr{
            tagListView.addTag(m.name ?? "")
        }
    }
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        for m in dataArr.enumerated() {
            if m.element.name == title {
                if let del = delegate {
                    del.tagPressedWithToVC(titleId: m.element.id ?? 0, title: title)
                }
            }
        }
        print("点击了\(tagView.tag)")
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
//class WOWBaseTableViewCell: <#super class#> {
//    <#code#>
//}
