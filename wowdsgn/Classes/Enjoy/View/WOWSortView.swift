//
//  WOWSortView.swift
//  wowdsgn
//
//  Created by 安永超 on 2017/5/4.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWSortView: UIView {
    @IBOutlet weak var newView: UIView!
    @IBOutlet weak var hotView: UIView!
    @IBOutlet weak var new_gou: UIImageView!
    @IBOutlet weak var hot_gou: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowOffset = CGSize(width: 0, height: 2)  //设置图层阴影的偏移量
        self.layer.shadowOpacity = 0.4  //将图层阴影的不透明度设为 0.7
        self.layer.shadowRadius = 4 //将图层阴影的范围设为 5
        self.layer.shadowColor = UIColor.black.cgColor      //设置图层阴影的颜色
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
