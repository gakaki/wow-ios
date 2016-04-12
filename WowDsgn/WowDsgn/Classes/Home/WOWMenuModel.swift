//
//  WOWMenuModel.swift
//  Wow
//
//  Created by dcpSsss on 16/4/3.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWMenuModel: WOWBaseModel {
    var menuImage:String?
    var menuName:String?
    var menuCount:String?
    var menuTag:String!
    convenience init(imageName:String?,name:String?,count:Int?,tag:String!) {
        self.init()
        menuImage = imageName
        menuName  = name
        let totalCount = count ?? 0
        menuCount = "\(totalCount)件商品"
        menuTag = tag
    }
}
