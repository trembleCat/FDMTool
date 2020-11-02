//
//  ForgetPwdController.swift
//  SXReader
//
//  Created by 刘涛 on 2018/7/25.
//  Copyright © 2018年 FolioReader. All rights reserved.
//

import UIKit
import Material

class ForgetPwdController: UBaseViewController ,KeyboardHandle ,MockVerifyViewDelegate{
    var leftArrowView: IconButton!
    var accountField: ErrorTextField!
    var codeField: TextField!
    var loginBtn: RaisedButton!
    var verificationCodeBtn:SendCodeBtn!
    
    var viewModel: UserViewModel!
    
    override func viewWillDisappear(_ animated: Bool) {
        accountField?.resignFirstResponder()
        codeField?.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        self.showNavigation = false
        super.viewDidLoad()
        
        viewModel = UserViewModel()
        prepareUI()
        loginBtn.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        leftArrowView.addTarget(self, action: #selector(exitAction), for: .touchUpInside)
        verificationCodeBtn.addTarget(self, action: #selector(showCodeAction), for: .touchUpInside)
        
        // 调用系统的通知名称
        NotificationCenter.post(name: UIResponder.keyboardDidHideNotification, object: nil, userInfo: nil)
    }
    
    @objc func exitAction(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func showCodeAction(_ sender: Any){
        accountField?.resignFirstResponder()
        codeField?.resignFirstResponder()
        
        guard let account = self.accountField.text else {
            return
        }
        
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@","^1\\d{10}$")
        if (!regextestmobile.evaluate(with: account)) {
            SXToast.showToast(message: "请输入合法的手机号", aLocationStr: "bottom", aShowTime: 2.0)
            accountField.shake(direction: .horizontal, times: 5, interval: 0.1, delta: 1.8)
            return
        }
        
        if (self.verificationCodeBtn?.ready())! {
            let verifyView = MockVerifyView()
            verifyView.delegate = self;
            verifyView.show()
        }
    }
    

    
    /// 找回密码
    @objc func nextAction(_ sender: Any) {
        accountField?.resignFirstResponder()
        codeField?.resignFirstResponder()
        
        guard let smsCode = self.codeField.text, let account = self.accountField.text else {
            return
        }
        
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@","^1\\d{10}$")
        if (!regextestmobile.evaluate(with: account)) {
            SXToast.showToast(message: "请输入合法的手机号", aLocationStr: "bottom", aShowTime: 2.0)
            accountField.shake(direction: .horizontal, times: 5, interval: 0.1, delta: 1.8)
            return
        }
        
        if smsCode.isEmpty || smsCode.count != 4 {
            SXToast.showToast(message: "请输入正确的验证码", aLocationStr: "bottom", aShowTime: 2.0)
            codeField.shake(direction: .horizontal, times: 5, interval: 0.1, delta: 1.8)
            return
        }
        
        self.loginBtn.isEnabled = false
        HTTPProvider<UserApi<DBModel>>().request(.checkSMSCode(phoneNum: account,smsCode:smsCode,verType:"updatePassword"), responseHandler: { response in
            self.loginBtn.isEnabled = true
            if response.code == 200  {
                self.verificationCodeBtn?.stopCounting()
                let vc = ResetPwdController()
                vc.account = account
                vc.smsCode = smsCode
                vc.userName = response.value?.dataStr
                self.navigationController?.pushViewController(vc, animated: true)
            } else{
                SXToast.showToast(message: response.message, aLocationStr: "bottom", aShowTime: 3.0)
            }
        })
    }
    
    
    func mockVerifyViewVerifySuccess(_ useTime: Int) {
        
        let loginLog = LoginFunLogEntity(type: "1041", function_id: "", data: "\(useTime)")
        logan(LoganType.init(2),loginLog.toJSONString()!)
        
        let loginLog1 = LoginFunLogEntity(type: "3426", function_id: "", data: "\(useTime)")
        logan(LoganType.init(2),loginLog1.toJSONString()!)
        
        self.verificationCodeBtn?.beginCounting(120)
        self.viewModel.getSMSCode(phoneNum: self.accountField.text!, verType: "updatePassword",complete: { code,error  in
            if code == 200  {
                print("短信发送成功")
            } else{
                self.verificationCodeBtn?.stopCounting()
                SXToast.showToast(message: error, aLocationStr: "bottom", aShowTime: 3.0)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


