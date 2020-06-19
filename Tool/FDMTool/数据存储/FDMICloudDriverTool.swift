//
//  FDMICloudDriverTool.swift
//  教务系统
//
//  Created by 发抖喵 on 2020/5/6.
//  Copyright © 2020 发抖喵. All rights reserved.
//
// 获取ICloud Driver 文件

import UIKit

@objc protocol FDMICloudDriverToolDelegate: NSObjectProtocol {
    func iCloudDriverFileUrl(_ url: URL?)
}

/* 1.获取share 2.设置代理 3.present弹出documentPicker */
class FDMICloudDriverTool: NSObject, UIDocumentPickerDelegate {
    static let shared = FDMICloudDriverTool()
    
    var documentPicker: UIDocumentPickerViewController
    var delegate: FDMICloudDriverToolDelegate? {
        didSet {
            documentPicker.delegate = self
        }
    }
    
    override init() {
        let documentTypes = ["public.content", "public.text", "public.source-code", "public.image", "public.audiovisual-content", "com.adobe.pdf", "com.apple.keynote.key", "com.microsoft.word.doc", "com.microsoft.excel.xls", "com.microsoft.powerpoint.ppt"]
        
        documentPicker = UIDocumentPickerViewController(documentTypes: documentTypes, in: UIDocumentPickerMode.open)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard urls.count > 0 && ((delegate?.responds(to: #selector(delegate?.iCloudDriverFileUrl(_:)))) != nil) else { return }
        
        let pathUrl = urls.first!
        
        // 授权
        let fileAuthorized = pathUrl.startAccessingSecurityScopedResource()
        
        if fileAuthorized {
            let fileCoordinator = NSFileCoordinator()
            let error = NSErrorPointer(nilLiteral: ())
            
            /* 读取文件 */
            fileCoordinator.coordinate(readingItemAt: pathUrl, options: .withoutChanges, error: error) { (url) in
                delegate?.iCloudDriverFileUrl(url)
            }
        }else {
            delegate?.iCloudDriverFileUrl(nil)
        }
        
        // 关闭授权
        pathUrl.stopAccessingSecurityScopedResource()
    }
}
