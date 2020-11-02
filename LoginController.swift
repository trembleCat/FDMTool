//
//  LoginController.swift
//  Example
//
//  Created by 刘涛 on 2018/7/20.
//  Copyright © 2018年 FolioReader. All rights reserved.
//
//MARK: - 登录

import UIKit
import Material
import JGProgressHUD
import CloudPushSDK

class LoginController: UBaseViewController ,KeyboardHandle{
    let headerImgView = UIImageView()
    let animationView = UIView()
    let welcomeView = LoginWelcomeView()
    let accountView = LoginAccountView()
    let forgetPasswordBtn = FlatButton(title: "忘记密码?")
    let loginBtn = UIButton(type: .system)
    let messageLoginBtn = FDMCustomButton()
    let backGroundImageView = UIImageView(image: UIImage(named: "Login_Background"))
    let newUserBtn = FDMCustomButton()
    let protocolBtn = FlatButton()
    
    var weixinView: UIImageView!
    var canLogin = true
    var viewModel = UserViewModel()
    var errorTime = 0
    
    var treatyModel: TreatyModel?   // 协议
    
    lazy var clauseView: LoginClauseView = {    // 协议弹窗
       return LoginClauseView()
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        accountView.accountField?.resignFirstResponder()
        accountView.passwordField?.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        showNavigation = false
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.backgroundColor = .backgroundPrimary
        
        createUI()
        createAction()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)//移除通知
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        accountView.accountField?.resignFirstResponder()
        accountView.passwordField?.resignFirstResponder()
    }
}


//MARK: - UI
extension LoginController {
    
    func createUI() {
        self.view.addSubview(headerImgView)
        self.view.addSubview(animationView)
        self.view.addSubview(welcomeView)
        self.view.addSubview(accountView)
        self.view.addSubview(forgetPasswordBtn)
        self.view.addSubview(loginBtn)
        self.view.addSubview(messageLoginBtn)
        self.view.addSubview(backGroundImageView)
        self.view.addSubview(newUserBtn)
        self.view.addSubview(protocolBtn)
        
        /* 顶部转场动画图片 */
        headerImgView.image = UIImage(named: "Register_TopBackground")
        headerImgView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(119)
        }
        
        /* 动画view */
        animationView.backgroundColor = .backgroundPrimary
        animationView.frame = self.view.bounds
        
        /* 顶部欢迎视图 */
        welcomeView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(114)
            make.top.equalToSuperview().offset(FDMTool.screenWithStatusHeight())
        }
        
        /* 输入账号密码视图 */
        accountView.accountField?.delegate = self
        accountView.passwordField?.delegate = self
        accountView.accountField?.text = UserDefaults.standard.value(forKey: "UserNameKey") as? String
        accountView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(217)
            make.top.equalTo(welcomeView.snp.bottom).offset(-23)
        }
        
        /* 忘记密码 */
        forgetPasswordBtn.fontSize = 14
        forgetPasswordBtn.titleLabel?.textAlignment = NSTextAlignment.right
        forgetPasswordBtn.titleColor = UIColor.textPrimaryDark
        forgetPasswordBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(35)
            make.top.equalTo(accountView.snp.bottom).offset(14)
            make.height.equalTo(18)
        }
        
        /* 登录按钮 */
        loginBtn.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 18)
        loginBtn.setTitleColor(.black, for: .normal)
        loginBtn.setTitle("登录", for: .normal)
        loginBtn.layer.cornerRadius = 22
        loginBtn.backgroundColor = .Hex("#FFDB28")
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(accountView.snp.bottom).offset(52)
            make.left.equalToSuperview().offset(35)
            make.right.equalToSuperview().offset(-35)
            make.height.equalTo(44)
        }
        
        /* 短信验证码登录 */
        messageLoginBtn.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 13)
        messageLoginBtn.imagePosition = .FDMButtomImageRight
        messageLoginBtn.setTitle("短信验证码登陆 ", for: .normal)
        messageLoginBtn.setTitleColor(.textBlackPrimary, for: .normal)
        messageLoginBtn.setImage(UIImage(named: "Arrow01_Right"), for: .normal)
        messageLoginBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-35)
            make.top.equalTo(loginBtn.snp.bottom).offset(23)
            make.height.equalTo(18)
        }
        
        /* 背景图 */
        backGroundImageView.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 123, height: 143))
        }
        
        /* 新用户 */
        newUserBtn.titleLabel?.font = UIFont(name: "PingFangSC-Medium", size: 12)
        newUserBtn.imagePosition = .FDMButtomImageLeft
        newUserBtn.setTitle(" 我是新用户", for: .normal)
        newUserBtn.setTitleColor(.textBlackPrimary, for: .normal)
        newUserBtn.setImage(UIImage(named: "Login_Add"), for: .normal)
        newUserBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(protocolBtn.snp.top).offset(-40)
        }
        
        /* 阅读测评 */
        prepareEvaluationLoginBtn()
        /* 阅读条款 */
        prepareBottomView()
    }
    
    /**
     阅读测评
     */
    fileprivate func prepareEvaluationLoginBtn(){
        let entryEvaluationImg = UIImage(named: "evaluation_icon")
        let entryEvaluationImgView = UIImageView(image: entryEvaluationImg)
        entryEvaluationImgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.evaluationIdCodeLogin)))
        self.view.addSubview(entryEvaluationImgView)
        entryEvaluationImgView.isUserInteractionEnabled = true
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
    
    /**
     阅读条款
     */
    fileprivate func prepareBottomView(){
        
        let strg = "登录即代表已阅读并同意《用户协议》与《隐私政策》"
        let ranStr = "《用户协议》"
        let procotolStr = "《隐私政策》"
        let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:strg)
        let str = NSString(string: strg)
        let theRange = str.range(of: ranStr)
        attrstring.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor.theme, range: theRange)
            
        let theRange1 = str.range(of: procotolStr)
        attrstring.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor.theme, range: theRange1)
  
        let procotolLabel = UILabel()
        procotolLabel.numberOfLines = 2
//        procotolLabel.textAlignment = .center
        procotolLabel.textColor = UIColor.init(hexColor: "#666666")
        procotolLabel.font = .systemFont(ofSize: 14)
        procotolLabel.enlargeTapArea = true
        procotolLabel.text = strg
        procotolLabel.attributedText = attrstring
        procotolLabel.yb_addAttributeTapAction(with: [ranStr, procotolStr]) {[weak self] (label, content, range, index) in
            if content == ranStr {
                self?.clickUserProtocol()
            }else{
                self?.protocalAction()
            }
        }
        view.addSubview(procotolLabel)
        procotolLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-15)
            $0.height.equalTo(40)
        }
        
        let bottomView = UIView()
        bottomView.isUserInteractionEnabled = true
        let signTapGesture = UITapGestureRecognizer(target: self, action: #selector(registerAction(_:)))
        bottomView.addGestureRecognizer(signTapGesture)
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.bottom.equalTo(procotolLabel.snp.top).offset(-5)
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
}
