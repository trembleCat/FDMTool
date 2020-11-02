//
//  InproveInformationTransitionAnimation.swift
//  SXReaderS
//
//  Created by 发抖喵 on 2020/9/7.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import UIKit

class InproveInformationTransitionAnimation: NSObject {

    var transitionType: TransitonAnimationType?
}

//MARK: - UIViewControllerAnimatedTransitioning
extension InproveInformationTransitionAnimation: UIViewControllerAnimatedTransitioning {
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
extension InproveInformationTransitionAnimation {
    func presentAnimation(_ context: UIViewControllerContextTransitioning) {
        context.completeTransition(true)
    }
    
    func dismissAnimation(_ context: UIViewControllerContextTransitioning) {
        context.completeTransition(true)
    }
    
    
    //MARK: - Push动画
    func pushAnimation(_ context: UIViewControllerContextTransitioning) {
        
        let toVC = context.viewController(forKey: .to) as!  ImproveInformationController
        let fromVC = context.viewController(forKey: .from) as! SetPasswordController
        
        let containerView = context.containerView
        
        toVC.view.setNeedsLayout()
        toVC.view.layoutIfNeeded()
        
        fromVC.registerBtn.isHidden = true
        toVC.successBtn.isHidden = true
        toVC.skipBtn.alpha = 0
        
        let successBtnCoppy = UIButton()
        successBtnCoppy.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 18)
        successBtnCoppy.setTitleColor(.black, for: .normal)
        successBtnCoppy.setTitle("下一步", for: .normal)
        successBtnCoppy.layer.cornerRadius = 22
        successBtnCoppy.backgroundColor = UIColor.theme
        successBtnCoppy.frame = fromVC.whiteBgView.convert(fromVC.registerBtn.frame, to: fromVC.view)
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(successBtnCoppy)
        
        UIView.animate(withDuration: transitionDuration(using: context), animations: {
            
            toVC.skipBtn.alpha = 1
            successBtnCoppy.frame = toVC.whiteBgView.convert(toVC.successBtn.frame, to: toVC.view)
            successBtnCoppy.setTitle("完成", for: .normal)
        }) { (isAnimation) in
            
            fromVC.registerBtn.isHidden = false
            toVC.successBtn.isHidden = false
            
            successBtnCoppy.removeFromSuperview()
            context.completeTransition(!context.transitionWasCancelled)
        }
    }
    
     
    //MARK: - Pop动画
    func popAnimation(_ context: UIViewControllerContextTransitioning) {
        
        let toVC = context.viewController(forKey: .to) as!  SetPasswordController
        let fromVC = context.viewController(forKey: .from) as! ImproveInformationController
        
        let containerView = context.containerView
        
        toVC.view.setNeedsLayout()
        toVC.view.layoutIfNeeded()
        
        toVC.registerBtn.isHidden = true
        fromVC.successBtn.isHidden = true
        fromVC.skipBtn.alpha = 1
        
        let successBtnCoppy = UIButton()
        successBtnCoppy.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 18)
        successBtnCoppy.setTitleColor(.black, for: .normal)
        successBtnCoppy.setTitle("完成", for: .normal)
        successBtnCoppy.layer.cornerRadius = 22
        successBtnCoppy.backgroundColor = UIColor.theme
        successBtnCoppy.frame = fromVC.whiteBgView.convert(fromVC.successBtn.frame, to: fromVC.view)
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(successBtnCoppy)
        
        UIView.animate(withDuration: transitionDuration(using: context), animations: {
            
            fromVC.skipBtn.alpha = 0
            successBtnCoppy.frame = toVC.whiteBgView.convert(toVC.registerBtn.frame, to: toVC.view)
            successBtnCoppy.setTitle("下一步", for: .normal)
        }) { (isAnimation) in
            
            toVC.registerBtn.isHidden = false
            fromVC.successBtn.isHidden = false
            
            successBtnCoppy.removeFromSuperview()
            context.completeTransition(!context.transitionWasCancelled)
        }
    }
}

