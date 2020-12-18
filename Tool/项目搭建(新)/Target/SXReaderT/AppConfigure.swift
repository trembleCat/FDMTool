//
//  AppConfigure.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/23.
//

import UIKit

class AppConfigure: NSObject {
    static let shared = AppConfigure()
    let isDebug = true  // 是否为测试环境
}

extension AppConfigure: TabBarItemsDelegate {
    func TabBarItems() -> [TabBarItem] {
        let home = TabBarItem(title: "首页",
                              selectImage: UIImage.init(named: "tab_home_Selected"),
                              normalImage: UIImage.init(named: "tab_home"),
                              viewController: HomeController())
        
        let shelf = TabBarItem(title: "书架",
                               selectImage: UIImage.init(named: "tab_shelf_Selected"),
                               normalImage: UIImage.init(named: "tab_shelf"),
                               viewController: ShelfController())
        
        let Assignment = TabBarItem(title: "任务",
                               selectImage: UIImage.init(named: "tab_assignment_Selected"),
                               normalImage: UIImage.init(named: "tab_assignment"),
                               viewController: AssignmentController())
        
        let discuss = TabBarItem(title: "圈子",
                               selectImage: UIImage.init(named: "tab_discuss_Selected"),
                               normalImage: UIImage.init(named: "tab_discuss"),
                               viewController: DiscussController())
        
        let mine = TabBarItem(title: "我的",
                               selectImage: UIImage.init(named: "tab_mine_Selected"),
                               normalImage: UIImage.init(named: "tab_mine"),
                               viewController: MineController())
        
        return [home, shelf, Assignment, discuss, mine]
    }
}
