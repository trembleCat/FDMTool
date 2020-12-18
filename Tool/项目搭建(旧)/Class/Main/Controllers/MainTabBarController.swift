//
//  MainTabBarController.swift
//  iOS-Edumanage
//
//  Created by 发抖喵 on 2020/4/16.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSubViewControllers()
        setTabBarStyle()
        getUserConfig()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppConfig.shared.isInRootVC = true
    }
    
    /// 初始化控制器
    func initSubViewControllers() {
        for item in Settings.share.TabBarItems() {
            
            let viewController = item.viewController
            viewController.title = item.title
            viewController.tabBarItem.image = UIImage(named: item.normalImageName)
            viewController.tabBarItem.selectedImage = UIImage(named: item.selectedImageName)
            
            let navgationVC = MainNavigationController(rootViewController: viewController)
            
            self.addChild(navgationVC)
        }
    }
    
    /// 设置tabbar样式
    func setTabBarStyle() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.gray], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : Settings.share.mainColor()], for: .selected)
    }
    
    /// 获取用户信息
    func getUserConfig() {
        YZNetworkManager.shared.getUserConfig(param: YZUserConfigParam(), { (resp) in
            FDMTool.LogWithNetwork(title: "获取用户信息", message: resp, isSuccess: true)
            
            let data = YZUserConfigData(JSONString: resp)
            AppConfig.shared.saveUserConfig(data)
        }) { (err, code) in
            FDMTool.LogWithNetwork(title: "获取用户信息\(code)", message: err, isSuccess: false)
        }
    }
}
