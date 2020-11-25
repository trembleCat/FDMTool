//
//  NetworkManager.swift
//  guoyuan-civil-ios
//
//  Created by 发抖喵 on 2020/6/19.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit
import Alamofire

class NetworkManager: NSObject {
    static let shared = NetworkManager()
    let AF = Alamofire.Session.default
    
}

//MARK: Basics
extension NetworkManager {
    
    /**
     基本网络请求 需要判断 401 Token失效 Data取出手动UTF8解码
     
     @param requestParam: 请求数据
            success: 请求成功回调
            failure: 请求失败回调
     */
    func besiceRequest(_ host: String, _ requestParam: BaseParam, success: @escaping ((String) -> ()), failure: @escaping((String,Int) -> ()) ) {
        let convertible = endUrl(host, requestParam.url())
        let method = requestParam.method()
        let parameters = requestParam.paramsJson()
        let encoding = requestParam.encoding()
        let headers = requestParam.headerJson()
        
        AF.request(convertible, method: method, parameters: parameters, encoding: encoding, headers: headers).responseString { (response) in
            switch response.result {
            case .success(let resp):
                if response.response?.statusCode != 200 {
                    failure(resp,response.response?.statusCode ?? -1234567)
                }else{
                    success(resp)
                }
                break
            case .failure(let err):
                failure("网络请求失败\(err)",response.response?.statusCode ?? -1234567)
                break
            }
        }
    }
    
    /// 拼接URL
    func endUrl(_ host: String, _ url: String) -> String {
        let realmUrl = host
        var paramUrl = url
        
        if paramUrl.contains("http") || paramUrl.contains("https") {
            return paramUrl
        } else {
            if realmUrl.last == "/" && paramUrl.first == "/" {
                return realmUrl + String(paramUrl.removeFirst())
            }else{
                return realmUrl + paramUrl
            }
        }
    }
}
