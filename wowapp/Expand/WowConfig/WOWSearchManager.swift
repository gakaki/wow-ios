//
//  WOWSearchManager.swift
//  wowapp
//
//  Created by 安永超 on 16/9/6.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

//private let _SingletonASharedInstance = WOWSearchManager()

class WOWSearchManager: NSObject {
    var db: FMDatabase!
    
    static let shareInstance = WOWSearchManager()
    
    override init() {
        super.init()
        
        guard let path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last else {
            return
        }
        
        let filePath = (path as NSString).stringByAppendingPathComponent("demo.sqlite")
        
        db = FMDatabase(path: filePath)
        
        if db.open() == false {
            return
        }
        
        let sql = "CREATE TABLE IF NOT EXISTS t_searchModel (searchStr text, typeData text);"
        
        db.executeUpdate(sql, withArgumentsInArray: nil)
    }
    
    /**
     *  删除语句
     */
    
    func delect(typeData: String) -> Bool
    {

        let sql = "DELETE  FROM t_searchModel WHERE searchStr = (?)"
        
        return (db?.executeUpdate(sql, withArgumentsInArray: [typeData]))!

    }
   
}
