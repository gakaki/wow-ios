//
//  UIViewController+Add.swift
//  WowLib
//
//  Created by 王云鹏 on 16/3/18.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//


import UIKit

public typealias NavigationItemHandler = () -> ()

public extension UIViewController{
    
    func makeCustomerNavigationItem(title:String!,left:Bool,isOffset:Bool = false,handler:NavigationItemHandler?){
//        self.navigationItem.leftBarButtonItems = nil
        let item = UIBarButtonItem(title: title, style: .Plain, target: self, action: #selector(UIViewController.itemClick(_:)))
        if let action = handler {
             ActionManager.sharedManager.actionDict[NSValue(nonretainedObject:item)] = action
        }
        if left{
            self.navigationItem.leftBarButtonItem = item                              
        }else{
            self.navigationItem.rightBarButtonItem = item
        }
        if isOffset {
            if let left = self.navigationItem.leftBarButtonItem{
                let offset = UIDevice.deviceType.rawValue > 3 ? -20 : -16
                left.imageInsets = UIEdgeInsetsMake(0,CGFloat(offset),0, 0);
            }
        }
        
    }
    
    func makeCustomerImageNavigationItem(image:String!,left:Bool,isOffset:Bool = false,handler:NavigationItemHandler){
        let image = UIImage(named:image)
        let item = UIBarButtonItem(image:image?.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: #selector(UIViewController.itemClick(_:)))
        ActionManager.sharedManager.actionDict[NSValue(nonretainedObject:item)] = handler
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        spaceItem.width = -10
        
        if left{
            self.navigationItem.leftBarButtonItem = item
//            self.navigationItem.leftBarButtonItems = [spaceItem,item]
        }else{
            self.navigationItem.rightBarButtonItem = item
        }
        
        if isOffset {
            if let left = self.navigationItem.leftBarButtonItem{
                let offset = UIDevice.deviceType.rawValue > 3 ? -20 : -16
                left.imageInsets = UIEdgeInsetsMake(0,CGFloat(offset),0, 0);
            }
        }else{
            if let left = self.navigationItem.rightBarButtonItem{
                let offset = UIDevice.deviceType.rawValue > 3 ? -20 : -16
                left.imageInsets = UIEdgeInsetsMake(0,CGFloat(offset),0, 8);
            }
        }
    }
    
    func makeBuyCarNavigationItem(carEntranceButton:UIButton, handler:NavigationItemHandler){

        
        let item = UIBarButtonItem(customView: carEntranceButton)

        carEntranceButton.addAction {
            #selector(UIViewController.itemClick(_:))
        }
        
        
        ActionManager.sharedManager.actionDict[NSValue(nonretainedObject:carEntranceButton)] = handler
        
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        spaceItem.width = -10
        self.navigationItem.rightBarButtonItem = item
        self.navigationItem.rightBarButtonItems = [spaceItem,item]
    
        if let left = self.navigationItem.rightBarButtonItem{
            let offset = UIDevice.deviceType.rawValue > 3 ? -20 : -16
            left.imageInsets = UIEdgeInsetsMake(0,CGFloat(offset),0, 8);
        }
    
    }
    
    func makeRightNavigationItem(navigationItem:UIView){
        
        let item = UIBarButtonItem(customView: navigationItem)
        
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        spaceItem.width = -10
        self.navigationItem.rightBarButtonItem = item
        self.navigationItem.rightBarButtonItems = [spaceItem,item]
        
        if let left = self.navigationItem.rightBarButtonItem{
            let offset = UIDevice.deviceType.rawValue > 3 ? -20 : -16
            left.imageInsets = UIEdgeInsetsMake(0,CGFloat(offset),0, 8);
        }
        
    }
   
    
    func itemClick(item:UIBarButtonItem){
        if let closure = ActionManager.sharedManager.actionDict[NSValue(nonretainedObject:item)]{
            closure()
        }
    }
    
    
    /**
     获取自己之前的视图
     
     - returns:
     */
    func forwardController() ->UIViewController?{
        let vcs = self.navigationController?.viewControllers
        if let controllers = vcs {
            let position =  controllers.indexOf(self)
            return controllers[position! - 1]
        }
        return nil
    }
    
    func forwardControllerType(controller:AnyClass) -> Bool {
        if let v = forwardController(){
            if v.isKindOfClass(controller) {
                return true
            }
        }
        return false
    }
    
}
