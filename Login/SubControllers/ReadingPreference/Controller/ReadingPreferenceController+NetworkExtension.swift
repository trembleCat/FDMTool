//
//  ReadingPreferenceController+NetworkExtension.swift
//  SXReaderS
//
//  Created by 发抖喵 on 2020/9/10.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import UIKit


//MARK: - Network
extension ReadingPreferenceController {
    /**
     加载偏好数据
     */
    func loadPreferenceInfo() {
        HTTPProvider<UserApi<UserPerferenceModel>>().request(.getPreferenceInfo(indexPage: indexPage, pageSize: pageSize)) {[weak self] (resp) in
            FLog(title: "偏好数据", message: resp.debugDescription)
            self?.userPerferenceAry.removeAll()
            
            var dataAry = [UserPerferenceEntity]()
            if let respValue = resp.value {
                for item in respValue.list {
                    dataAry.append(item)
                }
            }
            
            if self?.userPerferenceAry == nil {
                self?.userPerferenceAry = dataAry
                self?.preferenceView.setPrefercenceData(self?.userPerferenceAry ?? [])
            }else {
                self?.userPerferenceAry += dataAry
                self?.preferenceView.appendPrefercenceData(dataAry)
            }
            
        }
    }
    
    /**
     保存偏好数据
     */
    func savePreferenceInfo() {
        
        var classEvent = [UploadPerferenceModel]()
        
        for item in selectedPerferenceAry {
            classEvent.append(UploadPerferenceModel(id: item.id, name: item.name))
        }

        HTTPProvider<UserApi<DBModel>>().request(.saveUserPreferenceInfo(classEvent: classEvent, userId: userId)) {[weak self] (resp) in
            if resp.success {
                GlobalUIManager.loadHomeVC()
            }else {
                SXToast.showIndicatorToastAction(message: "添加阅读偏好失败")
            }
        }
    }
}
