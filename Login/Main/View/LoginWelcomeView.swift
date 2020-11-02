//
//  LoginWelcomeView.swift
//  SXReaderS
//
//  Created by 发抖喵 on 2020/9/3.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import UIKit

class LoginWelcomeView: UIView {
    
    let hi_ImgView = UIImageView()
    let helloLabel = UILabel()
    let welcomeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UI
extension LoginWelcomeView {
    func createUI() {
        self.addSubview(hi_ImgView)
        self.addSubview(helloLabel)
        self.addSubview(welcomeLabel)
        
        /* Hi图片 */
        hi_ImgView.image = UIImage(named: "Login_Hi")
        
        /* 你好 */
        helloLabel.text = "你好"
        helloLabel.font = UIFont(name: "PingFangSC-Medium", size: 30)
        helloLabel.textColor = .textBlackPrimary
        
        /* 欢迎语 */
        welcomeLabel.text = "欢迎来到书香阅读！"
        welcomeLabel.font = UIFont(name: "PingFangSC-Light", size: 22)
        welcomeLabel.textColor = .textAccent
    }
    
    /**
     布局UI
     */
    func layoutUI() {
        /* Hi图片 */
        hi_ImgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(self.snp.top).offset(36)
            make.size.equalTo(CGSize(width: 34, height: 33))
        }
        
        /* 你好 */
        helloLabel.snp.makeConstraints { (make) in
            make.left.equalTo(hi_ImgView.snp.right).offset(8)
            make.height.equalTo(42)
            make.centerY.equalTo(hi_ImgView)
        }
        
        /* 欢迎语 */
        welcomeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(hi_ImgView.snp.left)
            make.top.equalTo(hi_ImgView.snp.bottom).offset(15)
            make.height.equalTo(30)
        }
    }
}
