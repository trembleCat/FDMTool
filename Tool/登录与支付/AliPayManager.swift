//
//  AliPayManager.swift
//  Cherry
//
//  Created by 奋斗 on 2018/12/10.
//  Copyright © 2018年 yunzainfo. All rights reserved.
//

//支付宝
class AliPayManager:NSObject{
    static let shared = AliPayManager()
    // 用于弹出警报视图，显示成功或失败的信息
    fileprivate weak var sender: UIViewController!
    // 支付成功的闭包
    fileprivate var paySuccessClosure: ((_ : String) -> Void)?
    // 支付失败的闭包
    fileprivate var payFailClosure: ((_ : String) -> Void)?
    ///登录成功的闭包
    fileprivate var loginSuccessClosure:((_ auth_code:String) -> Void)?
    ///登录失败的闭包
    fileprivate var loginFailClosure:(() -> Void)?
    // 外部用这个方法调起支付支付
    func payAlertController(_ sender: UIViewController,
                            request:String,
                            paySuccess: @escaping (_ : String) -> Void,
                            payFail:@escaping (_ : String) -> Void) {
        // sender 是调用这个方法的控制器，
        self.sender = sender
        //用于提示用户支付宝支付结果，可以根据自己需求是否要此参数。
        self.paySuccessClosure = paySuccess
        self.payFailClosure = payFail
        AlipaySDK.defaultService().payOrder(request, fromScheme: AppSetting.aliPaySchemes, callback:nil)
    }
    //外部用这个方法调起支付宝登录
    func login(_ sender: UIViewController,withInfo: String,loginSuccess: @escaping (_ str:String) -> Void,loginFail:@escaping () -> Void){
        // sender 是调用这个方法的控制器，
        // 用于提示用户微信支付结果，可以根据自己需求是否要此参数。
        self.sender = sender
        self.loginSuccessClosure = loginSuccess
        self.loginFailClosure = loginFail
        AlipaySDK.defaultService().auth_V2(withInfo:withInfo, fromScheme: AppSetting.aliPaySchemes, callback:nil)
    }
    ///授权回调
    func showAuth_V2Result(result:NSDictionary){
        //        9000    请求处理成功
        //        4000    系统异常
        //        6001    用户中途取消
        //        6002    网络连接出错
        let returnCode:String = result["resultStatus"] as! String
        var returnMsg:String = ""
        switch  returnCode{
        case "6001":
            returnMsg = "用户中途取消"
            break
        case "6002":
            returnMsg = "网络连接出错"
            break
        case "4000":
            returnMsg = "系统异常"
            break
        case "9000":
            returnMsg = "授权成功"
            break
        default:
            returnMsg = "系统异常"
            break
        }
        FDMTool.show(title: "授权结果", message: returnMsg, viewController: sender, okAction: { (alert) in
            if returnCode == "9000" {
                let r=result["result"] as! String
                self.loginSuccessClosure?(r)
                
            }else{
                self.loginFailClosure?()
            }
        })
    }
    //传入回调参数
    func showResult(result:NSDictionary){
        //        9000    订单支付成功
        //        8000    正在处理中
        //        4000    订单支付失败
        //        6001    用户中途取消
        //        6002    网络连接出错
        let returnCode:String = result["resultStatus"] as! String
        //        var returnMsg:String = ""
        //        switch  returnCode{
        //        case "6001":
        //            returnMsg = "用户中途取消"
        //            break
        //        case "6002":
        //            returnMsg = "网络连接出错"
        //            break
        //        case "8000":
        //            returnMsg = "正在处理中"
        //            break
        //        case "4000":
        //            returnMsg = "订单支付失败"
        //            break
        //        case "9000":
        //            returnMsg = "支付成功"
        //            break
        //        default:
        //            returnMsg = "订单支付失败"
        //            break
        //        }
        //        UIAlertController.showAlertYes(sender, title: "支付结果", message: returnMsg, okButtonTitle:"确定", okHandler: { (alert) in
        //            if returnCode == "9000" {
        //                self.paySuccessClosure?()
        //
        //            }else{
        //                self.payFailClosure?()
        //            }
        //        })
        if returnCode == "9000" {
            self.paySuccessClosure?(returnCode)
            
        }else{
            self.payFailClosure?(returnCode)
        }
    }
}
