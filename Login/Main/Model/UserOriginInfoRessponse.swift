//
//  UserOriginInfoRessponse.swift
//  SXReaderS
//
//  Created by 刘涛 on 2020/2/22.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import Foundation
import RealmSwift

class UserOriginInfoRessponse: DBModel  {
    @objc dynamic var className: String? = ""
    @objc dynamic var gradeName: String? = ""
    @objc dynamic var schoolId: String = ""
    @objc dynamic var schoolName: String = ""
    @objc dynamic var userId: String = ""
    
    @objc dynamic var cityId: String = ""
    @objc dynamic var countyId: String = ""
    @objc dynamic var provinceId: String = ""
    @objc dynamic var fullName: String = ""
}
