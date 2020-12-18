//
//  FDMDictionaryExtension.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/24.
//

import UIKit

//MARK: Dictionary
extension Dictionary {
    
    /**
     Dictionary<String,Any>转Json字符串
     */
    func toJSONString() -> String?{
        let dictionary = self as NSDictionary
        return dictionary.toJSONString()
    }
}

//MARK: NSDictionary
extension NSDictionary {
    
    /**
     Dictionary<String,Any>转Json字符串
     */
    func toJSONString() -> String?{
        if (!JSONSerialization.isValidJSONObject(self)) {
            return nil
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: self, options: []) as NSData
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
}
