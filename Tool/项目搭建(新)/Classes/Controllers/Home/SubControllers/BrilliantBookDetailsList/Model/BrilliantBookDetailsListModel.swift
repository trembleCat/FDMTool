//
//  BrilliantBookDetailsListModel.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/12/1.
//

import UIKit
import ObjectMapper

//MARK: - 书单详情数据
class BrilliantBookDetailsData: Mappable {
    
    /// 当前详情数据
    var brilliantBookListEvent: brilliantBookListEventData?
    
    /// 列表数据
    var bookEventList: [BrilliantBookDetailsListData]?
    
    /// 分页数据
    var paging: BasePagingData?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        brilliantBookListEvent <- map["brilliantBookListEvent"]
        bookEventList <- map["bookEventList"]
        paging <- map["bookEventListPaging"]
    }
}


//MARK: - 书单简介数据
class brilliantBookListEventData: Mappable {
    
    /// id
    var id: String?
    
    /// 标题
    var title: String?
    
    /// 图片
    var attachId: String?
    
    /// bookInfoNumber
    var bookInfoNumber: Int?
    
    /// 介绍
    var description: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        title <- map["title"]
        attachId <- map["attachId"]
        bookInfoNumber <- map["bookInfoNumber"]
        description <- map["description"]
        
    }
}


//MARK: - 书单详情列表数据
class BrilliantBookDetailsListData: Mappable {
    
    /// id
    var id: String?
    
    /// 音频Id
    var audioListenId: String?
    
    /// 作者
    var author: String?
    
    /// 书名
    var bookName: String?
    
    /// 内容描述
    var contentAbstract: String?
    
    /// 书籍图片
    var coverUrl: String?
    
    /// 阅读数量
    var readNum: Int?
    
    ///
    var chapterCnt: Int?
    
    ///
    var eSalePrice: Int?
    
    ///
    var publisher: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        audioListenId <- map["audioListenId"]
        author <- map["author"]
        bookName <- map["bookName"]
        chapterCnt <- map["chapterCnt"]
        contentAbstract <- map["contentAbstract"]
        coverUrl <- map["coverUrl"]
        eSalePrice <- map["eSalePrice"]
        publisher <- map["publisher"]
        readNum <- map["readNum"]
    }
}
