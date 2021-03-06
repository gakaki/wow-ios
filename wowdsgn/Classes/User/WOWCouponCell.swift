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
    @IBOutlet weak var label_rmb: UILabel!
    @IBOutlet weak var label_limit: UILabel!
    @IBOutlet weak var image_check: UIImageView!
    @IBOutlet weak var useCouponBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
    }

    func draw_dashed_line( _ color:UIColor ){
        
        //画虚线
        let dotteShapLayer = CAShapeLayer()
        let mdotteShapePath = CGMutablePath()
        dotteShapLayer.fillColor = UIColor.clear.cgColor
        dotteShapLayer.strokeColor = color.cgColor
        dotteShapLayer.lineWidth = 1


        mdotteShapePath.move(to: CGPoint(x:115,y:0))
        mdotteShapePath.addLine(to: CGPoint(x:115,y:90))
        dotteShapLayer.path = mdotteShapePath
        let arr :NSArray = NSArray(array: [4,4])
        dotteShapLayer.lineDashPhase = 1.0
        dotteShapLayer.lineDashPattern = arr as? [NSNumber]
        self.layer.addSublayer(dotteShapLayer)
        
    }
    
    let color_status_disable = MGRgb(204, g: 204, b: 204)
    
    func showData(_ status: Bool) {
        label_rmb.text = "元"
        draw_dashed_line(color_status_disable)
        //如果优惠券可用则显示
        if status {
            useCouponBtn.isHidden = false       
            label_is_used.isHidden = true
            label_amount.textColor             = UIColor.black
            label_title.textColor              = UIColor.black
            label_rmb.textColor                = UIColor.black
            label_time_limit.textColor         = MGRgb(128, g: 128, b: 128)
            label_limit.textColor              = UIColor(hexString: "#FF7070")
            
        }else {
            useCouponBtn.isHidden = true
            label_is_used.isHidden = false
            label_amount.textColor             = color_status_disable
            label_title.textColor              = color_status_disable
            label_time_limit.textColor         = color_status_disable
            label_rmb.textColor                = color_status_disable
            label_limit.textColor               = color_status_disable
            
        }
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
