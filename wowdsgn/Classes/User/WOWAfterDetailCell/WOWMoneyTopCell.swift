//
//  WOWMoneyTopCell.swift
//  TimeLinessDemo
//
//  Created by 陈旭 on 2017/5/9.
//  Copyright © 2017年 陈旭. All rights reserved.
//

import UIKit

class WOWMoneyTopCell: WOWStyleNoneCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        draw_dashed_line(UIColor.red)
    }
    func draw_dashed_line( _ color:UIColor ){
        
        //画虚线
        let dotteShapLayer = CAShapeLayer()
        let mdotteShapePath = CGMutablePath()
        dotteShapLayer.fillColor = UIColor.clear.cgColor
        dotteShapLayer.strokeColor = color.cgColor
        dotteShapLayer.lineWidth = 1
        
        
        mdotteShapePath.move(to: CGPoint(x:15,y:89))
        mdotteShapePath.addLine(to: CGPoint(x:MGScreenWidth - 30,y:89))
        dotteShapLayer.path = mdotteShapePath
        let arr :NSArray = NSArray(array: [2,2])
        dotteShapLayer.lineDashPhase = 1.0
        dotteShapLayer.lineDashPattern = arr as? [NSNumber]
        self.layer.addSublayer(dotteShapLayer)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
