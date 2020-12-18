//
//  BookListPresenter.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/30.
//

import UIKit

protocol BrilliantBookListPresenterDelegate: BasePresenterListDelegate {
    /// 收到精彩书单列表数据
    func receivedBrilliantBookListsData(_ data: [BrilliantBookListData])
}

//MARK: - 书单Presenter
class BrilliantBookListPresenter: Presenter<BrilliantBookListPresenterDelegate> {
    
    var listData = [BrilliantBookListData]()
    
    /**
     刷新精彩书单列表
     */
    override func reloadData() {
        indexPage = 1
        self.requestBrilliantBookListsData(false)
    }
    
    /**
     下一页数据
     */
    override func nextPageData() {
        indexPage += 1
        self.requestBrilliantBookListsData(true)
    }
    
    /**
     网络请求
     */
    override func requestBrilliantBookListsData(_ isAppendData: Bool) {
        
        
    }
    
}
