//
//  EveryDayReadMode.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/27.
//

import UIKit
import ObjectMapper

//MARK: - 每日一读模型
class EveryDayReadData: Mappable {
    
    /// 内容
    var content: String?
    
    /// 时间
    var currentTime: Int?
    
    /// 标题
    var title: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        content <- map["content"]
        currentTime <- map["currentTime"]
        title <- map["currentTime"]
    }
}
