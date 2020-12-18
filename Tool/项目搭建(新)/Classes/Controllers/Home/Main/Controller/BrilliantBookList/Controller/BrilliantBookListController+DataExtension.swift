//
//  BrilliantBookListController+DataExtension.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/30.
//

import UIKit

//MARK: - Data
extension BrilliantBookListController: BrilliantBookListPresenterDelegate {
    
    func receivedBrilliantBookListsData(_ listData: [BrilliantBookListData]) {
        self.listData = listData
    }
    
    func requestDidEnd() {
        
    }
    
    func listEndPage() {
        
    }
}
