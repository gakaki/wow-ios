//
//  UITableVIew+Add.swift
//  WowLib
//
//  Created by dcpSsss on 16/4/3.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import Foundation

public extension UITableView{
    /**
     剔除多余的cell
     */
    func clearRestCell(){
        self.tableFooterView = UIView(frame:CGRectZero)
    }
}