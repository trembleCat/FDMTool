//
//  FDMTencentManager.swift
//  SXReader
//
//  Created by 发抖喵 on 2020/12/18.
//  Copyright © 2020 FolioReader. All rights reserved.
//  #import <TencentOpenAPI/TencentOAuth.h>
//  #import <TencentOpenAPI/QQApiInterfaceObject.h>
//  #import <TencentOpenAPI/QQApiInterface.h>

import UIKit

//MARK: - QQ互联
class FDMTencentManager: NSObject {
    static let manager = FDMTencentManager()
    var appId = ""
    var universalLink = ""
    var tencentOAuth: TencentOAuth?
    
    /**
     注册QQ互联
     
     - parameter universalLink: universalLink
     */
    func registerTencentManager(_ appId: String, universalLink: String) {
        self.appId = appId
        self.universalLink = universalLink
        
        tencentOAuth = TencentOAuth.init(appId: appId, andUniversalLink: universalLink, andDelegate: self)
    }
    
    /**
     注册QQ互联
     */
    func registerTencentManager(_ appId: String) {
        self.appId = appId
        
        tencentOAuth = TencentOAuth.init(appId: appId, andDelegate: self)
    }
    
    /**
     分享图片
    
     - parameter image: 图片 (小于5M)
     - parameter previewImageData: 预览的图片 (小于1M)
     */
    func shareImage(_ image: UIImage?, previewImageData: UIImage? = nil) {
        guard image != nil , let imageData =  image!.jpegData(compressionQuality: 1)  else {
            FLog(title: "QQ分享图片", message: "image is nil Or imageData is mil")
            return
        }
        
        let imgObject = QQApiImageObject.init(data: imageData, previewImageData: previewImageData?.jpegData(compressionQuality: 0.5), title: "来自书香阅读的分享", description: "分享")
        
        QQApiInterface.send(SendMessageToQQReq.init(content: imgObject))
    }
}

//MARK: - TencentSessionDelegate
extension FDMTencentManager: TencentSessionDelegate {
    func tencentDidLogin() {
        
    }
    
    func tencentDidNotLogin(_ cancelled: Bool) {
        
    }
    
    func tencentDidNotNetWork() {
        
    }
    
}
