//
//  BrilliantBookDetailsTableView.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/12/11.
//

import UIKit

//MARK: - 书单详情列表
class BrilliantBookDetailsTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UI
extension BrilliantBookDetailsTableView {
    private func createUI() {
        separatorStyle = .none
        rowHeight = 142
        contentInset = .zero
        bounces = false
        showsVerticalScrollIndicator = false
        register(BrilliantBookDetailsListCell.self, forCellReuseIdentifier: NSStringFromClass(BrilliantBookDetailsListCell.self))
        
    }
}
