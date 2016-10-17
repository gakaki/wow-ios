//
//  WOWNetWorkType.swift
//  wowapp
//
//  Created by 陈旭 on 16/9/23.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
import Reachability
typealias NotReachable = (_ NotReachable:Bool?) ->()
struct WOWNetWorkType {
    
    static var reach: Reachability?
    
    static func netWorkType(isNotReachable: NotReachable){
        self.reach = Reachability.forInternetConnection()
        if let netWork =  self.reach?.currentReachabilityStatus(){// 判断有无网络，
            switch netWork {
            case .NotReachable:// 无网络
                
                    isNotReachable(false)
                
            default:
                    isNotReachable(true)
            }
        }
    }
}
