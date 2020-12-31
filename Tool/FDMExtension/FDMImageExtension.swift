//
//  FDMImageExtension.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/24.
//

/*==================
 1.【Class】通过颜色返回一张图片
 2.【Class】获取网络图片尺寸
 3.【Class】截取View作为图片 view:被设置的View包括子视图会转为图片
 4.【Class】生成二维码图片
 5.【Class】生成条形码图片
 6.CoreGraphics 绘制圆角
==================*/

import UIKit

//MARK: UIImage
extension UIImage {
    
    /**
     1.通过颜色返回一张图片
     */
    class func imageFromColor(_ color: UIColor) -> UIImage {
        return color.toImage()
    }
    
    /**
     2.获取网络图片尺寸
     */
    class func imageSizeFromUrl(_ url: String) -> CGSize {
        return url.imageSizeFromUrl()
    }
    
    /**
     3.截取View作为图片 view:被设置的View包括子视图会转为图片
     */
    class func imageFromView(_ view:UIView) -> UIImage? {
        return view.toImage()
    }
    
    /**
     4.生成二维码图片
     */
    class func imageQRCodeFromString(_ str:String) -> UIImage?{
        return str.qrCode()
    }
    
    /**
     5.生成条形码图片
     */
    class func imageBarCodeFromString(_ str:String) -> UIImage{
        return str.imageBarCode(color0: nil, color1: nil)
    }
    
    /**
     6.CoreGraphics 绘制圆角 radius: 圆角值 andImageSize: 绘制的图片大小(与imageView大小相同就可以了)
     */
    func imageAddCornerWithRadius(_ radius: CGFloat, andImageSize size: CGSize) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let ctx = UIGraphicsGetCurrentContext()
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius))
        
        ctx?.addPath(path.cgPath)
        ctx?.clip()
        
        self.draw(in: rect)
        ctx?.drawPath(using: .fillStroke)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
