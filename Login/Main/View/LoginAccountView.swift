//
//  LoginAccountView.swift
//  SXReaderS
//
//  Created by 发抖喵 on 2020/9/3.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import UIKit

class LoginAccountView: UIView {
    
    let background_ImgView = UIImageView()
    let account_View = FDMAccountField()
    let foot_ImgView = UIImageView()
    let hand_ImgView = UIImageView()
    
    let password_View = FDMAccountField()
    
    var accountField: UITextField?
    var passwordField: UITextField?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        accountField = account_View.textField
        passwordField = password_View.textField
        
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
extension LoginAccountView {
    private func createUI() {
        self.addSubview(background_ImgView)
        self.addSubview(account_View)
        self.addSubview(password_View)
        self.addSubview(foot_ImgView)
        self.addSubview(hand_ImgView)
        
        /* 小黄 */
        background_ImgView.image = UIImage(named: "Login_Xiaohuang")
        
        /* 账号输入框 */
        let accountPlaceholderAttrs = NSMutableAttributedString.init(string: "用户名")
        accountPlaceholderAttrs.addForegroundColor(.Hex("#cccccc"))
        accountField?.attributedPlaceholder = accountPlaceholderAttrs
        accountField?.font = UIFont(name: "PingFangSC-Regular", size: 16)
        accountField?.returnKeyType = .next
        accountField?.keyboardType = .asciiCapable
        
        account_View.backgroundColor = .Hex("#F7F7F7")
        account_View.textField.textColor = .Hex("#333333")
        account_View.layer.cornerRadius = 26
        account_View.titleImage = UIImage(named: "Login_AccountNormal")
        account_View.setLastBtnImage(UIImage(named: "Login_Delegate"), for: .normal)
        account_View.addLastBtnTarget(self, action: #selector(clearAccountText), for: .touchUpInside)
        
        /* 密码输入框 */
        let passwordPlaceholderAttrs = NSMutableAttributedString.init(string: "密码")
        passwordPlaceholderAttrs.addForegroundColor(.Hex("#cccccc"))
        passwordField?.attributedPlaceholder = passwordPlaceholderAttrs
        
        passwordField?.font = UIFont(name: "PingFangSC-Regular", size: 16)
        passwordField?.returnKeyType = .done
        passwordField?.isSecureTextEntry = true
        passwordField?.keyboardType = .asciiCapable
        passwordField?.textColor = .Hex("#333333")
        
        password_View.titleImage = UIImage(named: "Login_PasswordNormal")
        password_View.lastButton.isHidden = true
        password_View.backgroundColor = .Hex("#F7F7F7")
        password_View.layer.cornerRadius = 26
        
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
        
        /* 账号输入框 */
        account_View.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(35)
            make.right.equalToSuperview().offset(-35)
            make.height.equalTo(52)
            make.top.equalTo(background_ImgView.snp.top).offset(99)
        }
        
        /* 密码输入框 */
        password_View.snp.makeConstraints { (make) in
            make.left.height.right.equalTo(account_View)
            make.top.equalTo(account_View.snp.bottom).offset(14)
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
extension LoginAccountView {
    
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
        account_View.titleImgView.image = UIImage(named: name)
    }
    
    /**
    设置密码输入框TitleImage
    */
    func setPasswordTitleImage(name: String) {
        password_View.titleImgView.image = UIImage(named: name)
    }
}
