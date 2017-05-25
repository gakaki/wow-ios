//
//  UITableView+Add.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/5/24.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
//import class UIKit.UITableViewCell
//import class UIKit.UITableView
//import struct Foundation.IndexPath

//struct ReusableView{
//    static var reuseIdentifier: String {get}
//}
//
//extension ReusableView {
//    static var reuseIdentifier: String {
//        return String(describing: self)
//    }
//}

//extension UITableViewCell: ReusableView {
//}
extension UITableView {
    
    func cellId_register(_ cellId:String)    {
        self.register(UINib.nibName(cellId), forCellReuseIdentifier: cellId)
    }
    
//    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
//        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
//            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
//        }
//        
//        return cell
//    }
    
}
