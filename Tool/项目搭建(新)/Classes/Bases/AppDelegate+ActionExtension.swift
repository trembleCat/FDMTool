//
//  AppDelegateExtension.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/24.
//

import UIKit

extension AppDelegate {
    func createWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainTabBarController()
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
    }
}
