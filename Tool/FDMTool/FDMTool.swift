//
//  FDMTool.swift
//  FDMPlayerControl
//
//  Created by 发抖喵 on 2020/4/30.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit

// 屏幕高度
let FScreenH = UIScreen.main.bounds.height
// 屏幕宽度
let FScreenW = UIScreen.main.bounds.width

// 手机型号
enum PhoneModel {
    case iPhone4_4s_5_5s_5c
    case iPhone6_6s_7_8
    case iPhone6P_6sP_7P_8p
    case iPhone_X
    case iPhone_XR
    case iPhone_XS
    case iPhone_XS_Max
    case otherFullScreen
}

class FDMTool: NSObject {
    /*==================
     1.普通打印
     2.网络请求打印
     3.快捷弹窗提示 提示
     4.快捷弹窗提示 提示
     5.快捷弹窗提示 好
     6.快捷弹窗提示 确认-取消
     7.获取手机型号
     8.获取状态栏高度
     9.获取tabBar高度
     10.获取底部安全区高度
     11.获取某一天是周几
     12.将周几转为汉字
     13.获取当前 秒级 时间戳 - 10位(带小数点)
     14.获取日期 秒级 时间戳 - 10位(带小数点)
     15.获取当前 毫秒级 时间戳 - 13位(带小数点)
     16.获取日期 毫秒级 时间戳 - 13位(带小数点)
     17.iOS13获取deviceToken
     18.X - N 的随机数
     
     缓存和documents文件大小总和
     documents文件大小
     缓存大小
     清理缓存  -return是否清理成功
     清理documents文件 -return是否清理成功
    ==================*/
    
    /// 1.普通打印
    class func Log<T,K>(title: T, message: K, file: String = #file, funcName: String = #function, lineNum: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("================================\n  标题:【\(title)】\n  文件名:【\(fileName)】\n  行号: 【\(lineNum)】\n  信息: 【\(message)】\n================================")
        #endif
    }
    
    /// 2.网络请求打印
    class func LogWithNetwork<T,K>(title: T, message : K, isSuccess : Bool , file: String = #file, funcName: String = #function, lineNum: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        
        if isSuccess {
            print("================================\n  标题:【\(title) 请求成功】\n  文件名:【\(fileName)】\n  行号: 【\(lineNum)】\n  信息: 【\(message)】\n================================")
        }else{
            print("================================\n  标题:【\(title) 请求失败】\n  文件名:【\(fileName)】\n  行号: 【\(lineNum)】\n  错误信息: 【\(message)】\n================================")
        }
        
        #endif
    }
    
    /// 3.快捷弹窗提示 提示
    class func showTip(message:String, viewController:UIViewController) -> Void {
        show(title: "提示", message: message, viewController: viewController)
    }
    
    /// 4.快捷弹窗提示 提示
    class func showTip(message:String, viewController:UIViewController, okAction: @escaping (UIAlertAction) -> Swift.Void) -> Void {
        show(title: "提示", message: message, viewController: viewController, okAction: okAction)
    }
    
    /// 5.快捷弹窗提示 好
    class func show(title:String, message:String, viewController:UIViewController, okAction: ((UIAlertAction) -> Swift.Void)? = nil) -> Void {
        let av = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let ac = UIAlertAction.init(title: "好", style: UIAlertAction.Style.cancel, handler: okAction)
        av.addAction(ac)
        viewController.present(av, animated: true, completion: nil)
    }
    
    /// 6.快捷弹窗提示 确认-取消
    class func showCancelOrOk(title:String? = nil, message:String? = nil, viewController:UIViewController, okAction: ((UIAlertAction) -> Swift.Void)? = nil ,cancelAction: ((UIAlertAction) -> Swift.Void)? = nil) -> Void {
        let av = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let ac1 = UIAlertAction.init(title: "取消", style: .cancel, handler: cancelAction)
        let ac = UIAlertAction.init(title: "确认", style: .destructive, handler: okAction)
        av.addAction(ac)
        av.addAction(ac1)
        viewController.present(av, animated: true, completion: nil)
    }
    
    /// 7.获取手机型号
    class func getPhoneModel() -> PhoneModel{
        if FScreenW == 320.0 && FScreenH == 480.0{    // iPhone 4_4s_5_5s_5c
            return.iPhone4_4s_5_5s_5c
        }else if FScreenW == 375.0 && FScreenH == 667.0{    // iPhone 6_6s_7_8
            return.iPhone6_6s_7_8
        }else if FScreenW == 414.0 && FScreenH == 736.0{    // iPhone 6P_6sP_7P_8P
            return.iPhone6P_6sP_7P_8p
        }else if FScreenW == 375.0 && FScreenH == 812.0 {    // iPhone X
            return.iPhone_X
        }else if FScreenW == 414.0 && FScreenH == 896.0{    // iPhone XR
            return.iPhone_XR
        }else if FScreenW == 375.0 && FScreenH == 812.0{    // iPhone XS
            return.iPhone_XS
        }else if FScreenW == 414.0 && FScreenH == 896.0{    // iPhone XS Max
            return.iPhone_XS_Max
        }else{  //其他手机
            return.otherFullScreen
        }
    }
    
    /// 8.获取状态栏高度
    class func screenWithStatusHeight() -> CGFloat {
        if getPhoneModel() == .iPhone_X || getPhoneModel() == .iPhone_XR || getPhoneModel() == .iPhone_XS || getPhoneModel() == .iPhone_XS_Max || getPhoneModel() == .otherFullScreen{
            return 44.0
        }else{
            return 20.0
        }
    }
    
    /// 9.获取tabBar高度
    class func screenWithTabBarHeight() -> CGFloat {
        if getPhoneModel() == .iPhone_X || getPhoneModel() == .iPhone_XR || getPhoneModel() == .iPhone_XS || getPhoneModel() == .iPhone_XS_Max || getPhoneModel() == .otherFullScreen{
            return 49.0 + 34.0
        }else{
            return 49.0
        }
    }
    
    /// 10.获取底部安全区高度
    class func screenWithBottomSafeHeight() -> CGFloat {
        if getPhoneModel() == .iPhone_X || getPhoneModel() == .iPhone_XR || getPhoneModel() == .iPhone_XS || getPhoneModel() == .iPhone_XS_Max || getPhoneModel() == .otherFullScreen{
            return 34.0
        }else{
            return 0.0
        }
    }
    
    /// 11.获取某一天是周几 return: [1 - 7]
    class func dayOfWeek(date:Date) -> Int {
        let interval = date.timeIntervalSince1970
        let days = Int(interval / 86400)

        return (days - 3) % 7
    }
    
    /// 12.将周几转为汉字 week:[1 - 7]
    class func weekWithChinese(week:Int) -> String{
        switch week {
            case 1:
                return "周一"
            case 2:
                return "周二"
            case 3:
                return "周三"
            case 4:
                return "周四"
            case 5:
                return "周五"
            case 6:
                return "周六"
            case 7:
                return "周日"
            default:
                return "请输入正确日期 1-7"
        }
    }
    
    /// 13.获取当前 秒级 时间戳 - 10位
    class func timeStamp() -> Double {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let timeStamp = Double(timeInterval)
        return timeStamp
    }
    
    /// 14.获取日期 秒级 时间戳 - 10位
    class func timeStampByDate(_ date: Date) -> Double {
        let timeInterval: TimeInterval = date.timeIntervalSince1970
        let timeStamp = Double(timeInterval)
        return timeStamp
    }
    
    /// 15.获取当前 毫秒级 时间戳 - 13位
    class func milliStamp() -> Double {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return Double(millisecond)
    }
    
    /// 16.获取日期 毫秒级 时间戳 - 13位
    class func milliStampByDate(_ date: Date) -> Double {
        let timeInterval: TimeInterval = date.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return Double(millisecond)
    }
    
    /// 17.iOS13获取deviceToken [didRegisterForRemoteNotificationsWithDeviceToken]
    class func getDeviceTokenWithiOS13(deviceToken: Data) -> String{
        var tokenString = ""
        let bytes = [UInt8](deviceToken)
        for item in bytes {
            tokenString += String(format: "%02x", item&0x000000FF)
        }
        
        return tokenString
    }
    
    /// 18.X - N 的随机数
    class func getArc4random(start:UInt32,end:UInt32) -> CGFloat{
        return CGFloat(arc4random() % (end - start) + start)
    }
    
    /// 缓存和documents文件大小总和
    class func cacheAndDocumentsSize() -> String{
        let documentsFileSize = documentsSize()
        let cacheFileSize = cacheSize()
        return NSString(format: "%.2fMB", (documentsFileSize + cacheFileSize) / 1024.0 / 1024.0 ) as String
    }
    
    /// documents文件大小
    class func documentsSize() -> Float{
        // 路径
        let documentsPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let fileManager = FileManager.default
        // 遍历出所有缓存文件加起来的大小
        func caculateDocuments() -> Float{
            var total: Float = 0
            if fileManager.fileExists(atPath: documentsPath!){
                let childrenPath = fileManager.subpaths(atPath: documentsPath!)
                if childrenPath != nil{
                    for path in childrenPath!{
                        let childPath = documentsPath!.appending("/").appending(path)
                        do{
                            let attr:NSDictionary = try fileManager.attributesOfItem(atPath: childPath) as NSDictionary
                            let fileSize = attr["NSFileSize"] as? Float
                            total += fileSize ?? 0
                            
                        }catch _{
                            
                        }
                    }
                }
            }
            // 缓存文件大小
            return total
        }
        
        return caculateDocuments()
    }
    
    /// 缓存大小
    class func cacheSize() -> Float{
        // 路径
        let basePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let fileManager = FileManager.default
        // 遍历出所有缓存文件加起来的大小
        func caculateCache() -> Float{
            var total: Float = 0
            if fileManager.fileExists(atPath: basePath!){
                let childrenPath = fileManager.subpaths(atPath: basePath!)
                if childrenPath != nil{
                    for path in childrenPath!{
                        let childPath = basePath!.appending("/").appending(path)
                        do{
                            let attr:NSDictionary = try fileManager.attributesOfItem(atPath: childPath) as NSDictionary
                            let fileSize = attr["NSFileSize"] as? Float
                            total += fileSize ?? 0
                            
                        }catch _{
                            
                        }
                    }
                }
            }
            // 缓存文件大小
            return total
        }
        
        return caculateCache()
    }
    
    /// 清理缓存  -return是否清理成功
    class func cacheWithClear() -> Bool {
        var result = true
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        // 遍历删除
        for file in fileArr! {
            // 拼接文件路径
            let path = cachePath?.appending("/\(file)")
            if FileManager.default.fileExists(atPath: path!) {
                // 循环删除
                do {
                    try FileManager.default.removeItem(atPath: path!)
                } catch {
                    // 删除失败
                    result = false
                }
            }
        }
        return result
    }
    
    /// 清理documents文件 -return是否清理成功
    class func documentsWithClear() -> Bool {
        var result = true
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let documentsPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: documentsPath!)
        // 遍历删除
        for file in fileArr! {
            // 拼接文件路径
            let path = documentsPath?.appending("/\(file)")
            if FileManager.default.fileExists(atPath: path!) {
                // 循环删除
                do {
                    try FileManager.default.removeItem(atPath: path!)
                } catch {
                    // 删除失败
                    result = false
                }
            }
        }
        return result
    }
}