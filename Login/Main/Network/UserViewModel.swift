//
//  UserViewModel.swift
//  Example
//
//  Created by 刘涛 on 2018/7/20.
//  Copyright © 2018年 FolioReader. All rights reserved.
//

import UIKit

class UserViewModel{
    func smsLogin(mobile: String, smsCode: String, complete: @escaping (_ result:UserInfoResponse? ,_ error:String?)->Void) {
        let provider = HTTPProvider<UserApi<UserInfoResponse>>()
        provider.request(.smsLogin(mobile: mobile, smsCode: smsCode), responseHandler: { response in
            if response.success {
                if response.code == 200 {
                    complete(response.value!,response.message)
                } else {
                    complete(nil,response.message)
                }
            }else if response.code == 401{
                complete(nil,"账号或密码错误，请重新输入")
            }else {
                complete(nil,response.message)
            }
        })
    }
    
    /**
    登录
    */
    func login(pwd: String, account: String, complete: @escaping (_ result:UserInfoResponse? ,_ error:String?)->Void) {
        let provider = HTTPProvider<UserApi<UserInfoResponse>>()
        provider.request(.login(username: account, password: pwd), responseHandler: { response in
            if response.success {
                if response.code == 200 {
                    complete(response.value!,response.message)
                } else {
                    complete(nil,response.message)
                }
            }else if response.code == 401{
                complete(nil,"账号或密码错误，请重新输入")
            }else {
                complete(nil,response.message)
            }
        })
    }
    
    /**
    注册
    */
    func register(phoneNum: String ,pwd: String,smsCode: String , complete: @escaping (_ result:Int? ,_ error:String?)->Void){
        let provider = HTTPProvider<UserApi<LoginResponse>>()
        provider.request(.register(phoneNum: phoneNum, pwd: pwd, smsCode: smsCode), responseHandler: { response in
            if response.success {
                complete(response.code,response.message)
            }else {
                complete(0,response.message)
            }
        })
    }
    
    /**
    获取验证码
    */
    func getSMSCode(phoneNum: String ,verType: String , complete: @escaping (_ result:Int? ,_ error:String?)->Void){
        let provider = HTTPProvider<UserApi<DBModel>>()
        provider.request(.getSMSCode(phoneNum: phoneNum,verType:verType), responseHandler: { response in
            if response.success {
                complete(response.code,response.message)
            }else {
                complete(0,response.message)
            }
        })
    }
    
    /**
    检查验证码
    */
    func checkSMSCode(phoneNum: String ,smsCode: String , verType: String, complete: @escaping (_ result:Int? ,_ error:String?)->Void){
        HTTPProvider<UserApi<DBModel>>().request(.checkSMSCode(phoneNum: phoneNum,smsCode:smsCode,verType:verType), responseHandler: { response in
            if response.success {
                complete(response.code,response.message)
            }else {
                complete(0,response.message)
            }
        })
    }
    

    /**
    修改密码
    */
    func updatePwd(phoneNum: String ,pwd: String,smsCode: String , complete: @escaping (_ result:Int? ,_ error:String?)->Void){
        let provider = HTTPProvider<UserApi<DBModel>>()
        provider.request(.updatePwd(phoneNum: phoneNum,pwd: pwd,smsCode:smsCode), responseHandler: { response in
            if response.success {
                complete(response.code,response.message)
            }else {
                complete(0,response.message)
            }
        })
    }
    
    
    /**
    修改密码
    */
    func updatePwd2(pwd: UpdatePasswordRequest, complete: @escaping (_ result:Int? ,_ error:String?)->Void){
        let provider = HTTPProvider<UserApi<DBModel>>()
        provider.request(.updatePwd2(password:pwd), responseHandler: { response in
            if response.success {
                complete(response.code,response.message)
            }else {
                complete(0,response.message)
            }
        })
    }
}



