//
//  ShareController+ActionExtension.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/12/11.
//

import UIKit

//MARK: - Action
extension ShareController {
    /**
     获取分享图片
     */
    func getShareImage() {
        tagImageView.image = tagImage
        shareImage = contentView.toImage()
        tagImageView.image = nil
    }
    
    /**
     设置标签
     */
    func setTagImage(_ image: UIImage?) {
        tagImage = image
    }
}

//MARK: - shareTypeViewDelegate
extension ShareController: shareTypeViewDelegate {
    func clickWechatBtn() {
        if shareImage == nil { getShareImage() }
        guard let image = shareImage else {
            FLog(title: "获取分享图片失败", message: "shareImage is nil")
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    func clickWechatMomentsBtn() {
        if shareImage == nil { getShareImage() }
        guard let image = shareImage else {
            FLog(title: "获取分享图片失败", message: "shareImage is nil")
            return
        }
    }
    
    func clickQQBtn() {
        if shareImage == nil { getShareImage() }
        guard let image = shareImage else {
            FLog(title: "获取分享图片失败", message: "shareImage is nil")
            return
        }
        
    }
    
    func clickQQZone() {
        if shareImage == nil { getShareImage() }
        guard let image = shareImage else {
            FLog(title: "获取分享图片失败", message: "shareImage is nil")
            return
        }
        
    }
    
    func clickCloseBtn() {
        self.dismiss(animated: true, completion: nil)
    }
}
