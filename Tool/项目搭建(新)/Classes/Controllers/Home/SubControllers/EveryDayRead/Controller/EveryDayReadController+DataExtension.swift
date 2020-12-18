//
//  EveryDayReadController+DataExtension.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/27.
//

import UIKit

extension EveryDayReadController: EveryDayReadPresenterDelegate {
    
    func receivedDailyReadingData(_ data: EveryDayReadData?) {
        self.readData = data
        
    }
    
    func requestDidEnd() {
        
    }
}
