//
//  SchoolListResponse.swift
//  SXReaderS
//
//  Created by 刘涛 on 2020/2/21.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import Foundation
import RealmSwift

class SchoolListResponse: DBModel  {
    var list = List<SchoolEntity>()
}
