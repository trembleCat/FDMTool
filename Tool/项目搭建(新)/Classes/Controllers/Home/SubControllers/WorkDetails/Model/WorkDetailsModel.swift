//
//  WorkDetailsModel.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/24.
//

import UIKit
import ObjectMapper

//MARK: - 优秀作品详情Model
class WorkDetailsData: Mappable {
    
    /// 优秀作品Id
    var id: String?
    
    /// 作品标题
    var dynamicTitle: String?
    
    /// 作品内容
    var dynamicContent: String?
    
    /// 发布时间
    var updateTime: String?
    
    /// 用户详情
    var user: WorkDetailsUserData?
    
    /// 书籍详情
    var book: WorkDetailsBookInfoData?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        dynamicTitle <- map["dynamicTitle"]
        dynamicContent <- map["dynamicContent"]
        updateTime <- map["updateTime"]
        user <- map["user"]
        book <- map["user"]
    }
}
