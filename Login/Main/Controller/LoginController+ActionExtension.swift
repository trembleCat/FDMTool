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

//MARK: - Action
extension LoginController {
    func createAction() {
        /* 登录 */
        loginBtn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        /* 短信登陆 */
        messageLoginBtn.addTarget(self, action: #selector(gotoCodeSign), for: .touchUpInside)
        /* 新用户 */
        newUserBtn.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        /* 忘记密码 */
        forgetPasswordBtn.addTarget(self, action: #selector(forgetPwdAction), for: .touchUpInside)
        
        //NotificationCenter.post(name: .UIKeyboardDidHide, object: nil, userInfo: nil)
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
        self.accountView.accountField?.text = accountText
       
        UserDefaults.standard.set(accountText, forKey: "UserNameKey")
    }
   
    /**
     短信验证码登陆
     */
    @objc func gotoCodeSign(_ sender: Any){
        UMAnalyticsManager.event(eventId: "1067")
        let loginLog = LoginFunLogEntity(type: "1036", function_id: "", data: "")
        logan(LoganType.init(2),loginLog.toJSONString()!)
        
        let vc = MessageLoginController()
        self.navigationController!.pushViewController(vc, animated: false)
    }
   
    /**
     忘记密码
     */
    @objc func forgetPwdAction(_ sender: Any){
        self.navigationController!.pushViewController(ForgetPwdController(), animated: true)
    }
   
    /**
     注册
     */
    @objc func registerAction(_ sender: Any) {
        
        let registerVC = RegisterController()
        registerVC.phoneFieldFrame = self.accountView.convert(self.accountView.account_View.frame, to: self.view)
        registerVC.codeFieldFrame = self.accountView.convert(self.accountView.password_View.frame, to: self.view)
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
        UMAnalyticsManager.event(eventId: "1065")
        let loginLog = LoginFunLogEntity(type: "1035", function_id: "", data: "")
        logan(LoganType.init(2),loginLog.toJSONString()!)
       
        accountView.accountField?.resignFirstResponder()
        accountView.passwordField?.resignFirstResponder()
       
        guard let pwd = accountView.passwordField?.text, let account = accountView.accountField?.text else {
            return
        }
       
        if account.isEmpty {
            SXToast.showToast(message: "请输入账号", aLocationStr: "bottom", aShowTime: 3.0)
            accountView.accountField?.shake(direction: .horizontal, times: 5, interval: 0.1, delta: 1.8)
            return
        }
       
        if pwd.isEmpty {
            SXToast.showToast(message: "请输入密码", aLocationStr: "bottom", aShowTime: 3.0)
            accountView.passwordField?.shake(direction: .horizontal, times: 5, interval: 0.1, delta: 1.8)
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
       
        self.viewModel.login(pwd: pwd,account: account,complete: { user,error  in
            SXToast.hiddenIndicatorToastAction()
            if let user = user  {
                if user.event.webAuthorities.contains("ROLE_Student") {
                    if loginError != nil {
                        dm.deleteObjects(objects: [loginError!])
                    }
                    currentUser = user
                    currentUser.userId = currentUser.event.userId
                    userId = currentUser.event.userId
                    schoolId = currentUser.event.schoolId
                    token_value = user.event.token
                   
                    self.getBookStoreVersion(user: user)
                    //userId = user.event.userId
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
         
                if currentUser.event.schoolName == "书香阅读"{
                    self.checkOriginInfo()
                }else{
                    if user.event.firstLanding {
                        let webVC = SXWebViewController(urlString: NetworkConfig.FirstLoginURL,showNavigation:false)
                        self.navigationController?.pushViewController(webVC, animated: true)
                    }else{
                        GlobalUIManager.loadHomeVC()
                    }
                }
                /*
                if !self.verifyPasswordRules(pasword: self.passwordField.text!){
                    self.navigationController!.pushViewController(ResetPwdController2(firstLanding:firstLanding), animated: true)
                }else{
                    UserDefaults.standard.set(token_value, forKey: TOKEN_NAME)
                    if firstLanding {
                        let webVC = SXWebViewController(urlString: NetworkConfig.FirstLoginURL,showNavigation:false)
                        self.navigationController?.pushViewController(webVC, animated: true)
                    }else{
                        GlobalUIManager.loadHomeVC()
                    }
                }
 */
            }else {
                SXToast.showToast(message: response.message, aLocationStr: "bottom", aShowTime: 3.0)
            }
        })
    }
   
    private func checkOriginInfo(){
        HTTPProvider<UserApi<UserOriginInfoRessponse>>().request(.getUserRegisterOrgInfo, responseHandler: { response in
            if response.success {
                if response.value == nil || response.value!.schoolName == "" {
                    let request = UpdateSchoolRequest(userId:userId!)
                    self.navigationController?.pushViewController(SelectSchoolViewController(request:request,showNextBtn: true), animated:true)
                } else {
                    GlobalUIManager.loadHomeVC()
                }
            }else{
                SXToast.showToast(message: response.message, aLocationStr: "bottom", aShowTime: 3.0)
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
extension LoginController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == accountView.accountField {
            
            accountView.setAccountTitleImage(name: "Login_AccountSelected")
            accountView.setPasswordTitleImage(name: "Login_PasswordNormal")
        }else if textField == accountView.passwordField {
            
            accountView.setPasswordTitleImage(name: "Login_PasswordSelected")
            accountView.setAccountTitleImage(name: "Login_AccountNormal")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        accountView.setAccountTitleImage(name: "Login_AccountNormal")
        accountView.setPasswordTitleImage(name: "Login_PasswordNormal")
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
        if length > 50 {
            return false
        }
        
        let len = string.lengthOfBytes(using: String.Encoding.utf8)
        if accountView.accountField == textField {
            for loopIndex in 0..<len {
                let char = (string as NSString).character(at: loopIndex)
                //只能输入 a~z A~Z 0~9
                if char < 48 {return false}
                if char < 65 && char > 57 {return false }
                if char > 90 && char < 97 {return false }
                if char > 122 {return false }
            }
        }
        
        return true
    }
}
