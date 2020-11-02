//
//  ResetPwdController2.swift
//  SXReaderS
//
//  Created by 刘涛 on 2020/1/15.
//  Copyright © 2020 FolioReader. All rights reserved.
//

//
//  ResetPwdController.swift
//  SXReader
//
//  Created by 刘涛 on 2018/7/25.
//  Copyright © 2018年 FolioReader. All rights reserved.
//

import UIKit
import Material

class ResetPwdController2: UBaseViewController ,KeyboardHandle{
    var pwdField: TextField!
    var ackPwdField: TextField!
    var nextBtn: RaisedButton!
    
    var viewModel: UserViewModel!
    var account:String!
    var smsCode:String!
    var userName:String!
    var accountLabel:UILabel!
    var firstLanding:Bool = false;
    
    public convenience init(firstLanding:Bool = false) {
        self.init()
        self.firstLanding = firstLanding
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        pwdField?.resignFirstResponder()
        ackPwdField?.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        self.showNavigation = false
        super.viewDidLoad()
        //ThemeManager.setStatusBarBackgroundColor(color: UIColor.init(hexColor: "#BCBCBC"))
        
        viewModel = UserViewModel()
        prepareUI()
        nextBtn.addTarget(self, action: #selector(updatePwdAction), for: .touchUpInside)
        
        accountLabel.text = "为了确保您的账号安全，请修改您的密码。"
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
        print(userId!)
        let request = UpdatePasswordRequest.init(userId: userId!, password: ackPwd);
        self.viewModel.updatePwd2(pwd: request, complete: { code,error  in
            self.nextBtn.isEnabled = true
            if code == 200  {
                UserDefaults.standard.set(token_value, forKey: TOKEN_NAME)
                if self.firstLanding {
                    let webVC = SXWebViewController(urlString: NetworkConfig.FirstLoginURL,showNavigation:false)
                    self.navigationController?.pushViewController(webVC, animated: true)
                }else{
                    GlobalUIManager.loadHomeVC()
                }
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

