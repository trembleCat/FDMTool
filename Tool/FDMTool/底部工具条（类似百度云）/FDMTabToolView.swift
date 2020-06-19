//
//  FDMTabToolView.swift
//  Apple
//
//  Created by 发抖喵 on 2020/3/2.
//  Copyright © 2020 yunzainfo. All rights reserved.
//

import UIKit

class FDMTabToolView: UIView {
    
    var count = 5
    var toolBar: UIView?
    let tool = UIView()
    
    var items = Array<FDMCustomButton>()
    var barStack: UIStackView?
    
    init(count: Int) {
        self.count = count
        super.init(frame: CGRect.zero)
        
        createUI()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        
        createUI()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: UI
extension FDMTabToolView {
    func createUI() {
        
        // 工具条背景(适应全面屏)
        toolBar = UIView()
        self.addSubview(toolBar!)
        toolBar!.backgroundColor = Settings.share.mainColor()
        toolBar!.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
        
        // 工具条
        toolBar?.addSubview(tool)
        tool.backgroundColor = Settings.share.mainColor()
        tool.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(FDMQuick.screenWithTabBarHeight())
        }
        
        for _ in 0..<count {
            let item = FDMCustomButton()
            item.fontSize = 12
            item.spacing = 5
            item.imageSpacingTop = 5
            item.imageWidth = 25
            item.imageHeight = 25
            item.titleLabel.textColor = .white
            
            items.append(item)
        }
        barStack = UIStackView(arrangedSubviews: items)
        barStack?.alignment = .fill
        barStack?.axis = .horizontal
        barStack?.distribution = .fillEqually
        
        tool.addSubview(barStack!)
        barStack?.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
    }
}

//MARK: Action
extension FDMTabToolView {
    /// 设置标题
    func addTitles(_ titles:[String]) {
        var i = 0
        for item in items{
            item.titleLabel.text = titles[i]
            i += 1
        }
    }
    
    /// 设置图片
    func addImages(_ images:[UIImage?]) {
        var i = 0
        for item in items{
            item.titleImage.image = images[i]
            i += 1
        }
    }
    
    /// 设置点击事件
    func addTarget(target:Any,_ actions:[Selector]) {
        var i = 0
        for item in items{
            item.addTarget(target: target, select: actions[i])
            i += 1
        }
    }
    
}
