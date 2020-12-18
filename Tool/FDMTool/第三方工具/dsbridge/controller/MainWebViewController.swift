//
//  MainWebViewController.swift
//  guoyuan-civil-ios
//
//  Created by 发抖喵 on 2020/6/22.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit
import SnapKit
import WebKit

class MainWebViewController: UIViewController {
    
    let webView = DWKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        createUI()
    }
}

//MARK: UI
extension MainWebViewController {
    private func createUI() {
        self.view.addSubview(webView)
        
        webView.backgroundColor = .white
        webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
