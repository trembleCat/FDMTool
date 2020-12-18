//
//  BaseModel.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/24.
//

import UIKit
import ObjectMapper

//MARK: - 基本模型
class BaseData<T>: Mappable {
    var code: Int?
    var data: T?
    var message: String?
    
    required init?(map: Map) {
        if map.JSON["code"] == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        data <- map["data"]
        message <- map["message"]
    }
}


//MARK: - 基本列表分页数据
class BasePagingData: Mappable {
    
    var indexPage: Int?
    
    /// 是否第一页
    var isFirstPage: Bool?
    
    /// 是否最后一页
    var isLastPage: Bool?
    
    var pageNum: Int?
    
    /// 总页数列表
    var pageNums: [Int]?
    
    /// 总条数
    var total: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        indexPage <- map["indexPage"]
        isFirstPage <- map["isFirstPage"]
        isLastPage <- map["isLastPage"]
        pageNum <- map["pageNum"]
        pageNums <- map["pageNums"]
        total <- map["total"]
    }
}
