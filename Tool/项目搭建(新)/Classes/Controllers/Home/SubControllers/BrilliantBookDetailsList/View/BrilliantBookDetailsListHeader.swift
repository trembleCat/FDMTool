//
//  BrilliantBookDetailsListHeader.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/30.
//

import UIKit

//MARK: - 书单详情header
class BrilliantBookDetailsListHeader: UIView {
    
    let imgView = UIImageView()
    let whiteView = UIView()
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - UI
extension BrilliantBookDetailsListHeader {
    func createUI() {
        self.addSubview(imgView)
        self.addSubview(whiteView)
        self.whiteView.addSubview(titleLabel)
        self.whiteView.addSubview(subTitleLabel)
        
        /* 图片 */
        imgView.backgroundColor = .gray
        imgView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(FPhoneIsScreen() ? 200 : 165)
        }
        
        /* 白色背景 */
        whiteView.backgroundColor = .white
        whiteView.layer.cornerRadius = 10
        whiteView.snp.makeConstraints { (make) in
            make.top.equalTo(imgView.snp.bottom).offset(-20)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        /* 标题 */
        titleLabel.numberOfLines = 0
        titleLabel.text = "西顿动物西顿动物西顿"
        titleLabel.setFontName("PingFangSC-Medium", fontSize: 18, fontColor: .UsedHex333333())
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(18)
            make.right.lessThanOrEqualToSuperview().offset(-18)
        }
        
        /* 介绍 */
        subTitleLabel.numberOfLines = 0
        subTitleLabel.text = "萨迪啊个IDgas有挂钩度噶事与输过刾打算 哦啊苏打欧萨迪啊个IDgas有挂钩度噶事与输过刾打算 哦啊苏打欧萨迪啊个IDgas有挂钩度噶事与输过刾打算 哦啊苏打欧萨迪啊个IDgas有挂钩度噶事与输过刾打算 哦啊苏打欧萨迪啊个IDgas有挂钩度噶事与输过刾打算 哦啊苏打欧萨迪啊个IDgas有挂钩度噶事与输过刾打算 哦啊苏打欧"
        subTitleLabel.setFontName("PingFangSC-Regular", fontSize: 12, fontColor: .UsedHex999999())
        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
            make.bottom.equalToSuperview().offset(-10)
        }
        
    }
}
