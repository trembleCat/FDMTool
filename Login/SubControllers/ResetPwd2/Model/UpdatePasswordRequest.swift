//
//  UpdatePasswordRequest.swift
//  SXReaderS
//
//  Created by 刘涛 on 2020/1/15.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import Foundation
import HandyJSON

class UpdatePasswordRequest: HandyJSON {
    var userId:String = "" //userId
    var password:String = "" //password

    
    init(userId:String,password:String) {
        self.userId = userId
        self.password = password
    }
    
    required init() {}
}
