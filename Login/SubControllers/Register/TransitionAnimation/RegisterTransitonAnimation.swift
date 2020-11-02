//
//  RegisterTransitonAnimation.swift
//  SXReaderS
//
//  Created by 发抖喵 on 2020/9/4.
//  Copyright © 2020 FolioReader. All rights reserved.
//

//MARK: - 登录页点击进入注册页动画 不含手势
import UIKit

class RegisterTransitonAnimation: NSObject {
    
    var transitionType: TransitonAnimationType?
}


//MARK: - UIViewControllerAnimatedTransitioning
extension RegisterTransitonAnimation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch self.transitionType {
        case .Present:
            
            self.presentAnimation(transitionContext)
            break
        case .Dissmiss:
            
            self.dismissAnimation(transitionContext)
            break
        case .Push:
            
            self.pushAnimation(transitionContext)
            break
        case .Pop:
            
            self.popAnimation(transitionContext)
            break
        case .none:
            
            transitionContext.completeTransition(true)
            break
        }
    }
    
}


//MARK: - AnimationAction
extension RegisterTransitonAnimation {
    func presentAnimation(_ context: UIViewControllerContextTransitioning) {
        context.completeTransition(true)
    }
    
    func dismissAnimation(_ context: UIViewControllerContextTransitioning) {
        context.completeTransition(true)
    }
    
    
    //MARK: - Push动画
    func pushAnimation(_ context: UIViewControllerContextTransitioning) {
        
        // 转场后的VC RegisterController
        let toVC = context.viewController(forKey: .to) as? RegisterController
        // 转场前的VC LoginController 或者 MessageLoginController
        let fromVC = context.viewController(forKey: .from)
        var isMessage = false
        
        if fromVC!.isKind(of: LoginController.self) {
            isMessage = false
        }else {
            isMessage = true
        }
        
        // 获取转场前的登录按钮
        let loginBtn = isMessage ? (fromVC as! MessageLoginController).loginBtn : (fromVC as! LoginController).loginBtn

        // 转场动画管理者
        let containerView = context.containerView
        

        // 创建转场视图
        
        // toVC!.whiteBgView 需要使用深拷贝来进行复制
        toVC?.view.setNeedsLayout()
        toVC?.view.layoutIfNeeded()
        let whiteView = toVC!.whiteBgView.snapshotView(afterScreenUpdates: true)!
        
        // 白色背景
        let backgroundView = UIView()
        backgroundView.backgroundColor = toVC?.view.backgroundColor
        backgroundView.layer.cornerRadius = 22
        backgroundView.frame = fromVC!.view.frame
        
        // 按钮
        let loginBtnCopy = UIView()
        loginBtnCopy.layer.cornerRadius = 22
        loginBtnCopy.backgroundColor = .theme
        loginBtnCopy.frame = loginBtn.frame
        
        // 按钮上的文字
        let loginLabel = UILabel()
        loginLabel.text = "登录"
        loginLabel.textColor = .black
        loginLabel.font = UIFont(name: "PingFangSC-Regular", size: 18)
        
        //设置动画前的各个控件的状态
        loginBtn.isHidden = true
        toVC?.registerBtn.isHidden = true

        //添加到containerView中，Copy要保证在最上层，所以后添加
        containerView.addSubview(toVC!.view)
        containerView.addSubview(backgroundView)
        containerView.addSubview(whiteView)
        containerView.addSubview(loginBtnCopy)
        containerView.addSubview(loginLabel)
        
        whiteView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(LoginHeaderHeight)
        }
        
        loginLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(loginBtnCopy)
            make.centerX.equalToSuperview()
        }

        //开始做动画
        UIView.animate(withDuration: self.transitionDuration(using: context), animations: {
            
            loginLabel.text = "下一步"
            loginBtnCopy.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: kScreenWidth*0.37, height: loginBtnCopy.frame.height))
            backgroundView.frame = CGRect(origin: CGPoint(x: 0, y: LoginHeaderHeight), size: backgroundView.frame.size)
        }) { (endAnimation) in

            //如果动画过渡取消了就标记不完成，否则才完成，这里可以直接写YES，如果有手势过渡才需要判断，必须标记，否则系统不会中断动画完成的部署，会出现无法交互之类的bug
            loginBtn.isHidden = false
            toVC?.registerBtn.isHidden = false
            
            loginLabel.removeFromSuperview()
            loginBtnCopy.removeFromSuperview()
            backgroundView.removeFromSuperview()
            whiteView.removeFromSuperview()

            context.completeTransition(!context.transitionWasCancelled)
        }
    }
    
     
    //MARK: - Pop动画
    func popAnimation(_ context: UIViewControllerContextTransitioning) {
        
        let toVC = context.viewController(forKey: .to)
        let fromVC = context.viewController(forKey: .from) as? RegisterController
        
        var isMessage = false
        
        if toVC!.isKind(of: LoginController.self) {
            isMessage = false
        }else {
            isMessage = true
        }
        
        // 获取转场前的下一步按钮
        let registerBtn = fromVC?.registerBtn
        
        let containerView = context.containerView
        
        // 创建转场视图
        
        // 白色背景
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 22
        backgroundView.frame = fromVC!.whiteBgView.frame
        
        // 按钮
        let loginBtnCopy = UIView()
        loginBtnCopy.layer.cornerRadius = 22
        loginBtnCopy.backgroundColor = .theme
        loginBtnCopy.frame = CGRect(origin: CGPoint(x: registerBtn!.frame.origin.x, y: registerBtn!.frame.origin.y + LoginHeaderHeight), size: registerBtn!.frame.size)
        
        // 按钮上的文字
        let loginLabel = UILabel()
        loginLabel.text = "下一步"
        loginLabel.textColor = .black
        loginLabel.font = UIFont(name: "PingFangSC-Regular", size: 18)
        
        //设置动画前的各个控件的状态
        
        
        if isMessage {  // messageLoginController
            let vc = toVC as! MessageLoginController
            vc.loginBtn.isHidden = true
            registerBtn?.isHidden = true
            
            vc.animationView.layer.cornerRadius = 20
            vc.animationView.frame = CGRect(origin: CGPoint(x: 0, y:vc.animationView.frame.origin.y + LoginHeaderHeight), size: vc.animationView.frame.size)
            
            containerView.addSubview(vc.view)
        }else {
            let vc = toVC as! LoginController
            vc.loginBtn.isHidden = true
            registerBtn?.isHidden = true
            
            vc.animationView.layer.cornerRadius = 20
            vc.animationView.frame = CGRect(origin: CGPoint(x: 0, y:vc.animationView.frame.origin.y + LoginHeaderHeight), size: vc.animationView.frame.size)
            
            containerView.addSubview(vc.view)
        }

        //添加到containerView中，Copy要保证在最上层，所以后添加
        
        containerView.addSubview(loginBtnCopy)
        containerView.addSubview(loginLabel)
        
        loginLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(loginBtnCopy)
            make.centerX.equalToSuperview()
        }
        
        //开始做动画
        UIView.animate(withDuration: self.transitionDuration(using: context), animations: {

            loginLabel.text = "登录"
            loginBtnCopy.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: FScreenW - 70, height: loginBtnCopy.frame.height))
            
            backgroundView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: backgroundView.frame.size)
            
            if isMessage {  // 短信验证码登陆
                let vc = toVC as! MessageLoginController
                vc.animationView.layer.cornerRadius = 0
                vc.animationView.frame = CGRect(origin: CGPoint.zero, size: vc.animationView.frame.size)
            }else {
                let vc = toVC as! LoginController
                vc.animationView.layer.cornerRadius = 0
                vc.animationView.frame = CGRect(origin: CGPoint.zero, size: vc.animationView.frame.size)
            }
        }) { (endAnimation) in

            //如果动画过渡取消了就标记不完成，否则才完成，这里可以直接写YES，如果有手势过渡才需要判断，必须标记，否则系统不会中断动画完成的部署，会出现无法交互之类的bug
            registerBtn?.isHidden = false
            
            isMessage ? ((toVC as! MessageLoginController).loginBtn.isHidden = false) : ((toVC as! LoginController).loginBtn.isHidden = false)
            
            loginLabel.removeFromSuperview()
            loginBtnCopy.removeFromSuperview()
            backgroundView.removeFromSuperview()

            context.completeTransition(!context.transitionWasCancelled)
        }
    }
}
