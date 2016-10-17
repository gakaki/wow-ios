//
//  WOWGoodsModel.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/12.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWGoodsModel: WOWBaseModel {
    var des:String?
    var cellHeight:CGFloat = 0
    
    func calCellHeight(){
        let s = self.des ?? ""
        var height = s.heightWithConstrainedWidth((MGScreenWidth - CGFloat(3)) / CGFloat(2) - 30, font: UIFont.systemScaleFontSize(13))
        height = height > 18 ? 30 : 18
        self.cellHeight = 20 + 5 + 14 + height + 6 + WOWGoodsSmallCell.itemWidth
    }
}


