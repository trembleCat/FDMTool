//
//  UserPerferenceModel.swift
//  SXReaderS
//
//  Created by 发抖喵 on 2020/9/10.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import UIKit
import RealmSwift

class UserPerferenceModel: DBModel {
    var list = List<UserPerferenceEntity>()
}
