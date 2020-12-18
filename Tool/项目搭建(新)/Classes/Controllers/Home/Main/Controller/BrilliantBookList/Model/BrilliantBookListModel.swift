//
//  BrilliantBookListModel.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/30.
//

import UIKit
import ObjectMapper

//MARK: - 精品书单数据
class BrilliantBookData: Mappable {
    
    /// 书单列表数据
    var list: [BrilliantBookListData]?
    
    /// 分页数据
    var paging: BasePagingData?
    
    /// 数量 0
    var total: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        list <- map["list"]
        paging <- map["paging"]
        total <- map["total"]
    }
}

//MARK: - 书单列表数据
class BrilliantBookListData: Mappable{
    
    /// id
    var id: String?
    
    /// 图片
    var attachId: String?
    
    /// 说明
    var description: String?
    
    /// 标题
    var title: String?
    
    /// 书籍信息number
    var bookInfoNumber: Int?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        attachId <- map["attachId"]
        description <- map["description"]
        title <- map["title"]
        bookInfoNumber <- map["bookInfoNumber"]
    }
}
