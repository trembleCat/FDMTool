//
//  WorkDetailsPresenter.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/24.
//

import UIKit

protocol WorkDetailsPresenterDelegate: BasePresenterDelegate {
    /// 输出作品详情数据
    func receivedGreatStudentDynamicData(_ data: WorkDetailsData?)
}

//MARK: - 优秀作品详情Presenter
class WorkDetailsPresenter: Presenter<WorkDetailsPresenterDelegate> {
    var detailsData: WorkDetailsData?
    var dynamicId: String?
    
    override func reloadData() {
        self.getGreatStudentDynamic()
    }
    
    /**
     获取作品数据
     */
    func getGreatStudentDynamic() {
        guard dynamicId != nil else {
            FLog(title: "优秀作品详情Presenter", message: "dynamicId 为 nil")
            return
        }
        
        // 通过MainNetwork获取数据
        self.delegate?.receivedGreatStudentDynamicData(detailsData)
    }
    
}
