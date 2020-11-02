//
//  BaseParam.swift
//
//  Created by 发抖喵 on 2020/4/21.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit
import Alamofire

protocol BaseParam {
    
    /// title
    func title() -> String?
    
    /// encoding
    func encoding() -> ParameterEncoding
    
    /// method
    func method() -> HTTPMethod
    
    /// url
    func url() -> String
    
    /// paramsJson
    func paramsJson() -> Parameters?
    
    /// headerJson
    func headerJson() -> HTTPHeaders?
}
