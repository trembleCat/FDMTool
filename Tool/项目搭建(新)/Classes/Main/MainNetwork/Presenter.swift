//
//  Presenter.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/27.
//

import UIKit

// received

//MARK: - 基本Presenter数据代理
protocol BasePresenterDelegate: NSObjectProtocol {
    /// 请求已经完成
    func requestDidEnd()
}

//MARK: - 基本Presenter列表数据代理
protocol BasePresenterListDelegate: BasePresenterDelegate {
    /// 列表已经为最后一页
    func listEndPage()
}

//MARK: - Presenter
class Presenter<T>:  MainNetwork  {
    private weak var target: NSObjectProtocol?
    var delegate: T? { target as? T }
    
    /// 分页
    lazy var indexPage: Int = { 1 }()
    
    /// 分页数量
    lazy var pageSize: Int = { 10 }()

    /**
     绑定 delegate
     */
    func bindPresenter(delegate: T?) {
        self.target = delegate as? NSObjectProtocol
    }
    
    /**
     列表重写：刷新数据（重新获取数据）
     */
    func reloadData() {
        
    }
    
    /**
     列表重写：下一页
     */
    func nextPageData() {
        
    }
    
    /**
     列表重写：请求基本列表数据
     */
    func requestBrilliantBookListsData(_ isAppendData: Bool) {
        
        
    }
}


