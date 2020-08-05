//
//  FDMDownLoadTool.swift
//  Apple
//
//  Created by 发抖喵 on 2020/3/7.
//  Copyright © 2020 yunzainfo. All rights reserved.
//

import UIKit
import Alamofire

class FDMDownLoadTool: NSObject {
    
    static let shared = FDMDownLoadTool()
    
    let AF = Alamofire.SessionManager.default
}

//MARK: Basic
extension FDMDownLoadTool {
    /// 基础创建下载请求
    func createDownLoadRequest(url:String,name:String,progressCallBack:@escaping (Double) -> (),dataCallBack:@escaping (Data) -> (),errCallBack:@escaping (Error?) -> ()) {
        
        let destination: DownloadRequest.DownloadFileDestination = {_,_ in
            let documnetsURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            let fileURL = documnetsURL.appendingPathComponent(name)
            
            return (fileURL,[.removePreviousFile,.createIntermediateDirectories])
        }

        AF.download(url, to: destination).downloadProgress { (progress) in
            progressCallBack(progress.fractionCompleted)
        }.responseData { (response) in
            if let data = response.value {
                dataCallBack(data)
            }else{
                errCallBack(response.error)
            }
        }
    }
}
