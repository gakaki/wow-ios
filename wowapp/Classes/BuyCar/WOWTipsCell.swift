//
//  WOWTipsCell.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/15.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWTipsCell: UITableViewCell {

    @IBOutlet weak var textView: HolderTextView!
    override func awakeFromNib() {
        super.awakeFromNib()
//        textView.placeHolder = "写下您的特殊要求"
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    
    
}


extension WOWTipsCell:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
