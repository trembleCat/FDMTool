//
//  FDMUsedColor.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/26.
//

import UIKit

//MARK: - 常用颜色
extension UIColor {
    /**
     黑色 #333333
     */
    class func UsedHex333333(alpha: CGFloat = 1) -> UIColor {
        return UIColor.Hex("#333333", alpha: alpha)
    }
    
    /**
     浅灰色 #666666
     */
    class func UsedHex666666(alpha: CGFloat = 1) -> UIColor {
        return UIColor.Hex("#666666", alpha: alpha)
    }
    
    /**
     浅灰色 #999999
     */
    class func UsedHex999999(alpha: CGFloat = 1) -> UIColor {
        return UIColor.Hex("#999999", alpha: alpha)
    }
    
    /**
     浅灰色 #E3E3E3
     */
    class func UsedHexE3E3E3(alpha: CGFloat = 1) -> UIColor {
        return UIColor.Hex("#E3E3E3", alpha: alpha)
    }
}
