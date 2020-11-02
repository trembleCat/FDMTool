//
//  UserInfoResponse.swift
//  SXReader
//
//  Created by 刘涛 on 2018/7/27.
//  Copyright © 2018年 FolioReader. All rights reserved.
//

import Foundation
import RealmSwift

class UserInfoResponse: DBModel {
    @objc dynamic var isLogin : Int = 1
    @objc dynamic var event : User!
    
    @objc dynamic var userId: String = ""
    
    override class func primaryKey() -> String? { return "userId" }
}
