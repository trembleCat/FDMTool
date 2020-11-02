//
//  GenderView.swift
//  SXReaderS
//
//  Created by 发抖喵 on 2020/9/7.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import UIKit

class GenderView: UIView {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - UI + Action
extension GenderView {
    private func createUI() {
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
            make.width.height.equalTo(70)
        }
        
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "PingFangSC-Regular", size: 13)
        titleLabel.textColor = .Hex("#999999")
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
    /**
     设置图片与文字
     */
    func setImage(_ image: UIImage?, title: String) {
        self.imageView.image = image
        self.titleLabel.text = title
    }
    
    /**
     添加点击事件
     */
    func addTarget(_ target: Any, action: Selector) {
        self.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(tapGesture)
    }
    
    /**
     设置选中状态
     */
    func setSelected(_ isSelected: Bool) {
        if isSelected { // 选中
            titleLabel.textColor = .Hex("#333333")
            titleLabel.font = UIFont(name: "PingFangSC-Medium", size: 13)
        }else {
            titleLabel.textColor = .Hex("#999999")
            titleLabel.font = UIFont(name: "PingFangSC-Regular", size: 13)
        }
    }
}
