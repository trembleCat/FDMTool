//
//  UpdateSchoolRequest.swift
//  SXReaderS
//
//  Created by 刘涛 on 2020/2/21.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import Foundation
import HandyJSON

class UpdateSchoolRequest: HandyJSON {
    var userId:String? //userId
    var schoolName:String?
    var schoolId:String?
    var className:String?
    var gradeName:String?
    
    var cityId: String?
    var countyId: String?
    var provinceId: String?
    var fullName: String?
    
    init(schoolName:String,schoolId:String,className:String,gradeName:String,userId:String,
         cityId: String , countyId: String , provinceId: String , fullName: String) {
        self.schoolId = schoolId
        self.schoolName = schoolName
        self.className = className
        self.gradeName = gradeName
        self.userId = userId
        
        self.cityId = cityId
        self.countyId = countyId
        self.provinceId = provinceId
        self.fullName = fullName
    }
    
    init(userId:String){
        self.userId = userId
    }
    
    required init() {
        
    }
}
