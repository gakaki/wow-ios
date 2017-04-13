//
//  WOWMoreModel.swift
//  wowdsgn
//
//  Created by 安永超 on 2017/4/12.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

enum  MoreType{
    case cancle     //取消
    case edit       //编辑
    case delete     //删除
    case report     //举报
    case rubbish    //垃圾信息
    case improper   //内容不当
}

class WOWMoreModel: WOWBaseModel {
    var type            :  MoreType = .cancle
    var name            :  String = "取消"
    
    init(type: MoreType, name: String) {
        self.type = type
        self.name = name
    }
}
