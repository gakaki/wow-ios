//
//  Int+Add.swift
//  wowapp
//
//  Created by 陈旭 on 16/8/30.
//  Copyright © 2016年 小黑. All rights reserved.
//

import Foundation
extension Int {
    // 一行排两个，根据总数返回多少行
    func getParityCellNumber() -> Int {
        return  ((self % 2) == 0 ? (self / 2) : ((self / 2) + 1))
    }
    
    func intToThousand() -> String {
        if self >= 1000 {
            let sum = Float(self)
            let result:Float = Float(sum/1000)
            
            return String(format: "%.1fK", result)
        }else {
            return "\(self)"
        }
    }
}
public extension Int {
    /*
     5分钟以内发布显示‘’刚刚”
     
     5分钟以外一小时以内显示‘’ **分钟之前’’
     
     一小时以外今日以内显示‘’ **小时之前’’
     
     昨日发布显示‘’昨天 **:**’’
     
     非今日和昨日发布显示‘’**-** **:**’’
     
     非今年发布显示‘’**-**-** **:**’’
     */
    var currentTimeInterval : TimeInterval {
        return NSDate().timeIntervalSince1970
    }
    
    //MARK: 根据规则返回对应的字符串
    func getTimeString() -> String {
        if isToday {
            //            if minute < 5 {
            //                return "刚刚"
            //            } else
            if hour < 1 {
                return "刚刚"
            } else {
                return "\(hour)小时前"
            }
        } else if isYear {
            if hour < 24{
                return "\(hour)小时前"
            }
            if day < 4 {
                return "\(day)天前"
            }
            return noYesterdayTimeStr()
        } else {
            if year < 1 {
                return "去年"
            }
            return "\(year)年前"
        }
    }
    
    fileprivate var selfDate : Date {
        return Date(timeIntervalSince1970: TimeInterval(self))
    }
    
    /// 距当前有几分钟
    var minute : Int {
        let dateComponent = Calendar.current.dateComponents([.minute], from: selfDate, to: Date())
        return dateComponent.minute!
    }
    
    /// 距当前有几小时
    var hour : Int {
        let dateComponent = Calendar.current.dateComponents([.hour], from: selfDate, to: Date())
        return dateComponent.hour!
    }
    
    /// 距当前有几天
    var day : Int {
        let dateComponent = Calendar.current.dateComponents([.day], from: selfDate, to: Date())
        return dateComponent.day!
    }
    
    /// 距当前有几年
    var year : Int {
        let dateComponent = Calendar.current.dateComponents([.year], from: selfDate, to: Date())
        return dateComponent.year!
    }
    /// 是否是今天
    var isToday : Bool {
        return Calendar.current.isDateInToday(selfDate)
    }
    
    /// 是否是昨天
    var isYesterday : Bool {
        return Calendar.current.isDateInYesterday(selfDate)
    }
    
    /// 是否是今年
    var isYear: Bool {
        let nowComponent = Calendar.current.dateComponents([.year], from: Date())
        let component = Calendar.current.dateComponents([.year], from: selfDate)
        return (nowComponent.year == component.year)
    }
    
    func yesterdayTimeStr() -> String {
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        return format.string(from: selfDate)
    }
    
    func noYesterdayTimeStr() -> String {
        let format = DateFormatter()
        format.dateFormat = "MM月dd日"
        return format.string(from: selfDate)
    }
    
    func yearTimeStr() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy年前"
        return format.string(from: selfDate)
    }
}
