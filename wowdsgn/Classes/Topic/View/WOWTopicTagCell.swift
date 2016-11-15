//
//  WOWTopicTagCell.swift
//  wowdsgn
//
//  Created by 安永超 on 16/11/11.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit

class WOWTopicTagCell: UITableViewCell ,TagListViewDelegate{

    @IBOutlet weak var tagListView: TagListView!
    
   
    override func awakeFromNib() {
        
        super.awakeFromNib()
        tagListView.delegate = self
        
        tagListView.addTag("")
        tagListView.addTag("TEAChart")
        tagListView.addTag("To Be Removed")
        tagListView.addTag("To Be Removed")
        tagListView.addTag("Quark Shell")
        tagListView.addTag("TagListView")
        tagListView.addTag("TEAChart")
        tagListView.addTag("To Be Removed")
        tagListView.addTag("To Be Removed")
        tagListView.addTag("Quark Shell")
        tagListView.addTag("TagListView")
        tagListView.addTag("TEAChart")
        tagListView.addTag("To Be Removed")
        tagListView.addTag("To Be Removed")
        tagListView.addTag("Quark Shell")
        
        // Initialization code
    }
    
 
 


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
    }
    
        
        
    
}
