//
//  LoginFunLogEntity.swift
//  SXReaderS
//
//  Created by 刘涛 on 2020/2/24.
//  Copyright © 2020 FolioReader. All rights reserved.
//


import HandyJSON

class LoginFunLogEntity: HandyJSON {
    @objc dynamic var tab: String = "app_function"
    
    @objc dynamic var type: String = ""
    @objc dynamic var create_time: String = ""
    @objc dynamic var user_id: String = ""
    
    @objc dynamic var device_brand: String = ""
    @objc dynamic var rom_version: String = ""
    @objc dynamic var system_version: String = ""
    @objc dynamic var version: String = ""
    @objc dynamic var imei: String = ""
    @objc dynamic var function_id: String = ""
    @objc dynamic var data: String = ""
    @objc dynamic var device_num: String = ""
    
    required init() {}
    
    
    init(type: String , function_id:String,data:String){
        self.tab = "app_function"
        self.type = type
        self.data = data
        self.function_id = function_id
        self.create_time = Date().dataWithYMDHMS()
        if userId != nil {
            self.user_id = userId!
        }else{
            self.user_id = ""
        }
        self.device_brand = "Apple"
        self.system_version = UIDevice.current.systemVersion
        self.rom_version = UIDevice.current.modelName
        
        self.version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        self.imei = UIDevice.current.identifierForVendor!.description
        self.device_num = UIDevice.current.systemName
    }
}
