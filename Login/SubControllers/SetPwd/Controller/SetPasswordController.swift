//
//  SetPasswordController.swift
//  SXReader
//
//  Created by 刘涛 on 2018/7/25.
//  Copyright © 2018年 FolioReader. All rights reserved.
//

import UIKit
import Material

class SetPasswordController: UBaseViewController ,KeyboardHandle{
    
    let topBgImgView = UIImageView()
    let leftArrowView = IconButton(image: UIImage(named: "Login_Back"))
    let whiteBgView = UIView()
    let bottomBgImgView = UIImageView()
    let titleBanner = UILabel()
    
    let passwordField = FDMAccountField()
    var passwordFieldFrame = CGRect.zero
    
    let confirmField = FDMAccountField()
    var confirmFieldFrame = CGRect.zero
    
    let registerBtn = UIButton(type: .system)
    var registerFrame = CGRect.zero
    
    let tipsImgView = UIImageView()
    let tipsLabel = UILabel()
    
    var viewModel = UserViewModel()
    var account:String!
    var smsCode:String!
    
    override func viewWillDisappear(_ animated: Bool) {
        passwordField.textField.resignFirstResponder()
        confirmField.textField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        showNavigation = false
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.backgroundPrimary
        //ThemeManager.setStatusBarBackgroundColor(color: UIColor.init(hexColor: "#BCBCBC"))
        
        createUI()
        createAction()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        passwordField.textField.resignFirstResponder()
        confirmField.textField.resignFirstResponder()
    }
}

//MARK: - UI
extension SetPasswordController {
    
    func createUI() {
        self.view.addSubview(topBgImgView)
        self.view.addSubview(leftArrowView)
        self.view.addSubview(whiteBgView)
        self.whiteBgView.addSubview(bottomBgImgView)
        self.whiteBgView.addSubview(titleBanner)
        self.whiteBgView.addSubview(passwordField)
        self.whiteBgView.addSubview(confirmField)
        self.whiteBgView.addSubview(tipsImgView)
        self.whiteBgView.addSubview(tipsLabel)
        self.whiteBgView.addSubview(registerBtn)
        
        /* 顶部背景图 */
        topBgImgView.image = UIImage(named: "Register_TopBackground")
        topBgImgView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(119)
        }
        
        /* 返回按钮 */
        leftArrowView.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(18)
            make.bottom.equalTo(topBgImgView.snp.bottom).offset(-47)
            make.size.equalTo(CGSize(width: 25, height: 30))
        }
        
        /* 白色背景 */
        whiteBgView.layer.cornerRadius = 20
        whiteBgView.backgroundColor = self.view.backgroundColor
        whiteBgView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(LoginHeaderHeight)
        }
        
        /* 底部背景图 */
        bottomBgImgView.image = UIImage(named: "Register_Background")
        bottomBgImgView.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 117.5, height: 117.5))
        }
        
        /* 标题 */
        titleBanner.text = "设置密码"
        titleBanner.font = UIFont(name: "PingFangSC-Medium", size: 22)
        titleBanner.textColor = .textBlackPrimary
        titleBanner.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(40)
            make.top.equalTo(whiteBgView.snp.top).offset(40)
            make.height.equalTo(30)
        }
        
        /* 设置密码输入框 */
        let passwordFieldPlaceholderAttrs = NSMutableAttributedString.init(string: "请设置密码")
        passwordFieldPlaceholderAttrs.addForegroundColor(.Hex("#cccccc"))
        passwordField.textField.attributedPlaceholder = passwordFieldPlaceholderAttrs
        
        passwordField.textField.returnKeyType = .next
        passwordField.textField.keyboardType = .asciiCapable
        passwordField.textField.isSecureTextEntry = true
        passwordField.textField.delegate = self
        passwordField.backgroundColor = .Hex("#F7F7F7")
        passwordField.textField.textColor = .Hex("#333333")
        passwordField.layer.cornerRadius = 26
        passwordField.titleImage = UIImage(named: "Login_PasswordNormal")
        passwordField.frame = passwordFieldFrame
        
        /* 重复密码输入框 */
        let confirmFieldPlaceholderAttrs = NSMutableAttributedString.init(string: "请再次确认密码")
        confirmFieldPlaceholderAttrs.addForegroundColor(.Hex("#cccccc"))
        confirmField.textField.attributedPlaceholder = confirmFieldPlaceholderAttrs
        
        confirmField.textField.returnKeyType = .done
        confirmField.textField.keyboardType = .asciiCapable
        confirmField.textField.isSecureTextEntry = true
        confirmField.textField.delegate = self
        confirmField.backgroundColor = .Hex("#F7F7F7")
        confirmField.textField.textColor = .Hex("#333333")
        confirmField.layer.cornerRadius = 26
        confirmField.titleImage = UIImage(named: "SetPwd_ConfirmNormal")
        confirmField.lastButton.titleLabel?.font = UIFont(name: "PingFangSC-Semibold", size: 16)
        confirmField.frame = confirmFieldFrame
        
        /* 提示图标 */
        tipsImgView.image = UIImage(named: "SetPwd_Tips")
        tipsImgView.snp.makeConstraints { (make) in
            make.left.equalTo(confirmField.snp.left)
            make.top.equalTo(confirmField.snp.bottom).offset(15)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        
        /* 提示文字 */
        tipsLabel.text = "密码需包含字母与数字，且密码长度大于等于8位"
        tipsLabel.font = UIFont(name: "PingFangSC-Regular", size: 13)
        tipsLabel.textColor = .Hex("#FFB7A2")
        tipsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(tipsImgView.snp.right).offset(5)
            make.height.equalTo(22)
            make.centerY.equalTo(tipsImgView)
        }
        
        /* 下一步 */
        registerBtn.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 18)
        registerBtn.setTitleColor(.black, for: .normal)
        registerBtn.setTitle("下一步", for: .normal)
        registerBtn.layer.cornerRadius = 22
        registerBtn.backgroundColor = UIColor.theme
        registerBtn.snp.makeConstraints { (make) in
            make.top.equalTo(confirmField.snp.bottom).offset(52)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(140)
        }
    }
    
}





