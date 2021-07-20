//
//  FDMViewExtension.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/24.
//

/*==================
 1.【Class】创建毛玻璃
 2.截取View作为图片
 3.通过Bezier创建某个圆角
 4.通过 UIGraphics 绘制圆角并返回image
 5.通过 UIGraphics 绘制带圆角的纯色背景
==================*/

import UIKit

//MARK: UIView
extension UIView {
    
    /**
     1.创建毛玻璃 在contentView上添加子视图
     */
    class func groundGlass( style:UIBlurEffect.Style) -> UIVisualEffectView{
        let blurEddect = UIBlurEffect(style:style)
        let blurView = UIVisualEffectView(effect: blurEddect)
        return blurView
    }
    
    /**
     2.截取View作为图片
     */
    func toImage() -> UIImage? {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /**
     3.通过Bezier创建某个圆角 -corner:某个角或多个角,多个角传UIRectCorner(rawValue:),四个角传.allCorners
     
     注意：会降低帧率，但不会占用CPU 与 内存
     */
    func roundedCorners(corners:UIRectCorner, cornerRadius:Double, viewSize: CGSize){
        let cornerLaye = CAShapeLayer.init()
        let maskPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: viewSize), byRoundingCorners: corners, cornerRadii:CGSize(width: cornerRadius, height: cornerRadius))
        cornerLaye.path = maskPath.cgPath
        cornerLaye.frame = CGRect(origin: CGPoint.zero, size: viewSize)
        self.layer.mask = cornerLaye
    }
    
    /**
     4.通过 UIGraphics 绘制圆角并返回image
     
     请通过 layer.contents 设置 image.cgimage, 并清空背景颜色
     如果是 UIimagView 请直接使用图片
     
     注意：会消耗CPU与内存，但保持帧率
     */
    func drawRoundedCorners(_ corners:UIRectCorner, cornerRadius:Double, viewSize: CGSize, complete: @escaping (UIImage?) -> ()) {
        
        let size = viewSize
        let currentLayer = self.layer
        DispatchQueue.global().async {
            let path = UIBezierPath(roundedRect: .init(origin: .zero, size: size),
                                    byRoundingCorners: corners,
                                    cornerRadii: .init(width: cornerRadius, height: cornerRadius))
            
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
            let context = UIGraphicsGetCurrentContext()
            guard context != nil else {
                UIGraphicsEndImageContext()
                return
            }
            
            context?.addPath(path.cgPath)
            context?.clip()
            currentLayer.render(in: context!)
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            DispatchQueue.main.async {
                complete(image)
            }
        }
    }
    
    
    /**
     5.通过 UIGraphics 绘制带圆角的纯色背景
     
     注意：会消耗CPU与内存
     */
    func drawBackgroundColorRoundedCorners(_ corners:UIRectCorner, cornerRadius:Double, viewSize: CGSize, color: UIColor) {
        let size = viewSize
        DispatchQueue.global().async {
            let rect = CGRect.init(origin: .zero, size: size)
            let path = UIBezierPath(roundedRect: rect,
                                    byRoundingCorners: corners,
                                    cornerRadii: .init(width: cornerRadius, height: cornerRadius))
            
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
            let context = UIGraphicsGetCurrentContext()
            
            guard context != nil else {
                UIGraphicsEndImageContext()
                return
            }
            
            context?.addPath(path.cgPath)
            context?.clip()
            
            context?.setFillColor(color.cgColor)
            context?.fill(rect)
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            DispatchQueue.main.async { [weak self] in
                self?.backgroundColor = .clear
                self?.layer.contents = image?.cgImage
            }
        }
    }
}


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

//MARK: Base - UIView
extension UIView {
    
    /**
     删除所有子控件
     */
    func removeAllSubviews() {
        while self.subviews.count != 0 {
            self.subviews.last?.removeFromSuperview()
        }
    }
    
    /**
     获取View所属控制器
     */
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
    
    var left: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }
    
    var top: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
    
    var right: CGFloat {
        get {
            return frame.origin.x + frame.width
        }
        set {
            frame.origin.x = newValue - frame.width
        }
    }
    
    var bottom: CGFloat {
        get {
            return frame.origin.y + frame.height
        }
        set {
            frame.origin.y = newValue - frame.height
        }
    }
    
    var width: CGFloat {
        get {
            return frame.width
        }
        set {
            frame.size.width = newValue
        }
    }

    var height: CGFloat {
        get {
            return frame.height
        }
        set {
            frame.size.height = newValue
        }
    }
    
    var center_x: CGFloat {
        get {
            return center.x
        }
        set {
            center.x = newValue
        }
    }
    
    var center_y: CGFloat {
        get {
            return center.y
        }
        set {
            center.y = newValue
        }
    }
    
    var origin: CGPoint {
        get {
            return frame.origin
        }
        set {
            frame.origin = newValue
        }
    }
    
    var size: CGSize {
        get {
            return frame.size
        }
        set {
            frame.size = newValue
        }
    }
}

