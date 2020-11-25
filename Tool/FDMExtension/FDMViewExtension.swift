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
==================*/

import UIKit

//MARK: UIView
extension UIView {
    
    /**
     1.创建毛玻璃
     */
    class func groundGlass(style:UIBlurEffect.Style) -> UIView{
        let blurEddect = UIBlurEffect(style:style)
        let blurView = UIVisualEffectView(effect: blurEddect)
        return blurView.contentView
    }
    
    /**
     2.截取View作为图片
     */
    func toImage() -> UIImage? {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /**
     3.通过Bezier创建某个圆角 -corner:某个角或多个角,多个角传UIRectCorner(rawValue:),四个角传.allCorners
     */
    func roundedCorners(corners:UIRectCorner, cornerRadius:Double, viewSize: CGSize){
        let cornerLaye = CAShapeLayer.init()
        let maskPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: viewSize), byRoundingCorners: corners, cornerRadii:CGSize(width: cornerRadius, height: cornerRadius))
        cornerLaye.path = maskPath.cgPath
        cornerLaye.frame = CGRect(origin: CGPoint.zero, size: viewSize)
        self.layer.mask = cornerLaye
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

