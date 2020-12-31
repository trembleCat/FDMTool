//
//  JsBridgeData.swift
//  Apple
//
//  Created by 奋斗 on 2019/1/17.
//  Copyright © 2019年 奋斗. All rights reserved.
//

import Foundation
import ObjectMapper

class JsBridgeData: Mappable {
    var status: Bool?
    var msg: String?
    var data: Any?
    
    init() {
    }
    
    init(status: Bool, msg: String) {
        self.status = status
        self.msg = msg
        self.data = Dictionary<String, Any>.init()
    }
    
    init(status: Bool, msg: String, data: Any) {
        self.status = status
        self.msg = msg
        self.data = data
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
}

class JsBridgeDataO<T: Mappable>: Mappable {
    var status: Bool?
    var msg: String?
    var data: T?
    
    init() {
    }
    
    init(status: Bool, msg: String) {
        self.status = status
        self.msg = msg
        self.data = nil
    }
    
    init(status: Bool, msg: String, data: T) {
        self.status = status
        self.msg = msg
        self.data = data
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
}

class JsBridgeArray<T : Mappable>: Mappable {
    var status: Bool?
    var msg: String?
    var data: Array<T>?
    
    init() {
    }
    
    init(status: Bool, msg: String) {
        self.status = status
        self.msg = msg
        self.data = Array.init()
    }
    
    init(status: Bool, msg: String, data: Array<T>) {
        self.status = status
        self.msg = msg
        self.data = data
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        msg <- map["msg"]
        data <- map["data"]
    }
}
