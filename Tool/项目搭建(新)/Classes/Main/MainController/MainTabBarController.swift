//
//  MainTabBarController.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/24.
//

import UIKit

class MainTabBarController: UIBaseTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createChildren()
        setTabBarStyle()
        getUserConfig()
    }
}

extension MainTabBarController {
    
    /**
     设置TabBarChildren
     */
    func createChildren() {
        for item in AppConfigure.shared.TabBarItems() {
            let controller = item.viewController
            controller.title = item.title
            controller.tabBarItem.image = item.normalImage
            controller.tabBarItem.selectedImage = item.selectImage
            
            let childrenController = MainNavigationController(rootViewController: controller)
            self.addChild(childrenController)
        }
    }
    
    /// 设置tabbar样式
    func setTabBarStyle() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.gray], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.orange], for: .selected)
    }
    
    /// 获取用户信息
    func getUserConfig() {
        
    }
}
