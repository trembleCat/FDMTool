//
//  ThirdPartyManager.swift
//  Apple
//
//  Created by 牛 on 2019/10/14.
//  Copyright © 2019 yunzainfo. All rights reserved.
//

import UIKit
import QMUIKit

//微博登录Manager
class WBApiManager: NSObject, WeiboSDKDelegate {

    static let shared = WBApiManager.init()
    var vc: UIViewController!
    
    var success: ((String) -> ())?
    
    // 登录
    func login(send:UIViewController,success:@escaping ((String) -> ())){
        self.vc = send
        self.success = success
        let request = WBAuthorizeRequest.request() as? WBAuthorizeRequest
        request?.redirectURI = "https://api.weibo.com/oauth2/default.html"
        request?.scope = "all"
        WeiboSDK.send(request)
    }
    
    func didReceiveWeiboRequest(_ request: WBBaseRequest!) {
        
    }
    
    // 接收数据
    func didReceiveWeiboResponse(_ response: WBBaseResponse!) {
        if response.isKind(of: WBAuthorizeResponse.self){
            let resp = response as! WBAuthorizeResponse
            
            //判断是否授权成功
            if response.statusCode.rawValue == 0{
//                AlertViewTools.showTip(message: "授权成功", viewController: vc)
                self.success?(resp.accessToken)
            }else{
                AlertViewTools.showTip(message: "授权失败", viewController: vc)
            }
        }
    }
}


//QQ登录Manager
class QQApiManager: NSObject, TencentSessionDelegate{
    
    static let shared = QQApiManager.init()
    var tencentAuth: TencentOAuth?
    var vc: UIViewController!
    var success: ((String) -> ())?
    
    // 登录
     func login(send:UIViewController,success:@escaping ((String) -> ())){
        self.vc = send
        self.success = success
        
        let permissions = [kOPEN_PERMISSION_GET_SIMPLE_USER_INFO]
        QQApiManager.shared.tencentAuth?.authShareType = AuthShareType_QQ
        QQApiManager.shared.tencentAuth?.authorize(permissions)
     }
    
    // 登录成功
    func tencentDidLogin() {
//        AlertViewTools.showTip(message: "授权成功", viewController: vc)
        let token = QQApiManager.shared.tencentAuth?.getCachedToken() ?? ""
        self.success?(token)
    }
    
    // 登录失败
    func tencentDidNotLogin(_ cancelled: Bool) {
        AlertViewTools.showTip(message: "登录失败", viewController: vc)
    }
    
    // 网络异常
    func tencentDidNotNetWork() {
        AlertViewTools.showTip(message: "网络异常", viewController: vc)
    }
}
