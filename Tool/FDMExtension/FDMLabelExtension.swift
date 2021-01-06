//
//  FDMLabelExtension.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2021/1/4.
//

import UIKit


//MARK: - UILabel
extension UILabel {
    
    /**
     设置字体，字号，颜色
     */
    func setFontName(_ fontNmae: String, fontSize: CGFloat, fontColor: UIColor = .black){
        self.font = UIFont(name: fontNmae, size: fontSize)
        self.textColor = fontColor
    }
}
