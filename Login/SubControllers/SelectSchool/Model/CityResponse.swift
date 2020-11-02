//
//  CityResponse.swift
//  SXReader
//
//  Created by 刘涛 on 2019/6/20.
//  Copyright © 2019 FolioReader. All rights reserved.
//

import Foundation
import RealmSwift

class CityResponse: DBModel  {
    var list = List<CityEntity>()
}
