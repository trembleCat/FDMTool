//
//  BrilliantBookDetailsListCell.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/30.
//

import UIKit

//MARK: - 书单详情
class BrilliantBookDetailsListCell: UIBaseTableViewCell {
    
    let bookView = BookInfoView(isShowAbstract: true)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - UI
extension BrilliantBookDetailsListCell {
    func createUI() {
        self.contentView.addSubview(bookView)
        
        /* 书籍信息 */
        bookView.bookTitleLabel.text = "书名"
        bookView.bookSubTitleLabel.text = "啦啦啦"
        bookView.bookAbstractLabel.text = "阿萨德撒娇的奥四季度奥四季度iOS啊就哦吉萨几点偶按实际东家是激动啊囧"
        bookView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(14)
            make.bottom.equalToSuperview().offset(-14)
        }
    }
}
