//
//  BrilliantBookListCell.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/30.
//

import UIKit

//MARK: - 书单列表
class BrilliantBookListCell: UIBaseTableViewCell {
    
    var data: BrilliantBookListData?
    
    let imgView = UIImageView()
    let titleLabel = UILabel()
    let subLabel = UILabel()
    let dividingLine = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - UI
extension BrilliantBookListCell {
    func createUI() {
        self.contentView.addSubview(imgView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(subLabel)
        self.contentView.addSubview(dividingLine)
        
        /* 图片 */
        imgView.backgroundColor = .UsedHex999999()  // 去掉背景颜色
        imgView.layer.cornerRadius = 10
        imgView.layer.masksToBounds = true
        imgView.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(155)
        })
        
        /* 标题 */
        titleLabel.numberOfLines = 2
        titleLabel.setFontName("PingFangSC-Regular", fontSize: 15, fontColor: .UsedHex333333())
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imgView.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        
        /* 副标题 */
        subLabel.numberOfLines = 0
        subLabel.setFontName("PingFangSC-Regular", fontSize: 12, fontColor: .UsedHex999999())
        subLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        
        /* 分割线 */
        dividingLine.backgroundColor = .Hex("#E8E8E8")
        dividingLine.snp.makeConstraints { (make) in
            make.top.equalTo(subLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
}

//MARK: - Action
extension BrilliantBookListCell {
    func setModel(_ data: BrilliantBookListData) {
        self.data = data
        
        self.titleLabel.text = data.title
        self.subLabel.text = data.description
        self.imgView.setImage_simulation()
    }
}
