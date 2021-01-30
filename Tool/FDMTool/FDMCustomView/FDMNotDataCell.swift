//
//  FDMNotDataCell.swift
//  SXReader
//
//  Created by 发抖喵 on 2021/1/25.
//  Copyright © 2021 FolioReader. All rights reserved.
//

import UIKit

//MARK: - 没有数据 UITableViewCell
class FDMNotDataCell: UBaseTableViewCell {
    
    let backDropView = UIView()
    let imgView = UIImageView()
    let titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UI
extension FDMNotDataCell {
    func createUI() {
        self.contentView.addSubview(backDropView)
        self.backDropView.addSubview(imgView)
        self.backDropView.addSubview(titleLabel)
        
        /* 背景 */
        backDropView.backgroundColor = .backgroundPrimary
        backDropView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.bottom.equalToSuperview()
        }
        
        /* 图片 */
        imgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(35)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(150)
        }
        
        /* 标题 */
        titleLabel.text = "没有数据哦"
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = .Hex("#999999")
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imgView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-60)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

//MARK: - Action
extension FDMNotDataCell {
    /**
     设置图片与提示语
     */
    func setImage(_ image: UIImage?, title: String) {
        imgView.image = image
        titleLabel.text = title
    }
}
