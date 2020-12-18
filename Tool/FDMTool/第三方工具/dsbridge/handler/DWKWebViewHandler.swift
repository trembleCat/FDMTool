//
//  DWKWebViewHandler.swift
//  guoyuan-civil-ios
//
//  Created by 发抖喵 on 2020/6/19.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit

class DWKWebViewHandler: NSObject {
    
    let vc : UIViewController?
    init(vc: UIViewController?) {
        self.vc = vc
    }

        /// 异步返回唯一标识
//        @objc func getDeviceInfo(arg: Any, completionHandler: (_ result: Any, _ complete: Bool) -> ()) {
//            completionHandler(JsBridgeData.init(status: true, msg: "ok", data: ["deviceId": FCUUID.uuidForDevice()]).toJSONString()!, true)
//        }
        
        ///同步获取token
    //    @objc func getTokenSync(arg: Any) -> String {
    //        let resultDic = ["accessToken": AppConfig.shared.loginData?.access_token ?? "",
    //                        "tokenDateLine": "\(AppConfig.shared.loginData?.expires_in ?? -1)"]
    //
    //        return JsBridgeData(status: true, msg: "ok", data: resultDic).toJSONString()!
    //    }
}
