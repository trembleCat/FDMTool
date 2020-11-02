//
//  RegisterController.swift
//  SXReader
//
//  Created by 刘涛 on 2018/7/24.
//  Copyright © 2018年 FolioReader. All rights reserved.
//

import UIKit
import Material

class RegisterController: UBaseViewController ,KeyboardHandle ,MockVerifyViewDelegate{
    
    /// 转场动画
    let transitionAnimation = RegisterTransitonAnimation()
    
    let topBgImgView = UIImageView()
    let whiteBgView = UIView()
    let leftArrowView = IconButton()
    let bottomBgImgView = UIImageView()
    let titleBanner = UILabel()
    
    let phoneField = FDMAccountField()
    var phoneFieldFrame = CGRect.zero
    
    let codeField = FDMAccountField()
    var codeFieldFrame = CGRect.zero
    
    let registerBtn = UIButton(type: .system)
    var registerFrame = CGRect.zero
    
    let codeTimer = FDMGcdTimer()
    
    var viewModel = UserViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        phoneField.textField.resignFirstResponder()
        codeField.textField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        showNavigation = false
        super.viewDidLoad()
        
        self.view.backgroundColor = .backgroundPrimary
        
        createUI()
        createAction()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        phoneField.textField.resignFirstResponder()
        codeField.textField.resignFirstResponder()
    }
}


//MARK: - UI
extension RegisterController {
    
    func createUI() {
        self.view.addSubview(topBgImgView)
        self.view.addSubview(leftArrowView)
        self.view.addSubview(whiteBgView)
        self.whiteBgView.addSubview(titleBanner)
        self.whiteBgView.addSubview(phoneField)
        self.whiteBgView.addSubview(codeField)
        self.whiteBgView.addSubview(registerBtn)
        self.whiteBgView.addSubview(bottomBgImgView)
        
        /* 顶部背景图 */
        topBgImgView.image = UIImage(named: "Register_TopBackground")
        topBgImgView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(119)
        }
        
        /* 返回按钮 */
        leftArrowView.setImage(UIImage(named: "Login_Back"), for: .normal)
        leftArrowView.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(18)
            make.bottom.equalTo(topBgImgView.snp.bottom).offset(-47)
            make.size.equalTo(CGSize(width: 25, height: 30))
        }
        
        /* 白色背景 */
        whiteBgView.layer.cornerRadius = 20
        whiteBgView.backgroundColor = self.view.backgroundColor
        whiteBgView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(LoginHeaderHeight)
        }
        
        /* 标题 */
        titleBanner.text = "手机号快速注册"
        titleBanner.font = UIFont(name: "PingFangSC-Medium", size: 22)
        titleBanner.textColor = .textBlackPrimary
        titleBanner.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(40)
            make.top.equalTo(whiteBgView.snp.top).offset(40)
            make.height.equalTo(30)
        }
        
        /* 手机号输入框 */
        let phoneFieldPlaceholderAttrs = NSMutableAttributedString.init(string: "请输入手机号")
        phoneFieldPlaceholderAttrs.addForegroundColor(.Hex("#cccccc"))
        
        phoneField.textField.attributedPlaceholder = phoneFieldPlaceholderAttrs
        phoneField.textField.keyboardType = .numberPad
        phoneField.textField.delegate = self
        phoneField.backgroundColor = .Hex("#F7F7F7")
        phoneField.textField.textColor = .Hex("#333333")
        phoneField.layer.cornerRadius = 26
        phoneField.titleImage = UIImage(named: "Register_PhoneNoraml")
        let phoneFieldY = phoneFieldFrame.origin.y - LoginHeaderHeight
        phoneField.frame = CGRect(origin: CGPoint(x: phoneFieldFrame.origin.x, y: phoneFieldY), size: phoneFieldFrame.size)
        
        /* 验证码输入框 */
        let codeFieldPlaceholderAttrs = NSMutableAttributedString.init(string: "请输入验证码")
        codeFieldPlaceholderAttrs.addForegroundColor(.Hex("#cccccc"))
        
        codeField.textField.attributedPlaceholder = codeFieldPlaceholderAttrs
        codeField.isUserInteractionEnabled = true
        codeField.textField.keyboardType = .numberPad
        codeField.textField.delegate = self
        codeField.backgroundColor = .Hex("#F7F7F7")
        codeField.textField.textColor = .Hex("#333333")
        codeField.layer.cornerRadius = 26
        codeField.titleImage = UIImage(named: "Register_CodeNormal")
        codeField.lastButton.titleLabel?.font = UIFont(name: "PingFangSC-Semibold", size: 16)
        codeField.setLastBtnTitle("获取验证码", for: .normal)
        codeField.setLastBtnTitleColor(.Hex("#FFA91D"), for: .normal)
        let codeFieldY = codeFieldFrame.origin.y - LoginHeaderHeight
        codeField.frame = CGRect(origin: CGPoint(x: codeFieldFrame.origin.x, y: codeFieldY), size: codeFieldFrame.size)
        
        /* 下一步 */
        registerBtn.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 18)
        registerBtn.setTitleColor(.black, for: .normal)
        registerBtn.setTitle("下一步", for: .normal)
        registerBtn.layer.cornerRadius = 22
        registerBtn.backgroundColor = UIColor.theme
        registerBtn.snp.makeConstraints { (make) in
            make.top.equalTo(codeField.snp.bottom).offset(52)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(140)
        }
        
        /* 底部背景图 */
        bottomBgImgView.image = UIImage(named: "Register_Background")
        bottomBgImgView.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 117.5, height: 117.5))
        }
    }
}

