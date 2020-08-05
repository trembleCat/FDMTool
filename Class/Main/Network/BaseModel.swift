//
//  BaseModel.swift
//  guoyuan-civil-ios
//
//  Created by 发抖喵 on 2020/6/19.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit
import ObjectMapper

class BaseModel<T: Mappable>: Mappable {
    
    var code: Int?
    var success: Bool?
    var res: T?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        success <- map["success"]
        res <- map["res"]
    }
}

class BaseArrayModel<T: Mappable>: Mappable {
    
    var code: Int?
    var success: Bool?
    var res: [T]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        success <- map["success"]
        res <- map["res"]
    }
}
