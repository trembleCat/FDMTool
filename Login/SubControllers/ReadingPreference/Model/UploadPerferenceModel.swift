//
//  UploadPerferenceModel.swift
//  SXReaderS
//
//  Created by 发抖喵 on 2020/9/11.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import UIKit
import HandyJSON

class UploadPerferenceModel: HandyJSON {
    
    var id: String?
    var name: String?
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    required init() {
        
    }
}
