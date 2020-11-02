//
//  SchoolCell.swift
//  SXReaderS
//
//  Created by 刘涛 on 2020/2/21.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import UIKit

class SchoolCell: UBaseTableViewCell {
    
    let rightImageView = UIImageView.init(image: UIImage.init(named: "icon_selected"))
    
    public lazy var indexLabel:UILabel = {
        let tv = UILabel()
        tv.textColor = UIColor.textPrimaryDark
        tv.font = UIFont.boldSystemFont(ofSize: 16)
        tv.text = ""
        return tv;
    }()
    
    public lazy var textTipLabel:UILabel = {
        let tv = UILabel()
        tv.textColor = UIColor.textAccent
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.text = "东城区"
        return tv;
    }()
    
    
    override func configUI() {
        contentView.backgroundColor = .backgroundPrimary
        contentView.addSubview(rightImageView)
        rightImageView.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-30)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(15)
            $0.width.equalTo(18)
        }
        
        
        contentView.addSubview(textTipLabel)
        textTipLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    var model: SchoolEntity? {
        didSet {
            guard let model = model else { return }
            indexLabel.isHidden = true
            rightImageView.isHidden = true
            indexLabel.textColor = UIColor.textPrimaryDark
            textTipLabel.textColor = UIColor.textAccent
            textTipLabel.text = model.name
        }
    }
    
    var selectedItem: Bool? {
        didSet {
            rightImageView.isHidden = true
            guard let selectedItem = selectedItem else { return }
            if selectedItem {
                rightImageView.isHidden = false
                indexLabel.textColor = UIColor.theme
                textTipLabel.textColor = UIColor.theme
                textTipLabel.font = UIFont.boldSystemFont(ofSize: 17)
            }else{
                rightImageView.isHidden = true
                indexLabel.textColor = UIColor.textPrimaryDark
                textTipLabel.textColor = UIColor.textAccent
                textTipLabel.font = UIFont.systemFont(ofSize: 16)
            }
        }
    }
    
}
