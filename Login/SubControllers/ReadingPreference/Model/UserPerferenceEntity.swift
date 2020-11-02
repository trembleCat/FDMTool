//
//  UserPerferenceEntity.swift
//  SXReaderS
//
//  Created by 发抖喵 on 2020/9/10.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import UIKit

class UserPerferenceEntity: DBModel {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    
    var isSelected = false
}
