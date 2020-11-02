//
//  MessageLoginPhoneView.swift
//  SXReaderS
//
//  Created by 发抖喵 on 2020/10/21.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import UIKit

class MessageLoginPhoneView: UIView {
    
    let background_ImgView = UIImageView()
    let foot_ImgView = UIImageView()
    let hand_ImgView = UIImageView()
    
    let phoneField = FDMAccountField()
    let codeField = FDMAccountField()
    
    var accountField: UITextField?
    var passwordField: UITextField?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        accountField = phoneField.textField
        passwordField = codeField.textField
        
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
extension MessageLoginPhoneView {
    private func createUI() {
        self.addSubview(background_ImgView)
        self.addSubview(phoneField)
        self.addSubview(codeField)
        self.addSubview(foot_ImgView)
        self.addSubview(hand_ImgView)
        
        /* 小黄 */
        background_ImgView.image = UIImage(named: "Login_Xiaohuang")
        
        /* 手机号输入框 */
        let phoneFieldPlaceholderAttrs = NSMutableAttributedString.init(string: "请输入手机号")
        phoneFieldPlaceholderAttrs.addForegroundColor(.Hex("#cccccc"))
        
        phoneField.textField.attributedPlaceholder = phoneFieldPlaceholderAttrs
        phoneField.textField.keyboardType = .numberPad
        phoneField.backgroundColor = .Hex("#F7F7F7")
        phoneField.textField.textColor = .Hex("#333333")
        phoneField.layer.cornerRadius = 26
        phoneField.titleImage = UIImage(named: "Register_PhoneNoraml")
        phoneField.setLastBtnImage(UIImage(named: "Login_Delegate"), for: .normal)
        phoneField.addLastBtnTarget(self, action: #selector(clearAccountText), for: .touchUpInside)
        
        
        /* 验证码输入框 */
        let codeFieldPlaceholderAttrs = NSMutableAttributedString.init(string: "请输入验证码")
        codeFieldPlaceholderAttrs.addForegroundColor(.Hex("#cccccc"))
        
        codeField.textField.attributedPlaceholder = codeFieldPlaceholderAttrs
        codeField.isUserInteractionEnabled = true
        codeField.textField.keyboardType = .numberPad
        codeField.backgroundColor = .Hex("#F7F7F7")
        codeField.textField.textColor = .Hex("#333333")
        codeField.layer.cornerRadius = 26
        codeField.titleImage = UIImage(named: "Register_CodeNormal")
        codeField.lastButton.titleLabel?.font = UIFont(name: "PingFangSC-Semibold", size: 16)
        codeField.setLastBtnTitle("获取验证码", for: .normal)
        codeField.setLastBtnTitleColor(.Hex("#FFA91D"), for: .normal)
        
        /* 小黄的脚 */
        foot_ImgView.image = UIImage(named: "Login_XiaohuangFoot")
        
        /* 小黄的手 */
        hand_ImgView.image = UIImage(named: "Login_XiaohuangHand")
    }
    
    /**
     布局
     */
    private func layoutUI() {
        /* 小黄 */
        background_ImgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 179, height: 165))
            make.right.equalToSuperview().offset(5)
        }
        
        /* 手机号输入框 */
        phoneField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(35)
            make.right.equalToSuperview().offset(-35)
            make.height.equalTo(52)
            make.top.equalTo(background_ImgView.snp.top).offset(99)
        }
        
        /* 验证码输入框 */
        codeField.snp.makeConstraints { (make) in
            make.left.height.right.equalTo(phoneField)
            make.top.equalTo(phoneField.snp.bottom).offset(14)
        }
        
        /* 小黄的脚 */
        foot_ImgView.snp.makeConstraints { (make) in
            make.right.equalTo(background_ImgView.snp.right).offset(-48)
            make.bottom.equalTo(background_ImgView.snp.bottom).offset(-7)
            make.size.equalTo(CGSize(width: 74, height: 22))
        }
        
        /* 小黄的手 */
        hand_ImgView.snp.makeConstraints { (make) in
            make.right.equalTo(background_ImgView.snp.right).offset(-13.7)
            make.top.equalTo(background_ImgView.snp.top).offset(80.1)
            make.size.equalTo(CGSize(width: 29, height: 42))
        }
    }
}

//MARK: - Action
extension MessageLoginPhoneView {
    
    /**
     清除账号文本
     */
    @objc private func clearAccountText() {
        accountField?.text = ""
    }
    
    /**
     设置账号输入框TitleImage
     */
    func setAccountTitleImage(name: String) {
        phoneField.titleImgView.image = UIImage(named: name)
    }
    
    /**
    设置密码输入框TitleImage
    */
    func setPasswordTitleImage(name: String) {
        codeField.titleImgView.image = UIImage(named: name)
    }
}

