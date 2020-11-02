//
//  SetPasswordControllerView.swift
//  SXReader
//
//  Created by 刘涛 on 2018/7/25.
//  Copyright © 2018年 FolioReader. All rights reserved.
//

import Foundation
import UIKit
import Material

//MARK: - Action
extension SetPasswordController {
    func createAction() {
        registerBtn.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        leftArrowView.addTarget(self, action: #selector(exitAction), for: .touchUpInside)
        
        // 调用自定义的通知名称
        NotificationCenter.post(name: .loginSuccess, object: nil, userInfo: nil)
        
        // 调用系统的通知名称
        NotificationCenter.post(name: UIResponder.keyboardDidHideNotification, object: nil, userInfo: nil)
    }
    
    @objc func exitAction(_ sender: Any){
        self.navigationController?.delegate = nil
        self.navigationController?.popViewController(animated: false)
    }
    
    /// 注册
    @objc func registerAction(_ sender: Any) {
        self.passwordField.textField.resignFirstResponder()
        self.confirmField.textField.resignFirstResponder()
        
        guard let pwd = self.passwordField.text else {
            return
        }

        guard let pwd2 = self.confirmField.text else {
            return
        }

        if pwd != pwd2 {
            SXToast.showToast(message: "请确认两次的密码一致！", aLocationStr: "bottom", aShowTime: 2.0)
            confirmField.textField.shake(direction: .horizontal, times: 5, interval: 0.1, delta: 1.8)
            return
        }

        if !self.verifyPasswordRules(pasword: pwd){
            SXToast.showToast(message: "按照密码规则设置密码！", aLocationStr: "bottom", aShowTime: 2.0)
            passwordField.textField.shake(direction: .horizontal, times: 5, interval: 0.1, delta: 1.8)
            return
        }

        self.registerBtn.isEnabled = false
        self.viewModel.register(phoneNum: account, pwd: pwd, smsCode: smsCode, complete: { code,error  in
            FLog(title: "设置密码", message: code)
            
            if code == 200  {
                self.viewModel.login(pwd: pwd,account: self.account,complete: { user,error  in
                    SXToast.hiddenIndicatorToastAction()
                    if let user = user  {
                        currentUser = user
                        currentUser.userId = currentUser.event.userId
                        schoolId = currentUser.event.schoolId
                        userId = currentUser.event.userId
                        token_value = user.event.token

                        let dm = DataBaseManager.default
                        dm.deleteAllObjects(type: UserInfoResponse.self)
                        dm.insertOrUpdate(objects: [user])

                        currentUser = user

                        //UserDefaults.standard.set(token_value, forKey: TOKEN_NAME)
                        let request = UpdateSchoolRequest(userId:userId!)
                        let vc = ImproveInformationController(request: request)
                        self.navigationController?.delegate = vc
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        self.registerBtn.isEnabled = true
                    }

                })

            }else if code == 418 {
                self.navigationController?.popViewController(animated: true)
            } else{
                self.registerBtn.isEnabled = true
                SXToast.showToast(message: error, aLocationStr: "bottom", aShowTime: 2.0)
            }
        })
    }
    
    func verifyPasswordRules(pasword : String) -> Bool {
        let pwd =  "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,50}$"
        let regextestpwd = NSPredicate(format: "SELF MATCHES %@",pwd)
        if (regextestpwd.evaluate(with: pasword) == true) {
            return true
        }else{
            return false
        }
    }
}

//MARK: - UITextFieldDelegate
extension SetPasswordController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == passwordField.textField {
            
            passwordField.titleImage = UIImage(named: "Login_PasswordSelected")
        }else if textField == confirmField.textField {
            confirmField.titleImage = UIImage(named: "SetPwd_ConfirmSelected")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        passwordField.titleImage = UIImage(named: "Login_PasswordNormal")
        confirmField.titleImage = UIImage(named: "SetPwd_ConfirmNormal")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField.returnKeyType == UIReturnKeyType.done)
        {
            textField.resignFirstResponder()//键盘收起
            return false
        } else if textField.returnKeyType == .next {
            passwordField.textField.becomeFirstResponder()
            
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
