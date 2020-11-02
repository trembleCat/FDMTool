//
//  LoginController.swift
//  Example
//
//  Created by 刘涛 on 2018/7/20.
//  Copyright © 2018年 FolioReader. All rights reserved.
//

import UIKit
import Material
import JGProgressHUD
import CloudPushSDK

class LoginViewController2: UBaseViewController ,KeyboardHandle,MockVerifyViewDelegate{
    var bannerView: UIImageView!
    var accountField: ErrorTextField!
    var codeField: TextField!
    var loginBtn: RaisedButton!
    var verificationCodeBtn:SendCodeBtn!
    var registerBtn : FlatButton?
    var canLogin = true
    var viewModel = UserViewModel()
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.barStyle(.clear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        accountField?.resignFirstResponder()
        codeField?.resignFirstResponder()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attachedView()
        
        loginBtn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        verificationCodeBtn.addTarget(self, action: #selector(showCodeAction), for: .touchUpInside)
        
        //NotificationCenter.post(name: .UIKeyboardDidHide, object: nil, userInfo: nil)
        //接受通知
        NotificationCenter.default.addObserver(self, selector: #selector(updateAccount(notification:)), name: UpdateLoginControllNotification, object: nil)
    }
    
    
    //接收到后执行的方法,更新账号信息
    @objc func updateAccount(notification: NSNotification) {
        let userInfo = notification.userInfo as! [String:Any]
        let userInfoDic = userInfo as NSDictionary
        
        let accountText: String = userInfoDic.object(forKey: "account") as! String
        self.accountField.text = accountText
        if (userInfoDic.object(forKey: "type") != nil) {
            SXToast.showToast(message: "手机号已注册", aLocationStr: "bottom", aShowTime: 3.0)
        }
        
        UserDefaults.standard.set(accountText, forKey: "UserNameKey")
    }
    
    @objc func gotoCodeSign(_ sender: Any){
        UMAnalyticsManager.event(eventId: "1068")
        let loginLog = LoginFunLogEntity(type: "1038", function_id: "", data: "")
        logan(LoganType.init(2),loginLog.toJSONString()!)
        self.navigationController!.popViewController(animated: true)
    }
    
    //注册
    @objc func gotoRegister(_ sender: Any) {
        self.navigationController!.pushViewController(RegisterController(), animated: true)
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
    
    /// 登录
    @objc func loginAction(_ sender: Any) {
        if !canLogin {
            return
        }
        UMAnalyticsManager.event(eventId: "1066")
        let loginLog = LoginFunLogEntity(type: "1037", function_id: "", data: "")
        logan(LoganType.init(2),loginLog.toJSONString()!)
        
        accountField?.resignFirstResponder()
        codeField?.resignFirstResponder()
        
        guard let pwd = self.codeField.text, let account = self.accountField.text else {
            return
        }
        
        if account.isEmpty {
            SXToast.showToast(message: "请输入账号", aLocationStr: "bottom", aShowTime: 3.0)
            accountField.shake(direction: .horizontal, times: 5, interval: 0.1, delta: 1.8)
            return
        }
        
        if pwd.isEmpty {
            SXToast.showToast(message: "请输入验证码", aLocationStr: "bottom", aShowTime: 3.0)
            codeField.shake(direction: .horizontal, times: 5, interval: 0.1, delta: 1.8)
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    deinit {
        NotificationCenter.default.removeObserver(self)//移除通知
    }

    func mockVerifyViewVerifySuccess(_ useTime: Int) {
        let loginLog = LoginFunLogEntity(type: "1041", function_id: "", data: "\(useTime)")
        logan(LoganType.init(2),loginLog.toJSONString()!)
        
        let loginLog1 = LoginFunLogEntity(type: "3426", function_id: "", data: "\(useTime)")
        logan(LoganType.init(2),loginLog1.toJSONString()!)
        
        self.verificationCodeBtn?.beginCounting(120)
        self.viewModel.getSMSCode(phoneNum: self.accountField.text!, verType: "login",complete: { code,error  in
            if code == 200  {
                //print("短信发送成功")
                SXToast.showToastAction(message: "验证码已发送")

            } else{
                self.verificationCodeBtn?.stopCounting()
                SXToast.showToast(message: error, aLocationStr: "bottom", aShowTime: 3.0)
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
