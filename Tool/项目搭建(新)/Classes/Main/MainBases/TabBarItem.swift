//
//  TabBarItem.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/24.
//

import UIKit

//MARK: - TabBarItems协议
protocol TabBarItemsDelegate {
    func TabBarItems() -> [TabBarItem]
}

//MARK: - 初始化TabBarItem
class TabBarItem: NSObject {
    var title: String
    var selectImage: UIImage?
    var normalImage: UIImage?
    var viewController: UIBaseViewController
    
    init(title: String, selectImage: UIImage?, normalImage: UIImage?, viewController: UIBaseViewController) {
        self.title = title
        self.selectImage = selectImage
        self.normalImage = normalImage
        self.viewController = viewController
    }
}
