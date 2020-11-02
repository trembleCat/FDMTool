//
//  SelectedMySchoolCell.swift
//  SXReaderS
//
//  Created by 发抖喵 on 2020/9/9.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import UIKit

class SelectedMySchoolCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let dividingView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}


//MARK: - UI + Action
extension SelectedMySchoolCell {
    private func createUI() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(dividingView)
        
        /* 标题 */
        titleLabel.font = UIFont(name: "PingFangSC-Medium", size: 15)
        titleLabel.textColor = .Hex("#333333")
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(21)
            make.width.equalTo(0)
        }
        
        /* 分割线 */
        dividingView.backgroundColor = .Hex("#E8E8E8")
        dividingView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.bottom.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    /**
     设置标题
     */
    func setTitle(_ title: String, animation: Bool) {
        self.titleLabel.text = title
        
        if animation {
            titleLabel.snp.updateConstraints { (make) in
                make.width.equalTo(0)
            }
            
            self.contentView.setNeedsLayout()
            self.contentView.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.45) { [weak self] in
                self?.titleLabel.snp.updateConstraints { (make) in
                    make.width.equalTo(FScreenW - 40)
                }
                
                self?.contentView.layoutIfNeeded()
            }
        }else {
            self.titleLabel.snp.updateConstraints { (make) in
                make.width.equalTo(FScreenW - 40)
            }
        }
    }
}
