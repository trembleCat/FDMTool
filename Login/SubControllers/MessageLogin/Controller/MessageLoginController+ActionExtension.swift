//
//  MessageLoginController+ActionExtension.swift
//  SXReaderS
//
//  Created by 发抖喵 on 2020/10/21.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import Foundation
import UIKit
import Material

//MARK: - Action
extension MessageLoginController: MockVerifyViewDelegate {
    func createAction() {
        /* 登录 */
        loginBtn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        /* 账号登陆 */
        messageLoginBtn.addTarget(self, action: #selector(gotoAccountSign), for: .touchUpInside)
        /* 新用户 */
        newUserBtn.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        
        /* 获取验证码 */
        accountView.codeField.addLastBtnTarget(self, action: #selector(self.showCodeAction), for: .touchUpInside)
        
        /* 接受通知 */
        NotificationCenter.default.addObserver(self, selector: #selector(updateAccount(notification:)), name: UpdateLoginControllNotification, object: nil)
        
        /* 静态引导页 */
        setStaticGuidePage()
    }
    
    /**
     静态引导页
     */
    func setStaticGuidePage() {
        // 判断当前版本是否第一次启动
        if UserDefaults.isFirstLaunchOfNewVersion() {
            let imageNameArray: [String] = ["guide1", "guide2", "guide3", "guide4"]
            let guideView = HHGuidePageHUD.init(imageNameArray: imageNameArray, isHiddenSkipButton: false)
            guideView.backgroundColor = UIColor.backgroundPrimaryDark
            self.navigationController?.view.backgroundColor = UIColor.backgroundPrimaryDark
            self.navigationController?.view.addSubview(guideView)
        }
    }
   
    /**
     接收到后执行的方法,更新账号信息
     */
    @objc func updateAccount(notification: NSNotification) {
        let userInfo = notification.userInfo as! [String:Any]
        let userInfoDic = userInfo as NSDictionary
        
        let accountText: String = userInfoDic.object(forKey: "account") as! String
        self.accountView.phoneField.text = accountText
        if (userInfoDic.object(forKey: "type") != nil) {
            SXToast.showToast(message: "手机号已注册", aLocationStr: "bottom", aShowTime: 3.0)
        }
        
        UserDefaults.standard.set(accountText, forKey: "UserNameKey")
    }
    
    /**
     显示滑动验证
     */
    @objc func showCodeAction(){
        accountView.phoneField.textField.resignFirstResponder()
        accountView.codeField.textField.resignFirstResponder()
        
        guard let account = self.accountView.phoneField.text else {
            return
        }
        
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@","^1\\d{10}$")
        if (!regextestmobile.evaluate(with: account)) {
            SXToast.showToast(message: "请输入合法的手机号", aLocationStr: "bottom", aShowTime: 2.0)
            accountView.phoneField.shake(direction: .horizontal, times: 5, interval: 0.1, delta: 1.8)
            return
        }
        
        if self.codeTimer.timeCount == 0 {
            let verifyView = MockVerifyView()
            verifyView.delegate = self;
            verifyView.show()
        }
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
        self.viewModel.getSMSCode(phoneNum: self.accountView.phoneField.text!, verType: "login",complete: { code,error  in
            if code == 200  {
                
                SXToast.showToastAction(message: "验证码已发送")
            } else{
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
            self?.accountView.codeField.lastButton.isUserInteractionEnabled = true
            self?.accountView.codeField.setLastBtnTitle("重新获取", for: .normal)
            self?.accountView.codeField.setLastBtnTitleColor(.Hex("#FFA91D"), for: .normal)
        }) {[weak self] (time) in

            FLog(title: "结束", message: time)
            self?.accountView.codeField.lastButton.isUserInteractionEnabled = false
            self?.accountView.codeField.setLastBtnTitle("\(time)s", for: .normal)
            self?.accountView.codeField.setLastBtnTitleColor(.Hex("#FFA91D"), for: .normal)
        }
        
        codeTimer.resume()
    }
    
    /**
     结束计时
     */
    func stopCounting() {
        codeTimer.cancel()
        codeTimer.timeCount = 0
        
        accountView.codeField.lastButton.isUserInteractionEnabled = true
        accountView.codeField.setLastBtnTitle("获取验证码", for: .normal)
        accountView.codeField.setLastBtnTitleColor(.Hex("#FFA91D"), for: .normal)
    }
   
    /**
     账号密码登陆
     */
    @objc func gotoAccountSign(_ sender: Any){
        
        self.navigationController?.popViewController(animated: false)
    }
    
    /**
     注册
     */
    @objc func registerAction(_ sender: Any) {
        
        let registerVC = RegisterController()
        registerVC.phoneFieldFrame = self.accountView.convert(self.accountView.phoneField.frame, to: self.view)
        registerVC.codeFieldFrame = self.accountView.convert(self.accountView.codeField.frame, to: self.view)
        registerVC.registerFrame = self.loginBtn.frame
        
        self.navigationController?.delegate = registerVC
        self.navigationController!.pushViewController(registerVC, animated: true)
    }

    /**
     登录
     */
    @objc func loginAction(_ sender: Any) {
        if !canLogin {
            return
        }
        UMAnalyticsManager.event(eventId: "1066")
        let loginLog = LoginFunLogEntity(type: "1037", function_id: "", data: "")
        logan(LoganType.init(2),loginLog.toJSONString()!)
        
        accountView.accountField?.resignFirstResponder()
        accountView.passwordField?.resignFirstResponder()
        
        guard let pwd = self.accountView.codeField.text, let account = self.accountView.phoneField.text else {
            return
        }
        
        if account.isEmpty {
            SXToast.showToast(message: "请输入手机号", aLocationStr: "bottom", aShowTime: 3.0)
            accountView.phoneField.shake(direction: .horizontal, times: 5, interval: 0.1, delta: 1.8)
            return
        }
        
        if pwd.isEmpty {
            SXToast.showToast(message: "请输入验证码", aLocationStr: "bottom", aShowTime: 3.0)
            accountView.codeField.shake(direction: .horizontal, times: 5, interval: 0.1, delta: 1.8)
            return
        }
        
        let dm = DataBaseManager.default
        let loginError = dm.queryObjects(type: LoginErrorEntity.self).filter("account == %@",account).first
        if loginError != nil {
            if (loginError!.times > 4 ){
                let timeStamp = Int(NSDate(timeIntervalSinceNow: 0).timeIntervalSince1970)
                let second = (timeStamp - loginError!.timeStamp)/60
                if (second < 30) {
                    SXToast.showToastAction(message: "你的账号已被锁定30分钟！")
                    return
                }
            }
        }
        
        canLogin = false
        UserDefaults.standard.set(account, forKey: "UserNameKey")
        
        SXToast.showIndicatorToastAction(message: "登录中")
        
        self.viewModel.smsLogin(mobile: account,smsCode: pwd,complete: { user,error  in
            SXToast.hiddenIndicatorToastAction()
            if let user = user  {
                if user.event.webAuthorities.contains("ROLE_Student") && user.isLogin == 1{
                    if loginError != nil {
                        dm.deleteObjects(objects: [loginError!])
                    }
                    currentUser = user
                    currentUser.userId = currentUser.event.userId
                    userId = currentUser.event.userId
                    schoolId = currentUser.event.schoolId
                    token_value = user.event.token
                    
                    self.getBookStoreVersion(user: user)
                } else{
                    SXToast.showToastAction(message:"非学生用户，禁止登陆！")
                    self.canLogin = true
                }
                
            } else{
                self.canLogin = true
                if error == "该账号不存在" {
                    SXToast.showToast(message: error, aLocationStr: "bottom", aShowTime: 3.0)
                }else{
                    let newLoginError = LoginErrorEntity();
                    newLoginError.account = account
                    newLoginError.timeStamp = Int(NSDate(timeIntervalSinceNow: 0).timeIntervalSince1970)
                    if loginError != nil && (newLoginError.timeStamp - loginError!.timeStamp < 600){
                        newLoginError.times = loginError!.times + 1
                    }else{
                        newLoginError.times =  1
                    }
                    dm.insertOrUpdate(objects: [newLoginError])
                    if newLoginError.times == 3 {
                        SXToast.showToastAction(message: "注意！连续5次输入错误密码，您的账号\n将会锁定30分钟！")
                    }else if newLoginError.times == 5 {
                        SXToast.showToastAction(message: "你的账号已被锁定30分钟！")
                    }else{
                        SXToast.showToast(message: error, aLocationStr: "bottom", aShowTime: 3.0)
                    }
                }
                
            }
            
        })
    }
    
    func getBookStoreVersion(user:UserInfoResponse) {
        HTTPProvider<UserApi<BookStoreVersionResponse>>()
            .request(.getBookStoreVersion, responseHandler: { response in
            if response.success {
                for item in response.values! {
                    if item.status == 1 {
                        user.event.bookStoreVersion = item.bookStoreVersion
                        break
                    }
                }
                
                let dm = DataBaseManager.default
                dm.deleteAllObjects(type: UserInfoResponse.self)
                dm.insertOrUpdate(objects: [user])
                
                currentUser = user
                //
                let firstLanding = user.event.firstLanding
                UserDefaults.standard.set(token_value, forKey: TOKEN_NAME)
                                   if firstLanding {
                                       let webVC = SXWebViewController(urlString: NetworkConfig.FirstLoginURL,showNavigation:false)
                                       self.navigationController?.pushViewController(webVC, animated: true)
                                   }else{
                                       GlobalUIManager.loadHomeVC()
                                   }
            }else {
                SXToast.showToast(message: response.message, aLocationStr: "bottom", aShowTime: 3.0)
            }
        })
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


//MARK: - UITextFieldDelegate
extension MessageLoginController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == accountView.accountField {
            
            accountView.phoneField.titleImage = UIImage(named: "Register_PhoneSelected")
        }else if textField == accountView.passwordField {
            
            accountView.codeField.titleImage = UIImage(named: "Register_CodeSelected")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        accountView.phoneField.titleImage = UIImage(named: "Register_PhoneNoraml")
        accountView.codeField.titleImage = UIImage(named: "Register_CodeNormal")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField.returnKeyType == UIReturnKeyType.done){
            textField.resignFirstResponder()//键盘收起
            return false
        }else if(textField == accountView.accountField){
            let _ = accountView.passwordField?.becomeFirstResponder()
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
        
        if textField == accountView.phoneField.textField{//账号11位
            if length > 11 {
                return false
            }
        }else if textField == accountView.codeField.textField{//验证码4位
            if length > 4{
                return false
            }
        }
        
        return true
    }
}

