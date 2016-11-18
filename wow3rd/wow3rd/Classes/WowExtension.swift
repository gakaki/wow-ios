//
//  WowExtension.swift
//  Pods
//
//  Created by g on 2016/11/11.
//
//

import Foundation

extension String{
    public func toInt0() -> Int? {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return 0
        }
    }

}
