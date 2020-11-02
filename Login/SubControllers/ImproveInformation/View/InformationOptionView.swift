//
//  InformationOptionView.swift
//  SXReaderS
//
//  Created by 发抖喵 on 2020/9/7.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import UIKit

class InformationOptionView: UIView {
    
    let titleLabel = UILabel()
    let rightImgView = UIImageView()
    
    var title: String {
        get {
            return self.titleLabel.text ?? ""
        }
        
        set {
            self.setTitle(newValue)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 26
        self.backgroundColor = .Hex("#F9F9F9")
        
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - UI + Action
extension InformationOptionView {
    private func createUI() {
        self.addSubview(titleLabel)
        self.addSubview(rightImgView)
        
        titleLabel.font = UIFont(name: "PingFangSC-Regular", size: 16)
        titleLabel.textColor = .Hex("#666666")
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(rightImgView.snp.left).offset(-20)
        }
        
        rightImgView.image = UIImage(named: "Information_Right")
        rightImgView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 10, height: 13))
        }
    }
    
    /**
     设置文字
     */
    func setTitle(_ title: String) {
        self.titleLabel.text = title
    }
    
    /**
     设置选择文本字体
     */
    func setSelectedTitle(_ title: String) {
        self.titleLabel.text = title
        titleLabel.font = UIFont(name: "PingFangSC-Medium", size: 16)
        titleLabel.textColor = .Hex("#333333")
        
    }
}
