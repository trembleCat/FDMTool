//
//  LoginErrorEntity.swift
//  SXReaderS
//
//  Created by 刘涛 on 2020/2/19.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import RealmSwift

class LoginErrorEntity: DBModel {
    @objc dynamic var account: String = ""
    @objc dynamic var times: Int = 0
    @objc dynamic var timeStamp: Int = 0
    
    override class func primaryKey() -> String? {
        return "account"
    }
}
