//
//  ForgetPwdView.swift
//  SXReader
//
//  Created by 刘涛 on 2018/7/25.
//  Copyright © 2018年 FolioReader. All rights reserved.
//

import Foundation
import UIKit
import Material

extension ForgetPwdController : UITextFieldDelegate{
    
    func prepareUI() {
        //设置导航栏背景透明
        self.view.backgroundColor = .backgroundPrimary

        
        prepareBanner()
        prepareAccountField()
        prepareVerificationCode()
        prepareLoginButton()
    }
    
    fileprivate func prepareBanner(){
        leftArrowView = IconButton(image: UIImage(named: "icon_back_arrow_black"));
        self.view.addSubview(leftArrowView)
        leftArrowView.snp.makeConstraints {
            $0.top.equalTo(kStatusbarHeight)
            $0.left.equalTo(10)
            $0.width.equalTo(40)
            $0.height.equalTo(kScreenHeight*0.066)
        }
        
        let titleBanner = UILabel()
        titleBanner.text = "找回密码"
        titleBanner.fontSize = 26
//        titleBanner.textColor=UIColor.init(hexColor: "#333333")
        titleBanner.textColor=UIColor.textAccent
        self.view.addSubview(titleBanner)
        
        titleBanner.snp.makeConstraints {
            $0.top.equalTo(leftArrowView.snp.bottom).offset(30)
            $0.left.equalTo(20)
            $0.width.equalToSuperview()
        }
    }
    
    fileprivate func prepareAccountField() {
        accountField = ErrorTextField()
//        accountField.placeholder = "请输入手机号"
        let attrString = NSAttributedString(string: "请输入手机号", attributes: [NSAttributedString.Key.foregroundColor:UIColor.textPrimaryDark])
               accountField.attributedPlaceholder = attrString
        accountField.isClearIconButtonEnabled = true
        accountField.delegate = self
        accountField.placeholderAnimation = .hidden
        accountField.keyboardType = .numberPad
        accountField.returnKeyType = .next
        accountField.textColor = UIColor.textAccent
        accountField.textInsets = EdgeInsets.init(top: 5, left: 30, bottom: 0, right: 0)
        accountField.dividerActiveHeight = 1
        accountField.dividerActiveColor = Color.grey.lighten2
        
        let leftView = UIImageView(image: UIImage(named: "icon_usr_phone"))
        self.view.addSubview(leftView)
        leftView.snp.makeConstraints {
            $0.left.equalTo(45)
            $0.height.equalTo(22)
            $0.width.equalTo(20)
            $0.top.equalTo(leftArrowView.snp.bottom).offset(140)
        }
        
        self.view.addSubview(accountField)
        accountField.snp.makeConstraints {
            $0.left.equalTo(45)
            $0.height.equalTo(45)
            $0.width.equalTo(kScreenWidth - 90)
            $0.centerY.equalTo(leftView)
        }
    }
    
    
    fileprivate func prepareVerificationCode() {
        codeField = TextField()
        let attrString = NSAttributedString(string: "请输入验证码", attributes: [NSAttributedString.Key.foregroundColor:UIColor.textPrimaryDark])
        codeField.attributedPlaceholder = attrString
        codeField.placeholderAnimation = .hidden
        codeField.textInsets = EdgeInsets.init(top: 5, left: 30, bottom: 0, right: 0)
        codeField.returnKeyType = .done
        codeField.delegate = self
        codeField.keyboardType = .numberPad
        codeField.textColor = UIColor.textAccent
        codeField.dividerActiveHeight = 1
        codeField.dividerActiveColor = Color.grey.lighten2
        // Setting the visibilityIconButton color.
        
        let leftView = UIImageView(image: UIImage(named: "icon_usr_code"))
        self.view.addSubview(leftView)
        leftView.snp.makeConstraints {
            $0.left.equalTo(45)
            $0.height.equalTo(22)
            $0.width.equalTo(20)
            $0.top.equalTo(accountField.snp.bottom).offset(kScreenHeight*0.06)
        }
        
        self.view.addSubview(codeField)
        codeField.snp.makeConstraints {
            $0.left.equalTo(45)
            $0.height.equalTo(45)
            $0.width.equalTo(kScreenWidth - 90)
            $0.centerY.equalTo(leftView)
        }
        
        verificationCodeBtn = SendCodeBtn(title: "获取验证码")
        verificationCodeBtn.initNotify()
        verificationCodeBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        verificationCodeBtn.titleColor = UIColor.theme
        self.view.addSubview(verificationCodeBtn)
        verificationCodeBtn.snp.makeConstraints {
            $0.height.equalTo(codeField.snp.height)
            $0.width.equalTo(100)
            $0.centerY.equalTo(codeField)
            $0.right.equalTo(codeField.snp.right).offset(10)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(hexColor: "#E3E3E3")
        self.view.addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.width.equalTo(1)
            $0.centerY.equalTo(codeField)
            $0.right.equalTo(verificationCodeBtn.snp.left)
        }
    }
    
    fileprivate func prepareLoginButton() {
        loginBtn = RaisedButton(title: "下一步", titleColor: .black)
        loginBtn.pulseColor = .white
        loginBtn.layer.cornerRadius = kScreenHeight*0.03
        loginBtn.backgroundColor = UIColor.theme
        

        self.view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(kScreenHeight*0.06)
            $0.width.equalTo(kScreenWidth*0.37)
            $0.top.equalTo(codeField.snp.bottom).offset(kScreenHeight*0.1)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField.returnKeyType == UIReturnKeyType.done)
        {
            textField.resignFirstResponder()//键盘收起
            return false
        }
        if(textField == accountField)
        {
           let _ = codeField.becomeFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField.textInputMode?.primaryLanguage == "emoji"
            || textField.textInputMode?.primaryLanguage == nil
            || string.containsEmoji()){
            return false
        }
        
        let length = textField.text!.count + string.count - range.length
        
        if textField == accountField{//账号11位
            if length > 11 {
                return false
            }
        }else if textField == codeField{//验证码4位
            if length > 4{
                return false
            }
        }
        
        return true
    }
}
