//
//  FDMCustomButton.swift
//  教务系统
//
//  Created by 发抖喵 on 2020/4/27.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit
import SnapKit

/// 图片位置
enum FDMButtonImagePosition {
    case FDMButtomImageLeft
    case FDMButtomImageRight
    case FDMButtomImageTop
    case FDMButtomImageBottom
}

class FDMCustomButton: UIButton {
    
    /// 图片方向
    var imagePosition: FDMButtonImagePosition = .FDMButtomImageLeft
    /// 文字与图片的间距
    var imageSpacing: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentEdgeInsets = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: layout
extension FDMCustomButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard bounds != CGRect.zero else { return }
        titleLabel?.sizeToFit()
        
        let imageSize = imageView?.bounds.size
        let titleSize = titleLabel?.bounds.size
        
        guard imageSize != CGSize.zero && titleSize != CGSize.zero else { return }
        
        switch imagePosition {
        case .FDMButtomImageLeft:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -imageSpacing * 0.5, bottom: 0, right: imageSpacing * 0.5)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: imageSpacing * 0.5, bottom: 0, right: -imageSpacing * 0.5)
            break
        case .FDMButtomImageRight:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: titleSize!.width + imageSpacing * 0.5, bottom: 0, right: -titleSize!.width - imageSpacing * 0.5)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize!.width - imageSpacing * 0.5, bottom: 0, right: imageSize!.width + imageSpacing * 0.5)
            break
        case .FDMButtomImageTop:
            imageEdgeInsets = UIEdgeInsets(top: -titleSize!.height * 0.5 - imageSpacing * 0.5, left: titleSize!.width * 0.5, bottom: titleSize!.height * 0.5 + imageSpacing * 0.5, right: -titleSize!.width * 0.5)
            titleEdgeInsets = UIEdgeInsets(top: imageSize!.height * 0.5 + imageSpacing * 0.5, left: -imageSize!.width * 0.5, bottom: -imageSize!.height * 0.5 - imageSpacing * 0.5, right: imageSize!.width * 0.5)
            break
        case .FDMButtomImageBottom:
            imageEdgeInsets = UIEdgeInsets(top: titleSize!.height * 0.5 + imageSpacing * 0.5, left: titleSize!.width * 0.5, bottom: -titleSize!.height * 0.5 - imageSpacing * 0.5, right: -titleSize!.width * 0.5)
            titleEdgeInsets = UIEdgeInsets(top: -imageSize!.height * 0.5 - imageSpacing * 0.5, left: -imageSize!.width * 0.5, bottom: imageSize!.height * 0.5 + imageSpacing * 0.5, right: imageSize!.width * 0.5)
            break
        }
    }
}
