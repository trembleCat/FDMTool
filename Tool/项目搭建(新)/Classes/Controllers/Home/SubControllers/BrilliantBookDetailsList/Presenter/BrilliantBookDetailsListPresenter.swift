//
//  BrilliantBookDetailsListPresenter.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/12/1.
//

import UIKit

protocol BrilliantBookDetailsListPresenterDelegate: BasePresenterListDelegate {
    /// 收到精彩书单列表数据
    func receivedBrilliantBookDetailsListsData(_ data: [BrilliantBookDetailsListData])
    
    /// 收到精彩书单完整数据
    func receiveBrilliantBookDetailsData(_ data: brilliantBookListEventData?)
}

//MARK: - 书单详情列表Presenter
class BrilliantBookDetailsListPresenter: Presenter<BrilliantBookDetailsListPresenterDelegate> {
    var listData = [BrilliantBookDetailsListData]()
    var brilliantBookListEvent: brilliantBookListEventData?
    var dynamicId: String?
    
    /**
     刷新数据
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
     获取列表数据
     */
    override func requestBrilliantBookListsData(_ isAppendData: Bool) {
        
    }
}
