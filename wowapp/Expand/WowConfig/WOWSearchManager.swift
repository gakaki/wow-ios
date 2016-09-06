//
//  WOWSearchManager.swift
//  wowapp
//
//  Created by 安永超 on 16/9/6.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

private let _SingletonASharedInstance = WOWSearchManager()

class WOWSearchManager: NSObject {
    /// 单例
    static let shareInstance: WOWSearchManager = WOWSearchManager()
    
    override init() {
        super.init()
        openDB("searchModel.sqlite")
    }
    
    var db: FMDatabase?
    func openDB(name: String)
    {
        // 1.拼接路径
        let path = name.documentDir()
        
        // 2.创建数据库对象
        db = FMDatabase(path: path)
        
        // 3.打开数据库
        // open()特点: 如果数据库文件不存在就创建一个新的, 如果存在就直接打开
        if !db!.open()
        {
            print("打开数据库失败")
            return
        }
        
        // 4.创建表
        if !createTable()
        {
            print("创建数据库失败")
            return
        }
    }
    
    /**
     创建表
     */
    func createTable() ->Bool
    {
        // 1.编写SQL语句
        let sql = "CREATE TABLE IF NOT EXISTS t_searchModel (id integer PRIMARY KEY, searchModel blob NOT NULL, searchModel_idstr varchar NOT NULL);"
        
        // 2.执行SQL语句
        // 注意: 在FMDB中, 除了查询以外的操作都称之为更新
        return db!.executeUpdate(sql, withArgumentsInArray: nil)
    }
    
    /**
     *  删除语句
     */
    func delect(searchModel_idstr: String) -> Bool
    {
        // 1.编写SQL语句
        let sql = "DELETE  FROM t_searchModel WHERE searchModel_idstr = ?"
        
        // 2.执行SQL语句
        // 注意: 在FMDB中, 除了查询以外的操作都称之为更新
        return db!.executeUpdate(sql, withArgumentsInArray: [searchModel_idstr])
    }
   
}
