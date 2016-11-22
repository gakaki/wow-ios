//
//  WOWTopicTagCell.swift
//  wowdsgn
//
//  Created by 安永超 on 16/11/11.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit
protocol WOWTopicTagCellDelegate: class {
    func tagGoTopic(_ tagId: Int?, tagTitle title: String?)
}
class WOWTopicTagCell: UITableViewCell ,TagListViewDelegate{

    @IBOutlet weak var tagListView: TagListView!
    weak var delegate: WOWTopicTagCellDelegate?
    var tagArray: [WOWTopicTagModel]?
   
    override func awakeFromNib() {
        
        super.awakeFromNib()
        tagListView.delegate = self
        
        
        // Initialization code
    }
    
    func showData(_ tagArr: [WOWTopicTagModel]?) {
        if let tagArr = tagArr {
            tagArray = tagArr
            tagListView.removeAllTags()
            tagListView.addTag("")
            for tag in tagArr {
                tagListView.addTag(tag.name ?? "")
            }
        }
    
    
    }
 


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        if let tagArray = tagArray {
            for tag in tagArray {
                if title == tag.name ?? "" {
                    if let del = delegate {
                        del.tagGoTopic(tag.id, tagTitle: tag.name)
                        print(tag.id)
                    }
                    return
                }
            
            }
        }
    }
    
        
        
    
}
