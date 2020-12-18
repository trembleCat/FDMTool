//
//  BrilliantBookDetailsListController+DataExtension.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/12/2.
//

import UIKit

//MARK: - Data
extension BrilliantBookDetailsListController: BrilliantBookDetailsListPresenterDelegate {
    func receivedBrilliantBookDetailsListsData(_ data: [BrilliantBookDetailsListData]) {
        self.listData = data
    }
    
    func receiveBrilliantBookDetailsData(_ data: brilliantBookListEventData?) {
        
    }
    
    func listEndPage() {
        
    }
    
    func requestDidEnd() {
        
    }
}
