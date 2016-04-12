//
//  WOWLoginManager.swift
//  Wow
//
//  Created by 小黑 on 16/4/7.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWLoginManager: NSObject {
    static var status:LoginStatus = .UnLogin
}



enum LoginStatus {
    case Logined,UnLogin
}