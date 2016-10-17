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
        
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last else {
            return
        }
        
        let filePath = (path as NSString).appendingPathComponent("demo.sqlite")
        
        db = FMDatabase(path: filePath)
        
        if db.open() == false {
            return
        }
        
        let sql = "CREATE TABLE IF NOT EXISTS t_searchModel (id integer PRIMARY KEY, searchStr text, typeData text);"
        
       
        db.executeUpdate(sql, withArgumentsIn: nil)
    
    }
    
    /**
     *  删除语句
     */
    
    func delectAll(_ typeData: String) -> Bool
    {

        let sql = "DELETE  FROM t_searchModel WHERE typeData = (?)"
        
        return (db?.executeUpdate(sql, withArgumentsIn: [typeData]))!

    }
    
    /**
     *  删除语句
     */
    
    func delectSame(_ searchStr: String) -> Bool
    {
        
        let sql = "DELETE  FROM t_searchModel WHERE searchStr = (?)"
  
        return (db?.executeUpdate(sql, withArgumentsIn: [searchStr]))!
        
    }
    
    /**
     *  插入语句
     */
    func insert(_ search: String) -> Bool {
        delectSame(search)
        let sql = "INSERT INTO t_searchModel(searchStr,typeData)VALUES(?,?);"

        return db!.executeUpdate(sql, withArgumentsIn: [search,"1"])
    }
   
}
