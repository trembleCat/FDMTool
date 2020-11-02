//
//  LoginResponse.swift
//  SXReader
//
//  Created by 刘涛 on 2018/7/24.
//  Copyright © 2018年 FolioReader. All rights reserved.
//

import Foundation
import RealmSwift

class LoginResponse: DBModel  {
    @objc dynamic var userId: String = ""
    
    @objc dynamic var userName: String = ""
    
    var roleList = List<String>()
    
    override class func primaryKey() -> String? { return "userId" }
}
