//
//  UIDevice+Add.swift
//  SwiftProject
//
//  Created by 王云鹏 on 16/3/4.
//  Copyright © 2016年 王涛. All rights reserved.
//

import Foundation

public enum DeviceType: Int
{
    case DT_UNKNOWN = 0
    case DT_iPhone4S          //iPhone4S、iPhone4
    case DT_iPhone5           //iPhone5、iPhone5C和iPhone5S
    case DT_iPhone6           //iPhone6
    case DT_iPhone6_Plus      //iPhone6 Plus
    case DT_iPad              //iPad1、iPad2
    case DT_iPad_Mini         //iPad mini1
    case DT_iPad_Retina       //New iPad、iPad4和iPad Air
    case DT_iPad_Mini_Retina  //iPad mini2
}

public extension UIDevice{
    static var deviceType:DeviceType{
        get {
            if let size = UIScreen.mainScreen().currentMode?.size{
                switch size{
                case CGSizeMake(640 , 960 ) : return .DT_iPhone4S
                case CGSizeMake(640 , 1136) : return .DT_iPhone5
                case CGSizeMake(750 , 1334) : return .DT_iPhone6
                case CGSizeMake(1242, 2208) : return .DT_iPhone6_Plus
                case CGSizeMake(1024, 768 ) : return .DT_iPad
                case CGSizeMake(768 , 1024) : return .DT_iPad_Mini
                case CGSizeMake(2048, 1536) : return .DT_iPad_Retina
                case CGSizeMake(1536, 2048) : return .DT_iPad_Mini_Retina
                default : return .DT_UNKNOWN
                }
            }
            return .DT_UNKNOWN
        }
    }
    
    
    /**
     判断当前设备是不是iPhone设备
     */
    class func isPhone() -> Bool {
        return UIDevice.currentDevice().userInterfaceIdiom == .Phone
    }
    
    /**
     判断当前设备是不是iPad设备
     */
    class func isPad() -> Bool {
        return UIDevice.currentDevice().userInterfaceIdiom == .Pad
    }
    
    /**
     判断当前设备是不是iPad mini
     */
    class func isPadMini() -> Bool {
        if isPad() {
            let type = deviceType
            if type == .DT_iPad_Mini || type == .DT_iPad_Mini_Retina {
                return true
            }
        }
        
        return false
    }
    
    /**
     判断当前设备是不是iPad设备，不包括iPad mini
     */
    class func isBigPad() -> Bool {
        if isPad() && isPadMini() == false {
            return true
        }
        
        return false
    }
    
    /**
     判断当前设备的系统版本是否大于或者等于#version
     */
    func isGE(version version: String) -> Bool {
        return compare(version: version) != .OrderedAscending
    }
    
    func compare(version version: String) -> NSComparisonResult {
        return UIDevice.currentDevice().systemVersion.compare(version, options: NSStringCompareOptions.NumericSearch)
    }

    
}