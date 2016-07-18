//
//  UIFont+Add.swift
//  wowapp
//
//  Created by 小黑 on 16/6/3.
//  Copyright © 2016年 小黑. All rights reserved.
//

import Foundation

extension  UIFont{
   class func priceFont(size:CGFloat = 12) -> UIFont{
        return UIFont(name: "DIN Alternate", size:size) ?? UIFont.systemFontOfSize(size)
    }
}