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
    var dbQueue: FMDatabaseQueue!
    
    static let shareInstance = WOWSearchManager()
    
    override init() {
        super.init()
        
        guard let path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last else {
            return
        }
        
        let filePath = (path as NSString).stringByAppendingPathComponent("demo.sqlite")
        
        dbQueue = FMDatabaseQueue(path: filePath)
        
//        if db.open() == false {
//            return
//        }
        
        let sql = "CREATE TABLE IF NOT EXISTS t_searchModel (id integer PRIMARY KEY, searchStr text, typeData text);"
        
       
        dbQueue.inDatabase { (db) in
             db.executeUpdate(sql, withArgumentsInArray: nil)
        }
    }
    
    /**
     *  删除语句
     */
    
    func delectAll(typeData: String) -> Void
    {

        let sql = "DELETE  FROM t_searchModel WHERE typeData = (?)"
        dbQueue.inDatabase { (db) in
            db.executeUpdate(sql, withArgumentsInArray: [typeData])
        }
        
//        return (dbQueue?.executeUpdate(sql, withArgumentsInArray: [typeData]))!

    }
    
    /**
     *  删除语句
     */
    
    func delectSame(searchStr: String) -> Void
    {
        
        let sql = "DELETE  FROM t_searchModel WHERE searchStr = (?)"
        
        dbQueue.inDatabase { (db) in
            db.executeUpdate(sql, withArgumentsInArray: [searchStr])
        }
//        return (db?.executeUpdate(sql, withArgumentsInArray: [searchStr]))!
        
    }
    
    /**
     *  插入语句
     */
    func insert(search: String) -> Void {
        delectSame(search)
        let sql = "INSERT INTO t_searchModel(searchStr,typeData)VALUES(?,?);"
        dbQueue.inDatabase { (db) in
            db.executeUpdate(sql, withArgumentsInArray: [search,"1"])
        }
//        return db!.executeUpdate(sql, withArgumentsInArray: [search,"1"])
    }
   
}
