//
//  WXApiManager.swift
//  Cherry
//
//  Created by 奋斗 on 2018/12/7.
//  Copyright © 2018年 yunzainfo. All rights reserved.
//

import UIKit
//微信appid
let WX_APPID=""
//AppSecret
let SECRET=""
//微信
class WXApiManager:NSObject,WXApiDelegate {
    
    static let shared = WXApiManager()
    // 用于弹出警报视图，显示成功或失败的信息()
    private weak var sender: UIViewController! //(UIViewController)
    // 支付成功的闭包
    private var paySuccessClosure: ((Int) -> Void)?
    // 支付失败的闭包
    private var payFailClosure: ((Int) -> Void)?
    //登录成功
    private var loginSuccessClosure:((_ code:String) -> Void)?
    //登录失败
    private var loginFailClosure:(() -> Void)?
    // 外部用这个方法调起微信支付
    func payAlertController(_ sender: UIViewController,
                            request: PayReq,
                            paySuccess: @escaping (_ : Int) -> Void,
                            payFail: @escaping (_ : Int) -> Void) {
        // sender 是调用这个方法的控制器，
        // 用于提示用户微信支付结果，可以根据自己需求是否要此参数。
        self.sender = sender
        self.paySuccessClosure = paySuccess
        self.payFailClosure = payFail
        if checkWXInstallAndSupport(){//检查用户是否安装微信
            WXApi.send(request)
        }
    }
    //外部用这个方法调起微信登录
    func login(_ sender: UIViewController,loginSuccess: @escaping ( _ code:String) -> Void,
               loginFail:@escaping () -> Void){
        // sender 是调用这个方法的控制器，
        // 用于提示用户微信支付结果，可以根据自己需求是否要此参数。
        self.sender = sender
        self.loginSuccessClosure = loginSuccess
        self.loginFailClosure = loginFail
        if checkWXInstallAndSupport(){
            let req=SendAuthReq()
            req.scope="snsapi_userinfo"
            req.state="app"
            WXApi.send(req)
        }
    }
    
    func onResp(_ resp: BaseResp) {
        if resp is PayResp {//支付
            if resp.errCode == 0 {
                self.paySuccessClosure?(Int(resp.errCode))
            }else{
                self.payFailClosure?(Int(resp.errCode))
            }
        }else if resp is SendAuthResp{//登录结果
            let authResp = resp as! SendAuthResp
            var strMsg: String
            if authResp.errCode == 0{
                strMsg="微信授权成功"
            }else{
                switch authResp.errCode{
                case -4:
                    strMsg="您拒绝使用微信登录"
                    break
                case -2:
                    strMsg="您取消了微信登录"
                    break
                default:
                    strMsg="微信登录失败"
                    break
                }
            }
            
            if authResp.errCode == 0 {
                self.loginSuccessClosure?(authResp.code ?? "")
                
            }else{
                FDMTool.show(title: "授权结果", message: strMsg, viewController: sender) { (action) in
                    self.loginFailClosure?()
                }

            }
        }
    }
}


extension WXApiManager {
    // 检查用户是否已经安装微信并且有支付功能
    private func checkWXInstallAndSupport() -> Bool {
        if !WXApi.isWXAppInstalled() {
            FDMTool.showTip(message: "微信未安装", viewController: sender)
            return false
        }
        if !WXApi.isWXAppSupport() {
            FDMTool.showTip(message: "当前微信版本不支持支付", viewController: sender)
            return false
        }
        return true
    }
}
