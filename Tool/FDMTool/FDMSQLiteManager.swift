//
//  FDMSQLiteManager.swift
//  Apple
//
//  Created by 发抖喵 on 2020/1/8.
//  Copyright © 2020 yunzainfo. All rights reserved.
//
//  多线程FMDB

import UIKit
import FMDB

class FDMSQLiteManager: NSObject {
    
    static let shared = FDMSQLiteManager()
    
    /// 数据库队列
    var dbQueue: FMDatabaseQueue?
    
    /// 打开数据库
    func openDataBase(dbName:String,searchPath:FileManager.SearchPathDirectory) {
        let path = NSSearchPathForDirectoriesInDomains(searchPath, .userDomainMask, true).first!
        
        if dbName.contains(".sqlite") {
            let filePath = path + "/" + dbName
            dbQueue = FMDatabaseQueue(path: filePath)
        }else{
            let filePath = path + "/" + dbName + ".sqlite"
            dbQueue = FMDatabaseQueue(path: filePath)
        }
    }
    
    /// 增删改 创建表等
    func executeUpdate(title:String,sql:String,values:[Any]?) {
        dbQueue?.inTransaction({ (db, ump) in
            do{
                try db.executeUpdate(sql, values: values)
            }catch{
                FDMQuick.Log(title: title, message: "失败")
            }
        })
    }
    
    /// 查询数据
    func executeQuery(sql:String,result:(FMResultSet) -> ()){
        dbQueue?.inTransaction({ (db, ump) in
            do{
                result(try db.executeQuery(sql, values: nil))
            }catch{
                FDMQuick.Log(title: "查询数据", message: "失败")
            }
        })
    }
}
