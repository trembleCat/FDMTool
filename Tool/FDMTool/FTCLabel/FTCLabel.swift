//
//  FTCLabel.swift
//  FDMTouchLabel
//
//  Created by 发抖喵 on 2020/10/28.
//  优化到子线程

import UIKit

class FTCLabel: UILabel {
    
    struct attrModel {  // 多属性文本
        var name: NSAttributedString.Key
        var value: Any
        var range: NSRange
        
        init(name: NSAttributedString.Key, value: Any , range: NSRange) {
            self.name = name
            self.value = value
            self.range = range
        }
    }
    
    // ctline数组
    var ctLineAry: NSArray?
    
    // ctLineRect数组
    var ctLineRectAry = [CGRect]()
    
    // 比对内容数组
    var matchingTextAry: [String]
    
    // 比对内容range数组 matchingRangeAry.count = matchingTextAry.count
    var matchingRangeAry = [[NSRange]]()
    
    // 比对内容颜色
    var matchingColor = UIColor.orange
    
    // 点击文本的回调
    var clickTextBlock: ((String) -> ())?
    
    // 其他文本属性
    var attrs: [attrModel]?
    
    /**
     初始化
     
     @param matchingTextAry 需要比对的内容数组
     */
    init(matchingTextAry: [String]) {
        self.matchingTextAry = matchingTextAry
        super.init(frame: .zero)
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        self.beginDrawText(rect: rect)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isUserInteractionEnabled = false
        if let position = touches.first?.location(in: self) {
            if ctLineAry != nil && ctLineRectAry.count > 0 {
                
                let currentBounds = self.bounds
                DispatchQueue.global().async { [weak self] in
                    self?.self.userClickPosition(position, bounds: currentBounds)
                }
            }
        }
        
        self.isUserInteractionEnabled = true
    }
}

//MARK: - Action
extension FTCLabel {
    func beginDrawText(rect: CGRect) {
        guard self.text != nil else { return }
        
        // 获取上下文
        let context = UIGraphicsGetCurrentContext()
        
        guard context != nil else { return }
        
        // 1 ---------------------- 翻转坐标系
            // 1. 还原初始值
        context?.textMatrix = CGAffineTransform.identity
            // 2. 向上移动一个屏幕高度
        context?.translateBy(x: 0, y: rect.height)
            // 3. 沿x轴翻转
        context?.scaleBy(x: 1, y: -1)
        
        // 2 ---------------------- 设置绘制范围
        let path = CGMutablePath()
        path.addRect(rect)
        
        // 3 ---------------------- 设置文本属性
        let matchingAttrString = NSMutableAttributedString(string: text!)
        matchingAttrString.addAttributes([NSAttributedString.Key.font : self.font], range: .init(location: 0, length: matchingAttrString.length))
        matchingAttrString.addAttributes([NSAttributedString.Key.foregroundColor : self.textColor], range: .init(location: 0, length: matchingAttrString.length))
        
        if attrs != nil {
            for attr in attrs! {
                matchingAttrString.addAttribute(attr.name, value: attr.value, range: attr.range)
            }
        }
        
        for matchingText in matchingTextAry {   // 修改比对数据颜色
            let ranges = regularExpressionOfRegular("[\(matchingText)]{\(matchingText.count)}", with: matchingAttrString.string)
            
            if ranges?.count ?? 0 > 0 { // 保存range
                matchingRangeAry.append(ranges!)
                
                for item in ranges! {
                    matchingAttrString.addAttributes([NSAttributedString.Key.foregroundColor : matchingColor], range: item)
                }
            }
        }
        
        // 4 ----------------------- 根据AttString生成CTFramesetterRef
        let frameSetter = CTFramesetterCreateWithAttributedString(matchingAttrString)
        let ctFrame = CTFramesetterCreateFrame(frameSetter, .init(location: 0, length: matchingAttrString.length), path, nil)
        
        // 5. 获取CTLine
        ctLineAry = CTFrameGetLines(ctFrame) as NSArray
        
        let origins = UnsafeMutablePointer<CGPoint>.allocate(capacity: 20)  // 每一行的基线原点
        CTFrameGetLineOrigins(ctFrame, .init(location: 0, length: 0), origins)
        
        let lineAscent = UnsafeMutablePointer<CGFloat>.allocate(capacity: 20)   // 上行高度
        let lineDescent = UnsafeMutablePointer<CGFloat>.allocate(capacity: 20)  // 下行高度
        let lineLeading = UnsafeMutablePointer<CGFloat>.allocate(capacity: 20)  // 行高
        
        var ctLine_i = 0
        for ctLine in ctLineAry ?? NSArray() {

            /* 获取并修改渲染位置，默认左下开始渲染 */
            CTLineGetTypographicBounds(ctLine as! CTLine, lineAscent, lineDescent, lineLeading)
            context?.textPosition = CGPoint(x: origins[ctLine_i].x, y: origins[ctLine_i].y - lineDescent.pointee - CTFontGetDescent(UIFont.systemFont(ofSize: 16)))

            if (self.numberOfLines - 1) <= 0 || (self.numberOfLines - 1) > 0 && ctLine_i <= (self.numberOfLines - 1) { // 渲染全部
                let rect = CTLineGetImageBounds(ctLine as! CTLine, context)
                ctLineRectAry.append(rect)
                
                CTLineDraw(ctLine as! CTLine, context!)
            }

            ctLine_i += 1
        }
        
        origins.deallocate()
        lineAscent.deallocate()
        lineDescent.deallocate()
        lineLeading.deallocate()
    }
    
    /**
     点击位置判断
     */
    func userClickPosition(_ position: CGPoint, bounds: CGRect) {
        
        // 转换为左下角原点
        let NSCoordinate = CGPoint(x: position.x, y: bounds.height - position.y)
        
        var ctLine_i = 0
        for ctLineRect in ctLineRectAry {
            
            // 判断是否点击在当前行内
            if NSCoordinate.y > ctLineRect.origin.y && NSCoordinate.y < (ctLineRect.origin.y + ctLineRectAry[ctLine_i].height) {
                
                // 获取点击文字的Index
                let index = CTLineGetStringIndexForPosition(ctLineAry![ctLine_i] as! CTLine, position)
                
                // 判断点击位置是否在比对范围内
                var i = 0
                for rangeAry in matchingRangeAry {
                    
                    for range in rangeAry {
                        if index >= range.location && index <= (range.location + range.length) {    // 在点击范围
                            
                            DispatchQueue.main.async {[weak self] in
                                self?.clickTextBlock?(self?.matchingTextAry[i] ?? "")
                            }
                            
                            return
                        }
                    }
                    
                    i += 1
                }
            }
            
            ctLine_i += 1
        }
    }
    
    /**
     获取匹配字符的Range
     */
    func regularExpressionOfRegular(_ regular:String, with text: String) -> [NSRange]?{
        do {
            let regex: NSRegularExpression = try NSRegularExpression(pattern: regular, options: [])
            let matches = regex.matches(in: text, options: [], range: NSMakeRange(0, text.count))
            
            var data: [NSRange] = [NSRange]()  //符合匹配的数组Range
            for item in matches {
                data.append(item.range as NSRange)
            }
            
            return data
        }
        catch {
            return nil
        }
    }
}
