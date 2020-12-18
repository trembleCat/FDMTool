//
//  EveryDayReadPresenter.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/27.
//

import UIKit

protocol EveryDayReadPresenterDelegate: BasePresenterDelegate {
    /// 接收每日一读数据
    func receivedDailyReadingData(_ data: EveryDayReadData?)
}

//MARK: - 每日一读Presenter
class EveryDayReadPresenter: Presenter<EveryDayReadPresenterDelegate> {
    
    var readData: EveryDayReadData?
    
    override func reloadData() {
        self.getDailyReading()
    }
    
    /**
     获取每日一读数据
     */
    func getDailyReading() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.delegate?.receivedDailyReadingData(nil)
        }
    }
}
