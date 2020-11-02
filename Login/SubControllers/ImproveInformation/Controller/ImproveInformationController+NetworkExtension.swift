//
//  ImproveInformationController+NetworkExtension.swift
//  SXReaderS
//
//  Created by 发抖喵 on 2020/9/10.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import UIKit
import JGProgressHUD

//MARK: - Network
extension ImproveInformationController {
    
    /**
     上传用户学校信息
     */
    func upLoadUserImproveInformation(_ request: UpdateSchoolRequest) {
        HTTPProvider<UserApi<DBModel>>().request(.updateUserRegisterOrgInfo(request: request), responseHandler: {[weak self] response in
            FLog(title: "上传学校信息", message: response.description)
            if response.success{
                self?.uploadUserGenderInfo()
            } else{
                SXToast.showToast(message: response.message, aLocationStr: "bottom", aShowTime: 3.0)
            }
        })
    }
    
    /**
     上传用户性别信息
     */
    func uploadUserGenderInfo() {
        HTTPProvider<UserApi<DBModel>>().request(.updateUserGenderInfo(userGender, userId: request.userId ?? ""), responseHandler: {[weak self] response in
            FLog(title: "上传用户性别信息", message: response.debugDescription)
            if response.success{
                let vc = ReadingPreferenceController(userId: self?.request.userId ?? "")
                self?.navigationController?.delegate = nil
                self?.navigationController?.pushViewController(vc, animated: false)
            } else{
                SXToast.showToast(message: response.message, aLocationStr: "bottom", aShowTime: 3.0)
            }
        })
    }
    
}
