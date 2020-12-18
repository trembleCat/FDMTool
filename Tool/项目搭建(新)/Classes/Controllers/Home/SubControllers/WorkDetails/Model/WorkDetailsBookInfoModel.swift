//
//  WorkDetailsBookInfoModel.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/26.
//

import UIKit
import ObjectMapper

//MARK: - 书籍信息
class WorkDetailsBookInfoData: Mappable {
    
    /// 书籍id
    var bookInfoId: String?
    
    /// 书籍名称
    var bookName: String?
    
    /// 作者
    var author: String?
    
    /// 书籍简介
    var contentAbstract: String?
    
    /// 书籍图片
    var coverUrl: String?
    
    /// 书籍下载地址
    var ebookUrl: String?
    
    /// eink类型
    var einkType: Int?
    
    /// 书籍路径地址
    var partEbookUrl: String?
    
    /// 类型 type = 1 书城 & = 2 用户上传的epub & = 3 用户上传的文档
    var type: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        bookInfoId <- map["bookInfoId"]
        bookName <- map["bookName"]
        author <- map["author"]
        contentAbstract <- map["contentAbstract"]
        coverUrl <- map["coverUrl"]
        ebookUrl <- map["ebookUrl"]
        einkType <- map["einkType"]
        partEbookUrl <- map["partEbookUrl"]
        type <- map["type"]
    }
}
