//
//  UIViewController+Add.swift
//  WowLib
//
//  Created by 王云鹏 on 16/3/18.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import Foundation

public typealias NavigationItemHandler = () -> ()

public extension UIViewController{
    
    func makeCustomerNavigationItem(title:String!,left:Bool,handler:NavigationItemHandler?){
//        self.navigationItem.leftBarButtonItems = nil
        let item = UIBarButtonItem(title: title, style: .Plain, target: self, action: "itemClick:")
        if let action = handler {
             ActionManager.sharedManager.actionDict[NSValue(nonretainedObject:item)] = action
        }
        if left{
            self.navigationItem.leftBarButtonItem = item                              
        }else{
            self.navigationItem.rightBarButtonItem = item
        }
        if let left = self.navigationItem.leftBarButtonItem{
            left.imageInsets = UIEdgeInsetsMake(0,-16,0, 0);
        }
        
    }
    
    func makeCustomerImageNavigationItem(image:String!,left:Bool,handler:NavigationItemHandler){
        let image = UIImage(named:image)
        let item = UIBarButtonItem(image:image?.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: "itemClick:")
        ActionManager.sharedManager.actionDict[NSValue(nonretainedObject:item)] = handler
        if left{
            self.navigationItem.leftBarButtonItem = item
        }else{
            self.navigationItem.rightBarButtonItem = item
        }

        if let left = self.navigationItem.leftBarButtonItem{
            left.imageInsets = UIEdgeInsetsMake(0,-16,0, 0);
        }
        
        
    }
    
    func itemClick(item:UIBarButtonItem){
        if let closure = ActionManager.sharedManager.actionDict[NSValue(nonretainedObject:item)]{
            closure()
        }
    }
    
}
