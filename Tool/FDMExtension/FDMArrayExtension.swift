//
//  FDMArrayExtension.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/24.
//

import UIKit

//MARK: Array
extension Array {
    
    /**
     数组转json
     */
    func toJSONString() -> String? {
        let array = self as NSArray
        return array.toJSONString()
    }
}

//MARK: NSArray
extension NSArray {
    
    /**
     数组转json
     */
    func toJSONString() -> String? {
        if (!JSONSerialization.isValidJSONObject(self)) {
            return nil
        }
         
        let data : NSData! = try? JSONSerialization.data(withJSONObject: self, options: []) as NSData
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
}
