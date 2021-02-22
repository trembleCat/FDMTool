//
//  RegisterController+TransitionExtension.swift
//  SXReaderS
//
//  Created by 发抖喵 on 2020/9/4.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import UIKit

//MARK: - UINavigationControllerDelegate
// 转场时设置Navigation.delegate = 需要动画的控制器， 不需要动画时设置为nil
// 实现代理与下边的方法，返回transitionAnimation对象，并在该对象实现相应动画功能

extension RegisterController: UINavigationControllerDelegate {
    
    /**
     返回处理push/pop动画过渡的对象
     */
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
            self.transitionAnimation.transitionType = .Push
        }else if operation == .pop{
            self.transitionAnimation.transitionType = .Pop
        }
        
        return self.transitionAnimation
    }
    
    /**
     返回处理push/pop手势过渡的对象 这个代理方法依赖于上方的方法 ，这个代理实际上是根据交互百分比来控制上方的动画过程百分比
     */
//    func navigationController(_ navigationController: UINavigationController,
//                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        
//    }
}
