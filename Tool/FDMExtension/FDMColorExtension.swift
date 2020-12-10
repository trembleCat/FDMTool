//
//  FDMColorExtension.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/24.
//

/*==================
 0.【Class】适配暗黑模式颜色
 1.【Class】RGB颜色快捷方式
 2.【Class】十六进制RGB
 3.【Class】随机色
 4.【Class】创建渐变色Layer
 5.获取当前颜色的rgb值
 6.通过颜色返回一张图片
==================*/

import UIKit

//MARK: UIColor
extension UIColor {
    
    /**
     0.适配暗黑模式颜色
     */
    class func colorWithLight(_ lightColor: UIColor, Dark darkColor: UIColor?) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traitCollection) -> UIColor in
                if let darkColor = darkColor, traitCollection.userInterfaceStyle == .dark {
                    return darkColor
                } else {
                    return lightColor
                }
            }
        } else {
            return lightColor
        }
    }
    
    /**
     1.RGB颜色快捷方式
     */
    class func RGBA(r:Float,g:Float,b:Float,a:CGFloat = 1) -> UIColor{
        return UIColor(red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: a)
    }
    
    /**
     2.十六进制RGB
     */
    class func Hex(_ hex: String, alpha:CGFloat = 1) -> UIColor {
        // 去除空格等
        var cString: String = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        // 去除#
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        // 必须为6位
        if (cString.count != 6) {
            return UIColor.gray
        }
        // 红色的色值
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        // 字符串转换
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    /**
     3.随机色
     */
    class func random() -> UIColor {
        let red = CGFloat(arc4random()%256)/255.0
        let green = CGFloat(arc4random()%256)/255.0
        let blue = CGFloat(arc4random()%256)/255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    /**
     4.创建渐变色Layer  frame: layer大小  colors:渐变颜色数组  pointAry:[渐变起点0，渐变终点1] locations: 按照值颜色变化[0 - 1]
     */
    class func gradationLayer(frame:CGRect,colors:Array<CGColor>,points:Array<CGPoint>,locations:Array<NSNumber>) -> CAGradientLayer{
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = colors
        gradientLayer.startPoint = points.first ?? CGPoint(x: 0,y: 0)
        gradientLayer.endPoint = points.last ?? CGPoint(x: 1,y: 1)
        gradientLayer.locations = locations
        
        return gradientLayer
    }
    
    /**
     5.获取当前颜色的rgb值
     */
    func colorWithRGB() -> Array<CGFloat>{
        let rgbValue = String(format: "%@", self)
        let regArr = rgbValue.components(separatedBy:" ")
        
        var getR:Float?
        var getG:Float?
        var getB:Float?
        var getA:Float?
        
        if regArr.count == 3 {
            getR = (regArr[1] as NSString).floatValue
            getG = (regArr[1] as NSString).floatValue
            getB = (regArr[1] as NSString).floatValue
            getA = (regArr[2] as NSString).floatValue
        }else{
            getR = (regArr[1] as NSString).floatValue
            getG = (regArr[2] as NSString).floatValue
            getB = (regArr[3] as NSString).floatValue
            getA = (regArr[4] as NSString).floatValue
        }
        
        return [CGFloat(getR!),CGFloat(getG!),CGFloat(getB!),CGFloat(getA!)]
    }
    
    /**
     6.通过颜色返回一张图片
     */
    func toImage() -> UIImage {
        //创建1像素区域并开始图片绘图
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        
        //创建画板并填充颜色和区域
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(self.cgColor)
        context!.fill(rect)
        
        //从画板上获取图片并关闭图片绘图
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
}

//MARK: CGColor
extension CGColor {
    
    /**
     1.RGB颜色快捷方式
     */
    class func RGBA(r:Float,g:Float,b:Float,a:CGFloat = 1) -> CGColor{
        return UIColor.RGBA(r: r, g: g, b: b, a: a).cgColor
    }
    
    /**
     2.十六进制RGB
     */
    class func Hex(_ hex: String, alpha:CGFloat = 1) -> CGColor {
        return UIColor.Hex(hex, alpha: alpha).cgColor
    }
}

