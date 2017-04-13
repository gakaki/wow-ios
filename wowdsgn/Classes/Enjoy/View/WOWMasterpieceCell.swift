//
//  WOWMasterpieceCell.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/24.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWMasterpieceCell: UITableViewCell {

    @IBOutlet weak var imgWroks: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    func showData(_ m : WOWFineWroksModel)  {
        
          imgWroks.set_webimage_url(m.pic ?? "")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
