//
//  WOWRefreshHeader.swift
//  MJDemo
//
//  Created by 陈旭 on 16/9/1.
//  Copyright © 2016年 陈旭. All rights reserved.
//

import UIKit

class WOWRefreshHeader: MJRefreshHeader {
    var img : YYAnimatedImageView! = nil

    override func prepare() {
        super.prepare()
        self.mj_h = 75.h
        
        let image = YYImage(named: "loadRefresh")
        img = YYAnimatedImageView(image: image)
        
        img.frame = CGRect(x: 0,y: 0,width: 50.w,height: 50.h)
        
        self.addSubview(img)
    
        
    }
    override func placeSubviews() {
        super.placeSubviews()

        img.center = CGPoint(x: UIScreen.mainScreen().bounds.size.width/2, y: self.center.y + 80)

    }
    
    override func scrollViewContentOffsetDidChange(_ change: [AnyHashable: Any]!) {
        super.scrollViewContentOffsetDidChange(change)
    }
    override func scrollViewContentSizeDidChange(_ change: [AnyHashable: Any]!) {
        super.scrollViewContentSizeDidChange(change)
    }
    override func scrollViewPanStateDidChange(_ change: [AnyHashable: Any]!) {
        super.scrollViewPanStateDidChange(change)
    }

}

