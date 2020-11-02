//
//  RegisterControllerView.swift
//  SXReader
//
//  Created by 刘涛 on 2018/7/24.
//  Copyright © 2018年 FolioReader. All rights reserved.
//

import Foundation
import UIKit
import Material

//MARK: - Action
extension RegisterController {
    func createAction() {
        /* 转场动画 */
        self.transitionAnimation.transitionType = .Push
        
        /* 手势监听 */
        registerBtn.addTarget(self, action: #selector(self.nextAction), for: .touchUpInside)
        leftArrowView.addTarget(self, action: #selector(self.exitAction), for: .touchUpInside)
        codeField.addLastBtnTarget(self, action: #selector(self.showCodeAction), for: .touchUpInside)
        
        /* 调用系统的通知名称 */
        NotificationCenter.post(name: UIResponder.keyboardDidHideNotification, object: nil, userInfo: nil)
    }
    
    @objc func exitAction(){
        self.navigationController?.delegate = self
        self.navigationController?.popViewController(animated: true)
    }
    
    /**
     点击获取验证码
     */
    @objc func showCodeAction(){
        phoneField.textField.resignFirstResponder()
        codeField.textField.resignFirstResponder()
        
        guard let account = self.phoneField.text else {
            return
        }
        
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@","^1\\d{10}$")
        if (!regextestmobile.evaluate(with: account)) {
            SXToast.showToast(message: "请输入合法的手机号", aLocationStr: "bottom", aShowTime: 2.0)
            phoneField.shake(direction: .horizontal, times: 5, interval: 0.1, delta: 1.8)
            return
        }
        
        if self.codeTimer.timeCount == 0 {
            let verifyView = MockVerifyView()
            verifyView.delegate = self;
            verifyView.show()
        }
    }
    
    /// 下一步
    @objc func nextAction() {
        phoneField.textField.resignFirstResponder()
        codeField.textField.resignFirstResponder()
        
        guard let smsCode = self.codeField.text, let account = self.phoneField.text else {
            SXToast.showToast(message: "请输入手机号与验证码", aLocationStr: "bottom", aShowTime: 2.0)
            return
        }

        let regextestmobile = NSPredicate(format: "SELF MATCHES %@","^1\\d{10}$")
        if (!regextestmobile.evaluate(with: account)) {
            SXToast.showToast(message: "请输入合法的手机号", aLocationStr: "bottom", aShowTime: 2.0)
            phoneField.shake(direction: .horizontal, times: 5, interval: 0.1, delta: 1.8)
            return
        }

        if smsCode.isEmpty || smsCode.count != 4 {
            SXToast.showToast(message: "请输入正确的验证码", aLocationStr: "bottom", aShowTime: 2.0)
            codeField.shake(direction: .horizontal, times: 5, interval: 0.1, delta: 1.8)
            return
        }

        self.registerBtn.isEnabled = false
        self.viewModel.checkSMSCode(phoneNum: account, smsCode: smsCode, verType: "userRegister" ,complete: { code,error  in
            self.registerBtn.isEnabled = true
            if code == 200  {
                self.stopCounting()
                let vc = SetPasswordController()
                self.navigationController?.delegate = nil
                vc.account = account
                vc.smsCode = smsCode
                vc.passwordFieldFrame = self.phoneField.frame
                vc.confirmFieldFrame = self.codeField.frame
                UserDefaults.standard.set(account, forKey: "UserNameKey")
                self.navigationController?.pushViewController(vc, animated: false)
            } else{
                SXToast.showToast(message: error, aLocationStr: "bottom", aShowTime: 3.0)
            }
        })
    }

    /**
     滑动验证成功
     */
    func mockVerifyViewVerifySuccess(_ useTime: Int) {
        let loginLog = LoginFunLogEntity(type: "1041", function_id: "", data: "\(useTime)")
        logan(LoganType.init(2),loginLog.toJSONString()!)
        
        let loginLog1 = LoginFunLogEntity(type: "3426", function_id: "", data: "\(useTime)")
        logan(LoganType.init(2),loginLog1.toJSONString()!)
        
        self.beginCounting(120)
        
        guard let account = self.phoneField.text else {
            return
        }
        
        self.viewModel.getSMSCode(phoneNum: account , verType: "userRegister",complete: { code , error  in
            if code == 200  {

            } else if code == 417{
                self.stopCounting()
                SXToast.showToast(message: "手机号已注册", aLocationStr: "bottom", aShowTime: 3.0)
            } else {
                self.stopCounting()
                SXToast.showToast(message: error, aLocationStr: "bottom", aShowTime: 3.0)
            }
        })
    }
    
    /**
     开始计时
     */
    func beginCounting(_ time: Int) {
        codeTimer.timeCount = time
        codeTimer.createTimer(endOfTime: {[weak self] (time) in
            
            FLog(title: "结束", message: "倒计时为0")
            self?.codeField.lastButton.isUserInteractionEnabled = true
            self?.codeField.setLastBtnTitle("重新获取", for: .normal)
            self?.codeField.setLastBtnTitleColor(.Hex("#FFA91D"), for: .normal)
        }) {[weak self] (time) in

            FLog(title: "结束", message: time)
            self?.codeField.lastButton.isUserInteractionEnabled = false
            self?.codeField.setLastBtnTitle("\(time)s", for: .normal)
            self?.codeField.setLastBtnTitleColor(.Hex("#FFA91D"), for: .normal)
        }
        
        codeTimer.resume()
    }
    
    /**
     结束计时
     */
    func stopCounting() {
        codeTimer.cancel()
        
        self.codeTimer.timeCount = 0
        codeField.lastButton.isUserInteractionEnabled = true
        codeField.setLastBtnTitle("获取验证码", for: .normal)
        codeField.setLastBtnTitleColor(.Hex("#FFA91D"), for: .normal)
    }
}


//MARK: - UITextFieldDelegate
extension RegisterController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == phoneField.textField {
            
            phoneField.titleImage = UIImage(named: "Register_PhoneSelected")
        }else if textField == codeField.textField {
            codeField.titleImage = UIImage(named: "Register_CodeSelected")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        phoneField.titleImage = UIImage(named: "Register_PhoneNoraml")
        codeField.titleImage = UIImage(named: "Register_CodeNormal")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField.textInputMode?.primaryLanguage == "emoji"
            || textField.textInputMode?.primaryLanguage == nil
            || string.containsEmoji()){
            return false
        }
        
        let length = textField.text!.count + string.count - range.length
        
        if textField == phoneField.textField{//账号11位
            if length > 11 {
                return false
            }
        }else if textField == codeField.textField{//验证码4位
            if length > 4{
                return false
            }
        }
        
        return true
    }
}
