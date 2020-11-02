//
//  ResetPwdView2.swift
//  SXReaderS
//
//  Created by 刘涛 on 2020/1/15.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import Foundation
import UIKit
import Material

extension ResetPwdController2 : UITextFieldDelegate{
    
    func prepareUI() {
        //设置导航栏背景透明
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.view.backgroundColor = UIColor.white
        
        prepareBanner()
        preparePwdField()
        prepareAckPwdField()
        prepareTips()
        prepareNextButton()
    }
    
    fileprivate func prepareBanner(){
        let titleBanner = UILabel()
        titleBanner.text = "升级密码"
        titleBanner.fontSize = 26
//        titleBanner.textColor=UIColor.init(hexColor: "#333333")
        titleBanner.textColor=UIColor.textAccent

        self.view.addSubview(titleBanner)
        
        titleBanner.snp.makeConstraints {
            $0.top.equalTo(kStatusbarHeight).offset(50)
            $0.left.equalTo(20)
            $0.width.equalToSuperview()
        }
        
        accountLabel = UILabel()
        accountLabel.text = ""
        titleBanner.textColor=UIColor.black
        self.view.addSubview(accountLabel)
        accountLabel.snp.makeConstraints {
            $0.left.equalTo(titleBanner.snp.left)
            $0.height.equalTo(22)
            $0.top.equalTo(titleBanner.snp.bottom).offset(40)
        }
    }
    
    fileprivate func preparePwdField() {
        pwdField = TextField()
        pwdField.placeholder = "请设置新密码"
        pwdField.delegate = self
        pwdField.placeholderAnimation = .hidden
        pwdField.returnKeyType = .next
        pwdField.isVisibilityIconButtonEnabled = true
        pwdField.textInsets = EdgeInsets.init(top: 5, left: 30, bottom: 0, right: 0)
        pwdField.dividerActiveHeight = 1
        pwdField.keyboardType = .asciiCapable
        pwdField.dividerActiveColor = Color.grey.lighten2
        pwdField.visibilityIconButton?.tintColor = Color.grey.base.withAlphaComponent(pwdField.isSecureTextEntry ? 0.4 : 0.8)
        
        let leftView = UIImageView(image: UIImage(named: "icon_usr_pwd"))
        self.view.addSubview(leftView)
        leftView.snp.makeConstraints {
            $0.left.equalTo(45)
            $0.height.equalTo(22)
            $0.width.equalTo(20)
            $0.top.equalTo(accountLabel.snp.bottom).offset(kScreenHeight*0.06)
        }
        
        self.view.addSubview(pwdField)
        pwdField.snp.makeConstraints {
            $0.left.equalTo(45)
            $0.height.equalTo(45)
            $0.width.equalTo(kScreenWidth - 90)
            $0.centerY.equalTo(leftView)
        }
    }
    
    fileprivate func prepareAckPwdField() {
        ackPwdField = TextField()
        ackPwdField.placeholder = "确认新密码"
        ackPwdField.delegate = self
        ackPwdField.placeholderAnimation = .hidden
        ackPwdField.returnKeyType = .done
        ackPwdField.isVisibilityIconButtonEnabled = true
        ackPwdField.textInsets = EdgeInsets.init(top: 5, left: 30, bottom: 0, right: 0)
        ackPwdField.keyboardType = .asciiCapable
        ackPwdField.dividerActiveHeight = 1
        ackPwdField.dividerActiveColor = Color.grey.lighten2
        ackPwdField.visibilityIconButton?.tintColor = Color.grey.base.withAlphaComponent(ackPwdField.isSecureTextEntry ? 0.4 : 0.8)
        
        let leftView = UIImageView(image: UIImage(named: "icon_usr_pwd_ack"))
        self.view.addSubview(leftView)
        leftView.snp.makeConstraints {
            $0.left.equalTo(45)
            $0.height.equalTo(22)
            $0.width.equalTo(20)
            $0.top.equalTo(pwdField.snp.bottom).offset(25)
        }
        
        self.view.addSubview(ackPwdField)
        ackPwdField.snp.makeConstraints {
            $0.left.equalTo(45)
            $0.height.equalTo(45)
            $0.width.equalTo(kScreenWidth - 90)
            $0.centerY.equalTo(leftView)
        }
    }
    
    fileprivate func prepareTips(){
        let nameString = "密码需要包含字母与数字，且密码长度需大于等于8位。"
        let nameStr:NSMutableAttributedString = NSMutableAttributedString(string: nameString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        nameStr.addAttribute(kCTParagraphStyleAttributeName as NSAttributedString.Key, value: paragraphStyle, range: NSMakeRange(0, nameString.count))
        
        let tipsLabel = UILabel()
        tipsLabel.attributedText = nameStr
        tipsLabel.textColor = Color.grey.base
        tipsLabel.fontSize = 14
        tipsLabel.numberOfLines = 2
        
        let leftView = UIImageView.init(image: UIImage(named: "warning_icon"))
        self.view.addSubview(leftView)
        leftView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(45)
            make.height.width.equalTo(18)
            make.top.equalTo(ackPwdField.snp.bottom).offset(14)
        }
        
        self.view.addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(leftView.snp.right).offset(5)
            make.height.equalTo(45)
            make.width.equalTo(kScreenWidth-125)
            make.top.equalTo(ackPwdField.snp.bottom).offset(10)
        }
    }
    
    fileprivate func prepareNextButton() {
        nextBtn = RaisedButton(title: "完成", titleColor: .black)
        nextBtn.pulseColor = .white
        nextBtn.layer.cornerRadius = kScreenHeight*0.03
        nextBtn.backgroundColor = UIColor.theme
        
        nextBtn.layer.shadowColor = UIColor.lightGray.cgColor
        nextBtn.layer.shadowOpacity = 0.4
        nextBtn.layer.shadowRadius = 2
        nextBtn.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        
        self.view.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.height.equalTo(kScreenHeight*0.06)
            make.width.equalTo(kScreenWidth*0.37)
            make.top.equalTo(ackPwdField.snp.bottom).offset(kScreenHeight*0.15)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField.returnKeyType == UIReturnKeyType.done)
        {
            textField.resignFirstResponder()//键盘收起
            return false
        }
        if(textField == pwdField)
        {
            let _ = ackPwdField.becomeFirstResponder()
        }
        if(textField == ackPwdField)
        {
            textField.resignFirstResponder()//键盘收起
            return false
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
        if length > 50 {
            return false
        }
        
        let len = string.lengthOfBytes(using: String.Encoding.utf8)
        
        for loopIndex in 0..<len {
            let char = (string as NSString).character(at: loopIndex)
            //只能输入 a~z A~Z 0~9
            if char < 48 {return false}
            if char < 65 && char > 57 {return false }
            if char > 90 && char < 97 {return false }
            if char > 122 {return false }
        }
        
        return true
    }
}





