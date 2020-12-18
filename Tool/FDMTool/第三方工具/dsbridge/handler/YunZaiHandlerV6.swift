//
//  YunZaiHandlerV6.swift
//  Apple
//
//  Created by 奋斗 on 2018/9/12.
//  Copyright © 2018年 yunzainfo. All rights reserved.
//

import UIKit

class YunZaiHandlerV6{
    
    var vc: MainWebViewController?
    
    init(vc: MainWebViewController?) {
        self.vc = vc
    }
    
    /// 返回唯一标识
    @objc func getDeviceInfo(arg: Any, completionHandler: (_ result: Any, _ complete: Bool) -> ()) {
        completionHandler(JsBridgeData.init(status: true, msg: "ok", data: ["deviceId": FCUUID.uuidForDevice()]).toJSONString()!, true)
    }
    
    ///同步获取token
//    @objc func getTokenSync(arg: Any) -> String {
//        let resultDic = ["accessToken": AppConfig.shared.loginData?.access_token ?? "",
//                        "tokenDateLine": "\(AppConfig.shared.loginData?.expires_in ?? -1)"]
//
//        return JsBridgeData(status: true, msg: "ok", data: resultDic).toJSONString()!
//    }

    ///异步获取token
//    @objc func getToken(arg: Any, completionHandler: (_ result: Any, _ complete: Bool) -> ()) {
//        let paramString = arg as! String
//        let paramDic = paramString.toDictionary() ?? ["":""]
//        let refresh = paramDic["refresh"] as? Bool
//
//        if refresh ?? false {
//            // 刷新token
//            let resultDic = ["accessToken": AppConfig.shared.loginData?.access_token ?? "",
//                            "tokenDateLine": "\(AppConfig.shared.loginData?.expires_in ?? -1)"]
//
//            completionHandler(JsBridgeData(status: true, msg: "ok", data: resultDic).toJSONString()!, true)
//        }else{
//            let resultDic = ["accessToken": AppConfig.shared.loginData?.access_token ?? "",
//                            "tokenDateLine": "\(AppConfig.shared.loginData?.expires_in ?? -1)"]
//
//            completionHandler(JsBridgeData(status: true, msg: "ok", data: resultDic).toJSONString()!, true)
//        }
//    }
    
    /// 同步获取用户信息
//    @objc func getUserInfoSync(arg: Any) -> String {
//        if AppConfig.shared.userConfig == nil {
//            return JsBridgeData(status: false, msg: "App获取用户信息失败").toJSONString()!
//        }else{
//            return JsBridgeData(status: true, msg: "ok", data: AppConfig.shared.userConfig!.toJSON()).toJSONString()!
//        }
//    }
    
    /// 异步获取用户信息
//    @objc func getUserInfo(arg: Any, completionHandler: (_ result: Any, _ complete: Bool) -> ()) {
//        if AppConfig.shared.userConfig == nil {
//            completionHandler(JsBridgeData(status: false, msg: "App获取用户信息失败").toJSONString()!, true)
//        }else {
//            completionHandler(JsBridgeData(status: true, msg: "ok", data: AppConfig.shared.userConfig!.toJSON()).toJSONString()!, true)
//        }
//    }
//
}



