//
//  WOWCouponCell.swift
//  wowapp
//
//  Created by 安永超 on 16/8/15.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWCouponCell: UITableViewCell {

    @IBOutlet weak var label_amount: UILabel!
    @IBOutlet weak var label_title: UILabel!
    @IBOutlet weak var label_is_used: UILabel!
    @IBOutlet weak var label_time_limit: UILabel!
    
    @IBOutlet weak var label_unit: UILabel!
    @IBOutlet weak var label_identifier: UILabel!
    
    @IBOutlet weak var image_check: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
    }

    func draw_dashed_line( color:UIColor ){
        
        //画虚线
        let dotteShapLayer = CAShapeLayer()
        let mdotteShapePath = CGPathCreateMutable()
        dotteShapLayer.fillColor = UIColor.clearColor().CGColor
        dotteShapLayer.strokeColor = color.CGColor
        dotteShapLayer.lineWidth = 1
        CGPathMoveToPoint(mdotteShapePath, nil, 55, 0)
        CGPathAddLineToPoint(mdotteShapePath, nil, 55, 90)
        dotteShapLayer.path = mdotteShapePath
        let arr :NSArray = NSArray(array: [4,4])
        dotteShapLayer.lineDashPhase = 1.0
        dotteShapLayer.lineDashPattern = arr as? [NSNumber]
        self.layer.addSublayer(dotteShapLayer)
        
    }
    
    let color_status_disable = MGRgb(204, g: 204, b: 204)
    
    func showData(status: Bool) {
        if status {
            label_amount.textColor             = UIColor.blackColor()
            label_title.textColor              = UIColor.blackColor()
            label_is_used.textColor            = MGRgb(210, g: 181, b: 148)
            label_time_limit.textColor         = MGRgb(128, g: 128, b: 128)
            
            label_unit.textColor               = UIColor.blackColor()
            label_identifier.backgroundColor   = MGRgb(210, g: 181, b: 148)
            
            draw_dashed_line(MGRgb(210, g: 181, b: 148))
        }else {
            label_amount.textColor             = color_status_disable
            label_title.textColor              = color_status_disable
            label_is_used.textColor            = color_status_disable
            label_time_limit.textColor         = color_status_disable
            
            label_unit.textColor               = color_status_disable
            label_identifier.backgroundColor   = color_status_disable
            
            draw_dashed_line(color_status_disable)
            
        }
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
