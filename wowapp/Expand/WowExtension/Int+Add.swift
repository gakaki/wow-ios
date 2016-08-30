//
//  Int+Add.swift
//  wowapp
//
//  Created by 陈旭 on 16/8/30.
//  Copyright © 2016年 小黑. All rights reserved.
//

import Foundation
extension Int {
    func getParityCellNumber() -> Int {
        return  ((self % 2) == 0 ? (self / 2) : ((self / 2) + 1))
    }
}
