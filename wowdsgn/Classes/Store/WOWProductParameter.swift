//
//  WOWProductParameter.swift
//  wowapp
//
//  Created by 安永超 on 16/7/28.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWProductParameter: UITableViewCell {
    @IBOutlet weak var materialLabel: UILabel!
    @IBOutlet weak var needAssembleLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var applicableSceneLabel: UILabel!
    @IBOutlet weak var applicablePeopleLabel: UILabel!
    @IBOutlet weak var sizeText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showData(_ model:WOWParameter){
        
//            materialLabel.text = model.materialText
//        if model.needAssemble ?? false {
//            needAssembleLabel.text = "是"
//
//        }else {
//            needAssembleLabel.text = "否"
//
//        }
//            originLabel.text = model.origin
//            styleLabel.text = model.style
//            applicableSceneLabel.text = model.applicableSceneText
//            applicablePeopleLabel.text = model.applicablePeople
//            sizeText.text = model.sizeText
//        
//        
    }
    
}
