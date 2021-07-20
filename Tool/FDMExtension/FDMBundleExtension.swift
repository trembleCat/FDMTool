//
//  FDMBundleExtension.swift
//
//
//  Created by 发抖喵 on 2021/7/15.
//

import UIKit

//MARK: - Bundle
public extension Bundle {
    
    /**
     返回一个 Framework 内的Bundle
     
     - parameter name: framework 名称
     - parameter bundleName: bundle 名称，默认与 name 相同 (bundleName 需要添加后缀)
     
     - returns: Bundle?
     */
    class func frameworkBundle(_ name: String, bundleName: String? = nil) -> Bundle? {
        var frameworksUrl = Bundle.main.url(forResource: "Frameworks", withExtension: nil)
        frameworksUrl = frameworksUrl?.appendingPathComponent(name)
        frameworksUrl = frameworksUrl?.appendingPathExtension("framework")
        
        guard let frameworkBundleUrl = frameworksUrl else {
            return nil
        }
        
        let bundle = Bundle(url: frameworkBundleUrl)
        frameworksUrl = bundle?.url(forResource: bundleName ?? name, withExtension: (bundleName?.isEmpty ?? true) ? "bundle" : nil)
        
        guard let bundleUrl = frameworksUrl else {
            return nil
        }
        
        return Bundle(url: bundleUrl)
    }
}
