//
//  WOWCustomKoloda.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/25.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWCustomKoloda: UIView {

   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, _ imgStr: String) {
        self.init()
        self.frame = frame
        self.layer.shadowOffset = CGSize(width: 5, height: 5)  //设置图层阴影的偏移量
        self.layer.shadowOpacity = 0.5  //将图层阴影的不透明度设为 0.7
        self.layer.shadowRadius = 5 //将图层阴影的范围设为 5
        self.layer.shadowColor = UIColor.black.cgColor      //设置图层阴影的颜色
        configImg(img: imgStr)
    }
    
    func configImg(img: String) {
        let imgView = UIImageView(frame: CGRect(x: 10, y: 10, width: self.w - 20, height: self.h - 36))
        imgView.set_webimage_url(img)
        self.addSubview(imgView)
    }

}