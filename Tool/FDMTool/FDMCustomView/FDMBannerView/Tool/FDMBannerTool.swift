//
//  FDMBannerTool.swift
//  FDMImageBannerDemo
//
//  Created by 发抖喵 on 2020/12/30.
//

import UIKit

    /// 1.打印
    public func BannerLog<T,K>(title: T, message: K, file: String = #file, funcName: String = #function, lineNum: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("================================\n  标题:【\(title)】\n  文件名:【\(fileName)】\n  行号: 【\(lineNum)】\n  信息: 【\(message)】\n================================")
        #endif
    }

extension Double {
    
    /// 四舍五入保留 places 位值
    func bannerRoundTo(places: Int) -> Double {
        let divisor = pow(10.0,Double(places))
        return (self * divisor).rounded() / divisor
    }
}
