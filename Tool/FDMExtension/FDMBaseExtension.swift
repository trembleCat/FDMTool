//
//  FDMBaseExtension.swift
//  FDMTool
//
//  Created by 发抖喵 on 2020/5/28.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit

//MARK: Base - CALayer
extension CALayer {
    func left() -> CGFloat {
        return frame.origin.x
    }
    
    func left(_ x: CGFloat) {
        frame.origin.x = x
    }
    
    func top() -> CGFloat {
        return frame.origin.y
    }
    
    func top(_ y: CGFloat) {
        frame.origin.y = y
    }
    
    func right() -> CGFloat {
        return frame.origin.x + frame.width
    }
    
    func right(_ right: CGFloat) {
        frame.origin.x = right - frame.width
    }
    
    func bottom() -> CGFloat {
        return frame.origin.y + frame.height
    }
    
    func bottom(_ bottom: CGFloat) {
        frame.origin.y = bottom - frame.height
    }
    
    func width() -> CGFloat {
        return frame.width
    }
    
    func width(_ width: CGFloat) {
        frame.size.width = width
    }
    
    func height() -> CGFloat {
        return frame.height
    }
    
    func height(_ height: CGFloat) {
        frame.size.height = height
    }
    
    func origin() -> CGPoint {
        return frame.origin
    }
    
    func origin(_ origin: CGPoint) {
        frame.origin = origin
    }
    
    func size() -> CGSize {
        return frame.size
    }
    
    func size(_ size: CGSize) {
        frame.size = size
    }
}

//MARK: Base - UIView
extension UIView {
    
    func removeAllSubviews() {
        while self.subviews.count != 0 {
            self.subviews.last?.removeFromSuperview()
        }
    }
    
    func viewController() -> UIViewController? {
        var currentView: UIView? = self
        
        while currentView != nil {
            let nextResponder = currentView?.next
            if nextResponder?.isKind(of: UIViewController.self) ?? false {
                return nextResponder as? UIViewController
            }
            
            currentView = currentView?.superview
        }
        
        return nil
    }
    
    func left() -> CGFloat {
        return frame.origin.x
    }
    
    func left(_ x: CGFloat) {
        frame.origin.x = x
    }
    
    func top() -> CGFloat {
        return frame.origin.y
    }
    
    func top(_ y: CGFloat) {
        frame.origin.y = y
    }
    
    func right() -> CGFloat {
        return frame.origin.x + frame.width
    }
    
    func right(_ right: CGFloat) {
        frame.origin.x = right - frame.width
    }
    
    func bottom() -> CGFloat {
        return frame.origin.y + frame.height
    }
    
    func bottom(_ bottom: CGFloat) {
        frame.origin.y = bottom - frame.height
    }
    
    func width() -> CGFloat {
        return frame.width
    }
    
    func width(_ width: CGFloat) {
        frame.size.width = width
    }
    
    func height() -> CGFloat {
        return frame.height
    }
    
    func height(_ height: CGFloat) {
        frame.size.height = height
    }
    
    func centernX() -> CGFloat {
        return center.x
    }
    
    func centernX(_ x: CGFloat) {
        center.x = x
    }
    
    func centerY() -> CGFloat {
        return center.y
    }
    
    func centerY(_ y: CGFloat) {
        center.y =  y
    }
    
    func origin() -> CGPoint {
        return frame.origin
    }
    
    func origin(_ origin: CGPoint) {
        frame.origin = origin
    }
    
    func size() -> CGSize {
        return frame.size
    }
    
    func size(_ size: CGSize) {
        frame.size = size
    }
}

//MARK: Base - NSMutableAttributedString
extension NSMutableAttributedString {
    func lengthRange() -> NSRange {
        return NSRange(location: 0, length: self.length)
    }
    
    /// 判断长度是否溢出 并返回Range
    func lengthIsOverflow(range: NSRange, key: String = "AttributedString" ) -> NSRange {
        let newRange = (range.location == -1 && range.length == -1) ? lengthRange() : range
        guard (range.location + range.length) > self.length else { return newRange }
        
        #if DEBUG
            fatalError("【Error：" + key + " - Range长度溢出】")
        #else
            return NSRange(location: range.location, length: self.length - range.location)
        #endif
    }
    
    /// 名称 - any
    func name(_ name: String, value: Any, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key(name), value: value, range: lengthIsOverflow(range: range, key: "name"))
    }
    
    /// 字体
    func font(_ font: UIFont, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.font, value: font, range: lengthIsOverflow(range: range, key: "font"))
    }
    
    /// 绘图的风格
    func paragraphStyle(_ style: NSParagraphStyle, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: lengthIsOverflow(range: range, key: "paragraphStyle"))
    }
    
    /// 文字颜色
    func foregroundColor(_ color: UIColor, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: lengthIsOverflow(range: range, key: "foregroundColor"))
    }
    
    /// 背景颜色
    func backgroundColor(_ color: UIColor, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.backgroundColor, value: color, range: lengthIsOverflow(range: range, key: "backgroundColor"))
    }
    
    /// 字符连体
    func ligature(_ value: NSNumber, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.ligature, value: value, range: lengthIsOverflow(range: range, key: "ligature"))
    }
    
    /// 字符间隔
    func kern(_ value: NSNumber, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.kern, value: value, range: lengthIsOverflow(range: range, key: "kern"))
    }
    
    /// 删除线（0-7：单线，值越大，线越粗，7-15：双线，同理）或者枚举
    func strikethroughStyle(_ value: NSNumber, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.strikethroughStyle, value: value, range: lengthIsOverflow(range: range, key: "strikethroughStyle"))
    }
    
    /// 下划线（0-7：单线，值越大，线越粗，7-15：双线，同理）或者枚举
    func underlineStyle(_ value: NSNumber, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.underlineStyle, value: value, range: lengthIsOverflow(range: range, key: "underlineStyle"))
    }
    
    /// 描边颜色
    func strokeColor(_ color: UIColor, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.strokeColor, value: color, range: lengthIsOverflow(range: range, key: "strokeColor"))
    }
    
    /// 描边宽度
    func strokeWidth(_ value: NSNumber, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.strokeWidth, value: value, range: lengthIsOverflow(range: range, key: "strokeWidth"))
    }
    
    /// 阴影
    func shadow(_ value: NSShadow, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.shadow, value: value, range: lengthIsOverflow(range: range, key: "shadow"))
    }
    
    /// 文字效果
    func textEffect(_ text: NSString, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.textEffect, value: text, range: lengthIsOverflow(range: range, key: "textEffect"))
    }
    
    /// 附属(可以用来添加图片)
    func attachment(_ chment: NSTextAttachment, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.attachment, value: chment, range: lengthIsOverflow(range: range, key: "attachment"))
    }
    
    /// 链接
    func link(_ url: String, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.link, value: url, range: lengthIsOverflow(range: range, key: "link"))
    }
    
    /// 基线偏移（正值向上，负值向下）
    func baselineOffset(_ offset: NSNumber, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.baselineOffset, value: offset, range: lengthIsOverflow(range: range, key: "baselineOffset"))
    }
    
    /// 下划线颜色
    func underlineColor(_ color: UIColor, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.underlineColor, value: color, range: lengthIsOverflow(range: range, key: "underlineColor"))
    }
    
    /// 删除线颜色
    func strikethroughColor(_ color: UIColor, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.strikethroughColor, value: color, range: lengthIsOverflow(range: range, key: "strikethroughColor"))
    }
    
    /// 字体斜体（正值左倾，负值右倾）
    func obliqueness(_ value: NSNumber, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.obliqueness, value: value, range: lengthIsOverflow(range: range, key: "obliqueness"))
    }
    
    /// 字体横线拉伸 （正值拉伸，负值压缩）
    func expansion(_ value: NSNumber, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.expansion, value: value, range: lengthIsOverflow(range: range, key: "expansion"))
    }
    
    /// 字体书写方向 NSWritingDirection and NSWritingDirectionFormatType
    func writingDirection(_ ary: NSArray, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.writingDirection, value: ary, range: lengthIsOverflow(range: range, key: "writingDirection"))
    }
    
    /// 文字横竖排版 值为0或1，0横排，1竖排，目前可能只支持横排
    func verticalGlyphForm(_ value: NSNumber, range: NSRange = NSRange(location: -1, length: -1)) {
        self.addAttribute(NSAttributedString.Key.verticalGlyphForm, value: value, range: lengthIsOverflow(range: range, key: "verticalGlyphForm"))
    }
}
