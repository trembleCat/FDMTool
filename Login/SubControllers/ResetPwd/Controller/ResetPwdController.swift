//
//  ResetPwdController.swift
//  SXReader
//
//  Created by 刘涛 on 2018/7/25.
//  Copyright © 2018年 FolioReader. All rights reserved.
//

import UIKit
import Material

class ResetPwdController: UBaseViewController ,KeyboardHandle{
    var leftArrowView: IconButton!
    var pwdField: TextField!
    var ackPwdField: TextField!
    var nextBtn: RaisedButton!
    
    var viewModel: UserViewModel!
    var account:String!
    var smsCode:String!
    var userName:String!
    var accountLabel:UILabel!
    
    var showLeftNavigation: Bool = true
    //var  provider: HTTPProvider<UserApi>!
    
    public convenience init(showNavigation:Bool = true) {
        self.init()
        self.showLeftNavigation = showNavigation
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        pwdField?.resignFirstResponder()
        ackPwdField?.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        self.showNavigation = false
        super.viewDidLoad()
       
        viewModel = UserViewModel()
        prepareUI()
        nextBtn.addTarget(self, action: #selector(updatePwdAction), for: .touchUpInside)
        leftArrowView.addTarget(self, action: #selector(exitAction), for: .touchUpInside)
        
        if userName != nil {
            accountLabel.text = "您的账号为：" + userName
        }else{
            accountLabel.text = "为了确保您的账号安全，请修改您的密码。"
        }
        // 调用系统的通知名称
        NotificationCenter.post(name: UIResponder.keyboardDidHideNotification, object: nil, userInfo: nil)
    }
    
    @objc func exitAction(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    /// 设置密码
    @objc func updatePwdAction(_ sender: Any) {
        self.pwdField?.resignFirstResponder()
        self.ackPwdField?.resignFirstResponder()
        
        guard let pwd = self.pwdField.text , let ackPwd = self.ackPwdField.text else {
            return
        }
        
        if !verifyPasswordRules(pasword: pwd){
            SXToast.showToast(message: "请按照要求设置密码！", aLocationStr: "bottom", aShowTime: 2.0)
            pwdField.shake(direction: .horizontal, times: 5, interval: 0.1, delta: 1.8)
            return
        }
        
        if ackPwd.isEmpty || !ackPwd.elementsEqual(pwd) {
            SXToast.showToast(message: "两次输入不一致，请重新输入", aLocationStr: "bottom", aShowTime: 2.0)
            ackPwdField.shake(direction: .horizontal, times: 5, interval: 0.1, delta: 1.8)
            return
        }
        
        self.nextBtn.isEnabled = false
        self.viewModel.updatePwd(phoneNum: account, pwd: ackPwd, smsCode: smsCode, complete: { code,error  in
            self.nextBtn.isEnabled = true
            if code == 200  {
                //跳转并更新登录界面账号
                NotificationCenter.default.post(name: UpdateLoginControllNotification, object: nil,userInfo: ["account" : self.userName])
                self.navigationController?.popToRootViewController(animated: true)
            } else{
                SXToast.showToast(message: error, aLocationStr: "bottom", aShowTime: 2.0)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
