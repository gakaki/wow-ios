//
//  WOWCouponCell.swift
//  wowapp
//
//  Created by 安永超 on 16/8/15.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWCouponCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //画虚线
        let dotteShapLayer = CAShapeLayer()
        let mdotteShapePath = CGPathCreateMutable()
        dotteShapLayer.fillColor = UIColor.clearColor().CGColor
        dotteShapLayer.strokeColor = MGRgb(210, g: 181, b: 148).CGColor
        dotteShapLayer.lineWidth = 1
        CGPathMoveToPoint(mdotteShapePath, nil, 55, 0)
        CGPathAddLineToPoint(mdotteShapePath, nil, 55, 90)
        dotteShapLayer.path = mdotteShapePath
        let arr :NSArray = NSArray(array: [4,4])
        dotteShapLayer.lineDashPhase = 1.0
        dotteShapLayer.lineDashPattern = arr as? [NSNumber]
        self.layer.addSublayer(dotteShapLayer)

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
