//
//  MainNavigationController.swift
//  iOS-Edumanage
//
//  Created by 发抖喵 on 2020/4/16.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUI()
        createAction()
    }
}

//MARK: UI + Action
extension MainNavigationController {
    func createUI() {
        let bar = UINavigationBar.appearance()
        bar.setBackgroundImage(Settings.share.mainColor().toImage(), for: .default)
        bar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
    
    func createAction() {
        // 强制开启侧滑返回操作
        interactivePopGestureRecognizer?.delegate = self
    }
    
    /// 创建返回按钮
    func createBarBackButton() -> UIBarButtonItem {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "back_white"), for: .normal)
        backButton.addTarget(self, action: #selector(clickBack), for: .touchUpInside)
        
        return UIBarButtonItem(customView: backButton)
    }
}

//MARK: override
extension MainNavigationController: UIGestureRecognizerDelegate {
    
    /// 控制器push方法
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.children.count > 0 { // 隐藏底部导航栏
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = createBarBackButton()
        }
        
        super.pushViewController(viewController, animated: true)
        self.setNavigationBarHidden(false, animated: true)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    /// 重写此方法修复滑动返回时取消返回，无法再次使用滑动返回的问题
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return self.children.count > 1
    }
    
    /// 返回
    @objc func clickBack() {
        self.popViewController(animated: true)
    }
}
