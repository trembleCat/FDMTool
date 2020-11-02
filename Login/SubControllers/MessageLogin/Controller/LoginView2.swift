//
//  LoginController.swift
//  SXReader
//
//  Created by 刘涛 on 2018/7/23.
//  Copyright © 2018年 FolioReader. All rights reserved.
//

import Foundation
import UIKit
import Material

extension LoginViewController2 : UITextFieldDelegate{
    
    func attachedView() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.backgroundColor = .backgroundPrimary

        prepareBanner()
        prepareAccountField()
        preparePwdField()
        prepareLoginButton()
        prepareBottomView()
        prepareEvaluationLoginBtn()
    }
    
    fileprivate func prepareBanner(){
        bannerView = UIImageView(image: UIImage(named: "login_banner"));
        bannerView.contentMode = .scaleAspectFill
        self.view.addSubview(bannerView)
        
        bannerView.snp.makeConstraints {
            $0.top.equalTo(view)
            $0.width.equalToSuperview()
        }
    }
    
    fileprivate func prepareAccountField() {
        accountField = ErrorTextField()
        let attrString = NSAttributedString(string: "请输入手机号", attributes: [NSAttributedString.Key.foregroundColor:UIColor.textPrimary])
        accountField.attributedPlaceholder = attrString
        accountField.textColor = UIColor.textAccent
        accountField.isClearIconButtonEnabled = true
        accountField.delegate = self
        accountField.placeholderAnimation = .hidden
        accountField.returnKeyType = .next
        accountField.keyboardType = .asciiCapable
        accountField.textInsets = EdgeInsets.init(top: 0, left: 30, bottom: 0, right: 0)
        accountField.dividerActiveHeight = 1
        accountField.dividerNormalColor = UIColor.divider
        accountField.dividerActiveColor = UIColor.divider
        accountField.clearIconButton?.tintColor = Color.grey.base.withAlphaComponent(0.4)
        accountField.text = ""
        
        
        let leftView = UIImageView(image: UIImage(named: "icon_usr_phone"))
        self.view.addSubview(leftView)
        leftView.snp.makeConstraints {
            $0.left.equalTo(45)
            $0.height.equalTo(22)
            $0.width.equalTo(20)
            $0.top.equalTo(bannerView.snp.bottom).offset(kScreenHeight*0.08)
        }
        
        self.view.addSubview(accountField)
        accountField.snp.makeConstraints {
            $0.left.equalTo(45)
            $0.height.equalTo(45)
            $0.width.equalTo(kScreenWidth - 90)
            $0.centerY.equalTo(leftView)
        }
    }
    
    
    fileprivate func preparePwdField() {
        codeField = TextField()
        let attrString = NSAttributedString(string: "请输入验证码", attributes: [NSAttributedString.Key.foregroundColor:UIColor.textPrimary])
        codeField.attributedPlaceholder = attrString
        codeField.textColor = UIColor.textAccent
        codeField.placeholderAnimation = .hidden
        codeField.textInsets = EdgeInsets.init(top: 0, left: 30, bottom: 0, right: 0)
        codeField.returnKeyType = .done
        codeField.delegate = self
        codeField.keyboardType = .numberPad
        codeField.dividerActiveHeight = 1
        codeField.dividerNormalColor = UIColor.divider
        codeField.dividerActiveColor = UIColor.divider
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
            $0.width.equalTo(110)
            $0.centerY.equalTo(codeField)
            $0.right.equalTo(codeField.snp.right).offset(10)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.divider
        self.view.addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.width.equalTo(1)
            $0.centerY.equalTo(codeField)
            $0.right.equalTo(verificationCodeBtn.snp.left)
        }
    }
    
    
    
    fileprivate func prepareLoginButton() {
        loginBtn = RaisedButton(title: "登录", titleColor: .black)
        loginBtn.pulseColor = .white
        loginBtn.layer.cornerRadius = kScreenHeight*0.03
        loginBtn.backgroundColor = UIColor.theme

        
        loginBtn.layer.shadowColor = UIColor.gray.cgColor
        loginBtn.layer.shadowOpacity = 0.4
        loginBtn.layer.shadowRadius = 2
        loginBtn.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        
        self.view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints {
            $0.left.equalTo(45)
            $0.height.equalTo(kScreenHeight*0.06)
            $0.width.equalTo(kScreenWidth - 90)
            $0.top.equalTo(codeField.snp.bottom).offset(kScreenHeight*0.1)
        }
        
        let label = UILabel()
        label.isUserInteractionEnabled = true
        let signTapGesture = UITapGestureRecognizer(target: self, action: #selector(gotoCodeSign))
        label.addGestureRecognizer(signTapGesture)
        label.text = "密码登录"
        label.backgroundColor = UIColor.clear
        label.fontSize = 14
        label.textAlignment = NSTextAlignment.center
        self.view.addSubview(label)
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loginBtn.snp.bottom).offset(10)
            $0.height.equalTo(40)
            $0.width.equalTo(120)
        }
        
    }
    
    fileprivate func prepareEvaluationLoginBtn(){
           let entryEvaluationImg = UIImage(named: "evaluation_icon")
           let entryEvaluationImgView = UIImageView(image: entryEvaluationImg)
           entryEvaluationImgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.evaluationIdCodeLogin)))
           self.view.addSubview(entryEvaluationImgView)
            entryEvaluationImgView.isUserInteractionEnabled = false
           entryEvaluationImgView.snp.makeConstraints{
               $0.right.equalToSuperview().offset(-15)
               $0.bottom.equalTo(self.bottomLayoutGuide.snp.top).offset(-65)
           }
           
          HTTPProvider<EvaluationCopyApi<VerifyEvaluationResponse>>().request(.verifyEvaluationByDeviceNum, responseHandler: { response in
              if response.success && response.code == 200 {
                   if response.value?.quickEntryDisplay ?? false {
                       entryEvaluationImgView.isUserInteractionEnabled = true
                   }else{
                       entryEvaluationImgView.isUserInteractionEnabled = false
               }
              }
           })
       }
    
    
    fileprivate func prepareBottomView(){
            
            let protocolBtn = FlatButton()
            protocolBtn.fontSize = 14
            //protocolBtn.titleColor = UIColor.init(hexColor: "#666666")
            protocolBtn.addTarget(self, action: #selector(protocalAction), for: .touchUpInside)
            self.view.addSubview(protocolBtn)
            protocolBtn.snp.makeConstraints {
                $0.height.equalTo(25)
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-10)
            }
            
            let strg = "我已阅读并同意《书香阅读服务条款》"
            let ranStr = "《书香阅读服务条款》"
            let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:strg)
            let str = NSString(string: strg)
            let theRange = str.range(of: ranStr)
            attrstring.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor.theme, range: theRange)
            protocolBtn.setAttributedTitle(attrstring , for: .normal)
            
            let bottomView = UIView()
            bottomView.isUserInteractionEnabled = true
            let signTapGesture = UITapGestureRecognizer(target: self, action: #selector(gotoRegister))
            bottomView.addGestureRecognizer(signTapGesture)
            self.view.addSubview(bottomView)
            bottomView.snp.makeConstraints {
                $0.bottom.equalTo(protocolBtn.snp.top).offset(-5)
                $0.height.equalTo(60)
                $0.width.equalTo(100)
                $0.centerX.equalToSuperview()
            }
            
            let leftImageView = UIImageView.init(image: UIImage.init(named: "icon_register"))
            bottomView.addSubview(leftImageView)
            leftImageView.snp.makeConstraints {
                $0.left.equalToSuperview()
                $0.centerY.equalToSuperview()
                $0.height.width.equalTo(18)
            }
            
            let label = UILabel()
            label.text = "我是新用户"
            label.backgroundColor = UIColor.clear
            label.fontSize = 14
    //        label.textColor = UIColor.black
            label.textAlignment = NSTextAlignment.center
            bottomView.addSubview(label)
            label.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.height.equalTo(40)
                $0.left.equalTo(leftImageView.snp.right).offset(5)
            }
        }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField.returnKeyType == UIReturnKeyType.done){
            textField.resignFirstResponder()//键盘收起
            return false
        }else if(textField == accountField){
            let _ = codeField.becomeFirstResponder()
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
    
    @objc func protocalAction(_ sender: Any){
        let documentFileURL = Bundle.main.url(forResource: "userProtocol", withExtension: "pdf")!
        let document = PDFDocument(url: documentFileURL)!
        let readerController = PDFViewController.createNew(with: document,title: "书香阅读服务条款",backButton:backBarBtnItem)
        readerController.backgroundColor = UIColor.white
//        self.navigationController?.barStyle(.theme)
        self.navigationController?.navigationBar.setBackgroundImage(UIColor.mainPrimary.image(), for: .default)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(readerController, animated: true)
    }
    
    @objc func evaluationIdCodeLogin(){
       let loginLog = LoginFunLogEntity(type: "3425", function_id: "", data: "")
        logan(LoganType.init(2),loginLog.toJSONString()!)
        self.navigationController?.pushViewController(JoinByIdentificationCodeController(), animated: true)
    }
}

