//
//  WOWWorkMoreCell.swift
//  wowdsgn
//
//  Created by 安永超 on 2017/4/12.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWWorkMoreCell: UITableViewCell {
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lineView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func showData(model: WOWMoreModel) {
        lbName.text = model.name
        lbName.backgroundColor = UIColor.white
        lbName.textColor = UIColor.black
        lineView.isHidden = true
        switch model.type {
        case .cancle:
            lbName.backgroundColor = UIColor.init(hexString: "#F5F5F5")
            break
        case .delete, .report, .improper:
            lbName.textColor = UIColor.init(hexString: "#FF7070")
            break
        case .edit:
            lineView.isHidden = false
            break
        case .rubbish:
            lbName.textColor = UIColor.init(hexString: "#FF7070")
            lineView.isHidden = false
            break
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
