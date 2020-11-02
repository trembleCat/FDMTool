//
//  BookStoreVersionResponse.swift
//  SXReaderS
//
//  Created by 刘涛 on 2019/6/4.
//  Copyright © 2019 FolioReader. All rights reserved.
//

import Foundation
import RealmSwift

class BookStoreVersionResponse: DBModel  {
    @objc dynamic var bookStoreVersion : String = ""
    @objc dynamic var status : Int = 0
}
