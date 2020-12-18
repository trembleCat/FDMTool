//
//  UIBaseViewController.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/24.
//

import UIKit
import SnapKit

class UIBaseViewController: UIViewController {
    public var name: String {"UIBaseViewController"}

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    deinit {
        FLog(title: "销毁控制器 - \(name)", message: "销毁文件名 - \(self.classForCoder)")
    }
}

//MARK: - Action
extension UIBaseViewController {
    
    /**
     设置显示或隐藏导航栏
     */
    func setNavigationBarHidden(_ hidden: Bool, animated: Bool){
        self.navigationController?.setNavigationBarHidden(hidden, animated: animated)
    }
}
