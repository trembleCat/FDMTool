//
//  FDMAttributedStringExtension.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/24.
//

import UIKit

//MARK: Base - NSMutableAttributedString
extension NSMutableAttributedString {
    
    /**
     最大Range
     */
    func lengthRange() -> NSRange {
        return NSRange(location: 0, length: self.length)
    }
    
    /**
     判断长度是否溢出 并返回Range
     */
    func lengthIsOverflow(range: NSRange, key: String = "AttributedString" ) -> NSRange {
        let newRange = (range.location == -1 && range.length == -1) ? lengthRange() : range
        guard (range.location + range.length) > self.length else { return newRange }
        
        #if DEBUG
            fatalError("【Error：" + key + " - Range长度溢出】")
        #else
            return NSRange(location: range.location, length: self.length - range.location)
        #endif
    }
    
    /**
     名称 - any
     */
    func addName(_ name: String, value: Any, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key(name), value: value, range: lengthIsOverflow(range: range, key: "name"))
    }
    
    /**
     字体
     */
    func addFont(_ font: UIFont, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.font, value: font, range: lengthIsOverflow(range: range, key: "font"))
    }
    
    /**
     绘图的风格(行间距)
     */
    func addParagraphStyle(_ style: NSMutableParagraphStyle, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: lengthIsOverflow(range: range, key: "paragraphStyle"))
    }
    
    /**
     文字颜色
     */
    func addForegroundColor(_ color: UIColor, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: lengthIsOverflow(range: range, key: "foregroundColor"))
    }
    
    /**
     背景颜色
     */
    func addBackgroundColor(_ color: UIColor, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.backgroundColor, value: color, range: lengthIsOverflow(range: range, key: "backgroundColor"))
    }
    
    /**
     字符连体
     */
    func addLigature(_ value: NSNumber, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.ligature, value: value, range: lengthIsOverflow(range: range, key: "ligature"))
    }
    
    /**
     字符间隔
     */
    func addKern(_ value: NSNumber, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.kern, value: value, range: lengthIsOverflow(range: range, key: "kern"))
    }
    
    /**
     删除线（0-7：单线，值越大，线越粗，7-15：双线，同理）或者枚举
     */
    func addStrikethroughStyle(_ value: NSNumber, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.strikethroughStyle, value: value, range: lengthIsOverflow(range: range, key: "strikethroughStyle"))
    }
    
    /**
     下划线（0-7：单线，值越大，线越粗，7-15：双线，同理）或者枚举
     */
    func addUnderlineStyle(_ value: NSNumber, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.underlineStyle, value: value, range: lengthIsOverflow(range: range, key: "underlineStyle"))
    }
    
    /**
     描边颜色
     */
    func addStrokeColor(_ color: UIColor, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.strokeColor, value: color, range: lengthIsOverflow(range: range, key: "strokeColor"))
    }
    
    /**
     描边宽度
     */
    func addStrokeWidth(_ value: NSNumber, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.strokeWidth, value: value, range: lengthIsOverflow(range: range, key: "strokeWidth"))
    }
    
    /**
     阴影
     */
    func addShadow(_ value: NSShadow, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.shadow, value: value, range: lengthIsOverflow(range: range, key: "shadow"))
    }
    
    /**
     文字效果
     */
    func addTextEffect(_ text: NSString, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.textEffect, value: text, range: lengthIsOverflow(range: range, key: "textEffect"))
    }
    
    /**
     附属(可以用来添加图片)
     */
    func addAttachment(_ chment: NSTextAttachment, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.attachment, value: chment, range: lengthIsOverflow(range: range, key: "attachment"))
    }
    
    /**
     链接
     */
    func addLink(_ url: String, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.link, value: url, range: lengthIsOverflow(range: range, key: "link"))
    }
    
    /**
     基线偏移（正值向上，负值向下）
     */
    func addBaselineOffset(_ offset: NSNumber, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.baselineOffset, value: offset, range: lengthIsOverflow(range: range, key: "baselineOffset"))
    }
    
    /**
     下划线颜色
     */
    func addUnderlineColor(_ color: UIColor, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.underlineColor, value: color, range: lengthIsOverflow(range: range, key: "underlineColor"))
    }
    
    /**
     删除线颜色
     */
    func addStrikethroughColor(_ color: UIColor, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.strikethroughColor, value: color, range: lengthIsOverflow(range: range, key: "strikethroughColor"))
    }
    
    /**
     字体斜体（正值左倾，负值右倾）
     */
    func addObliqueness(_ value: NSNumber, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.obliqueness, value: value, range: lengthIsOverflow(range: range, key: "obliqueness"))
    }
    
    /**
     字体横线拉伸 （正值拉伸，负值压缩）
     */
    func addExpansion(_ value: NSNumber, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.expansion, value: value, range: lengthIsOverflow(range: range, key: "expansion"))
    }
    
    /**
     字体书写方向 NSWritingDirection and NSWritingDirectionFormatType
     */
    func addWritingDirection(_ ary: NSArray, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.writingDirection, value: ary, range: lengthIsOverflow(range: range, key: "writingDirection"))
    }
    
    /**
     文字横竖排版 值为0或1，0横排，1竖排，目前可能只支持横排
     */
    func addVerticalGlyphForm(_ value: NSNumber, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.verticalGlyphForm, value: value, range: lengthIsOverflow(range: range, key: "verticalGlyphForm"))
    }
}

