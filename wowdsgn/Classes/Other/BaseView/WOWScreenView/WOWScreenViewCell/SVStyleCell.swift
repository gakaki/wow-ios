//
//  SVStyleCell.swift
//  wowapp
//
//  Created by 陈旭 on 16/9/23.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class SVStyleCell: UITableViewCell {

    @IBOutlet weak var imgSelect: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }
    func showData(m: ScreenModel)  {
        lbTitle.text = m.name
        if m.isSelect == true {
            imgSelect.image = UIImage.init(named: "select")
        }else{
            imgSelect.image = UIImage.init(named: "car_check")
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
