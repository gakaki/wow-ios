//
//  WOWProductParamCell.swift
//  wowapp
//
//  Created by 小黑 on 16/6/6.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWProductParamCell: UITableViewCell {
    @IBOutlet weak var parameterShowNameLabel: UILabel!
    @IBOutlet weak var parameterValueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func showData(_ params:WOWParameter?){ //可变参数
        if let params = params {
            parameterShowNameLabel.text = params.parameterShowName
            parameterValueLabel.text = params.parameterValue
        }
    }
    
   
    
}
