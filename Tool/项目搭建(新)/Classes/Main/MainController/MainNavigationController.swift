//
//  MainNavigationController.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/24.
//

import UIKit

class MainNavigationController: UIBaseNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        createAction()
    }

}

//MARK: - Action
extension MainNavigationController: UIGestureRecognizerDelegate {
    func createAction() {
        // 强制开启侧滑返回操作
        self.interactivePopGestureRecognizer?.delegate = self
        self.navigationBar.isTranslucent = false
    }
    
    /// 控制器push方法
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.children.count > 0 { // 隐藏底部导航栏
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: true)
        self.setNavigationBarHidden(false, animated: true)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    /// 重写此方法修复滑动返回时取消返回，无法再次使用滑动返回的问题
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return self.children.count > 1
    }
}
