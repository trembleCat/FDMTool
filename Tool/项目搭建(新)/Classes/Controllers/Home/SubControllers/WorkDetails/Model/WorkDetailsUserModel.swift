//
//  WorkDetailsUserModel.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/26.
//

import UIKit
import ObjectMapper

class WorkDetailsUserData: Mappable {
    
    /// 用户Id
    var id: String?
    
    /// 用户名_1
    var fullName: String?
    
    /// 用户名_2 可能无数据
    var userName: String?
    
    /// 用户班级
    var className: String?
    
    /// 用户学校名称
    var schoolName: String?
    
    /// 用户头像路径
    var avatarUrl: String?
    
    /// 用户角色
    var role: Int?
    
    /// 用户活动类型
    var userActivityType: Int?
    
    /// 用户类型 ROLE_Student = 学生 / Teacher 教师
    var userAuthority: [String]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        fullName <- map["fullName"]
        userName <- map["userName"]
        className <- map["className"]
        schoolName <- map["schoolName"]
        avatarUrl <- map["avatarUrl"]
        role <- map["role"]
        userActivityType <- map["userActivityType"]
        userAuthority <- map["userAuthority"]
    }
}
