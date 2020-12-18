//
//  WorkDetailsController+DataExtension.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/24.
//

import UIKit

//MARK: - WorkDetailsPresenterDelegate
extension WorkDetailsController: WorkDetailsPresenterDelegate {
    
    func receivedGreatStudentDynamicData(_ data: WorkDetailsData?) {
        self.detailsData = data
    }
    
    func requestDidEnd() {
        
    }
}
