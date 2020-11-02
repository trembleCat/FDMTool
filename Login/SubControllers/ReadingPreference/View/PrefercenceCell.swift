//
//  PrefercenceCell.swift
//  SXReaderS
//
//  Created by 发抖喵 on 2020/9/11.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import UIKit

class PrefercenceCell: UICollectionViewCell {
    let titleLabel = UILabel()
    let imageView = UIImageView()
    
    var currentSelected = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .Hex("#F6F6F6")
        self.contentView.layer.cornerRadius = 20
        
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - UI + Action
extension PrefercenceCell {
    func createUI() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(imageView)
        
        /* 标题 */
        titleLabel.font = UIFont(name: "PingFangSC-Regular", size: 14)
        titleLabel.textColor = .Hex("#666666")
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
        }
        
        /* 图片 */
        imageView.snp.makeConstraints { (make) in
            make.right.equalTo(titleLabel.snp.left).offset(-2)
            make.centerY.equalToSuperview().offset(-2)
            make.width.equalTo(30)
            make.height.equalTo(25)
        }
    }
    
    /**
     设置选中状态
     */
    func setSelected(_ isSelected: Bool) {
        if isSelected { // 选中
            
            currentSelected = true
            self.titleLabel.textColor = .white
            self.contentView.backgroundColor = .Hex("#FF8C7D")
            
            imageView.image = UIImage(named: "Preference_selected_7")
            titleLabel.snp.updateConstraints { (make) in
                make.centerX.equalToSuperview().offset(10)
            }
        }else {
            
            currentSelected = false
            self.titleLabel.textColor = .Hex("#666666")
            self.contentView.backgroundColor = .Hex("#F6F6F6")
            
            imageView.image = nil
            titleLabel.snp.updateConstraints { (make) in
                make.centerX.equalToSuperview()
            }
        }
        
        self.contentView.layoutIfNeeded()
    }
    
    /**
     设置禁止点击
     */
    func setProhibitClick() {
        titleLabel.textColor = .Hex("#CCCCCC")
    }
}
