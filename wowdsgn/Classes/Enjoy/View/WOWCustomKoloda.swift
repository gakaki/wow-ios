//
//  WOWCustomKoloda.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/25.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWCustomKoloda: UIView {
    @IBOutlet weak var workImg: UIImageView!
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.frame = CGRect(x: 0, y: 0, w: MGScreenWidth * 0.88, h: MGScreenWidth * 0.88 + 70)
        self.layer.shadowOffset = CGSize(width: 0, height: 2)  //设置图层阴影的偏移量
        self.layer.shadowOpacity = 0.1  //将图层阴影的不透明度设为 0.7
        self.layer.shadowRadius = 4 //将图层阴影的范围设为 5
        self.layer.shadowColor = UIColor.black.cgColor      //设置图层阴影的颜色
        self.backgroundColor = UIColor.white

        // Initialization code
    }

    func showData() {
        
    }

}
