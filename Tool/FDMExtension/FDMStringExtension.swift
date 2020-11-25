//
//  FDMStringExtension.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/24.
//

/*==================
 1.Base64 编解码
 2.MD5加密
 3.字符串尺寸
 4.从字符串URL中截取参数
 5.复制字符串到剪切板
 6.正则表达式查找字符(文本.正则)
 7.正则表达式查找字符(正则.文本)
 8.JsonString转为Dictionary <String,Any>
 9.JsonArray 转 DictionArray
 10.返回该Hex值的颜色
 11.获取网络图片尺寸
 12.生成二维码图片，带颜色，带中心图片
 13.生成条形码图片
 14.获取当前名称的本地图片
 15.包含汉字的长度(汉字占两个长度)
 16.打印自己打印自己并将自己返回
 17.将原始的url编码为合法的url(解决url中文的问题)
 18.将编码后的url转换回原始的url
 19.判断是不是Emoji Returns: true false
 20.判断是不是Emoji Returns: true false
 21.去除字符串中的emoji表情
 22.判断输入法是不是九宫格
==================*/

import UIKit
import CommonCrypto

//MARK: String
extension String {
    
    /**
     1.Base64 编解码 -encode: true:编码 false:解码 需要先将占位符换为=
     */
    func base64(encode: Bool) -> String? {
        if encode { // 编码
            guard let codingData = self.data(using: .utf8) else {return nil}
            return codingData.base64EncodedString()
        } else { // 解码
            guard !self.isEmpty else {return nil}
            
            guard let decryptionData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
                return nil
            }
            return String.init(data: decryptionData, encoding: .utf8)
        }
    }
    
    /**
     2.MD5加密 lower:true为小写，false为大写
     */
    func md5(lower: Bool = true) -> String?{
        guard let cStr = self.cString(using: .utf8) else {
            return nil
        }
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr,(CC_LONG)(strlen(cStr)), buffer) // import CommonCrypto
        let md5String = NSMutableString();
        for i in 0 ..< 16 {
            if lower {
                md5String.appendFormat("%02x", buffer[i])
            } else {
                md5String.appendFormat("%02X", buffer[i])
            }
        }
        free(buffer)
        return md5String as String
    }
    
    /**
     3.字符串尺寸
     */
    func size(font: UIFont, w: CGFloat, h: CGFloat = 0) -> CGRect {
        let attributes = [NSAttributedString.Key.font: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect = self.boundingRect(with: CGSize(width: w, height: h), options: option, attributes: attributes, context: nil)
        
        return rect
    }
    
    /**
     4.从字符串URL中截取参数
     */
    func paramsWithURL() -> [String:String]?{
        guard let components = URLComponents(url: URL(string: self)!, resolvingAgainstBaseURL: true),
        let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
    
    /**
     5.复制字符串到剪切板
     */
    func copyToClipboard() -> Bool{
        let pab = UIPasteboard.general
        pab.string = self
        
        if pab.string != nil{
            return true
        }else{
            return false
        }
    }
    
    /**
     6.正则表达式查找字符 regular:正则表达式 返回ture:验证成功
     */
    func regularExpressionOfRegular(_ regular:String) -> Bool{
        do {
            let regex: NSRegularExpression = try NSRegularExpression(pattern: regular, options: [])
            let matches = regex.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            
            var data:[String] = Array() //符合匹配的数组
            for item in matches {
                let string = (self as NSString).substring(with: item.range)
                data.append(string)
            }
            
            return data.count > 0
        }
        catch {
            return false
        }
    }
    
    /**
     7.正则表达式查找字符 text:需要验证的内容 返回ture:验证成功
     */
    func regularExpressionOfText(_ text:String) -> Bool{
        do {
            let regex: NSRegularExpression = try NSRegularExpression(pattern: self, options: [])
            let matches = regex.matches(in: text, options: [], range: NSMakeRange(0, text.count))
            
            var data:[String] = Array() //符合匹配的数组
            for item in matches {
                let string = (text as NSString).substring(with: item.range)
                data.append(string)
            }
            
            return data.count > 0
        }
        catch {
            return false
        }
    }
    
    /**
     8.JsonString转为Dictionary <String,Any>
     */
    func toDictionary() -> Dictionary<String,Any>?{
        do {
            let dic = try JSONSerialization.jsonObject(with: self.data(using: String.Encoding.utf8)!, options: .mutableLeaves) as! Dictionary<String, Any>
         
            return dic
        }catch{
            return nil
        }
    }
    
    /**
     9.JsonArray 转 DictionArray
     */
    func toDiction_Array() -> NSArray? {
        let jsonData: Data = self.data(using: .utf8)!
        
        do {
            let array = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
            
            return array as? NSArray
        } catch {
            return nil
        }
    }
    
    /**
     10.返回该Hex值的颜色
     */
    func colorHex(alpha:CGFloat = 1) -> UIColor {
        if self.hasPrefix("#") && self.count == 7 {
            return UIColor.Hex(self, alpha: alpha)
        }else{
            return .cyan
        }
    }
    
    
    /**
     11.获取网络图片尺寸
     */
    func imageSizeFromUrl() -> CGSize {
        guard !self.isEmpty else {return CGSize.zero}
        
        let tempUrl = URL(string: self)
        let imageSourceRef = CGImageSourceCreateWithURL(tempUrl! as CFURL, nil)
        
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        if let imageSRef = imageSourceRef {
            let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSRef, 0, nil)
            if let imageP = imageProperties {
                let imageDict = imageP as Dictionary
                
                width = imageDict[kCGImagePropertyPixelWidth] as! CGFloat
                height = imageDict[kCGImagePropertyPixelHeight] as! CGFloat
            }
        }
        return CGSize(width: width, height: height)
    }
    
    /**
     12.生成二维码图片，带颜色（必须为CIColor， uicolor.cicolor会失败），带中心图片
     */
    func qrCode(_ centerImage: UIImage? = nil, centerSize: CGSize? = CGSize(width: 200, height: 200), forGroundColor: CIColor = .black, backGroundColor: CIColor = .white) -> UIImage? {
        
        // 获得coreimage滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        // 设置默认值
        filter?.setDefaults()
        
        // 将文本转为data并设置到filter的inputMessage
        let dataString = self.data(using: .utf8)
        filter?.setValue(dataString, forKey: "inputMessage")
        
        // 拿到图片（图片小需要放大）
        let outImage = filter?.outputImage
        
        // 获取颜色滤镜
        let colorFilter = CIFilter(name: "CIFalseColor")
        colorFilter?.setDefaults()
        // 将二维码放到颜色滤镜
        colorFilter?.setValue(outImage, forKey: "inputImage")
        
        // 设置颜色
        colorFilter?.setValue(forGroundColor, forKey: "inputColor0")
        colorFilter?.setValue(backGroundColor, forKey: "inputColor1")
        
        // 拿到带颜色的图片并放大
        var colorImage = colorFilter?.outputImage
        colorImage = colorImage?.transformed(by: CGAffineTransform(scaleX: 20, y: 20))
        
        // 转为UIIMAG
        let startImage = UIImage(ciImage: colorImage!)
        
        // 开启图形上下文并绘制
        UIGraphicsBeginImageContext(startImage.size)
        startImage.draw(in: CGRect(origin: CGPoint.zero, size: startImage.size))
        
        if centerImage != nil {
            let iconW: CGFloat = centerSize?.width ?? 200
            let iconH: CGFloat = centerSize?.height ?? 200
            let iconX: CGFloat = (startImage.size.width - iconW) * 0.5
            let iconY: CGFloat = (startImage.size.height - iconH) * 0.5
            
            // 绘制中心图片
            centerImage!.draw(in: CGRect(x: iconX, y: iconY, width: iconW, height: iconH))
        }
        
        // 拿到图片关闭上下文
        let qrimage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
            
        return qrimage
    }
    
    /**
     13.生成条形码图片
     */
    func imageBarCode(color0: CIColor? , color1: CIColor?) -> UIImage{
        // 注意生成条形码的编码方式
        let data = self.data(using: .utf8, allowLossyConversion: false)
        let filter = CIFilter(name: "CICode128BarcodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue(NSNumber(value: 0), forKey: "inputQuietSpace")
        let outputImage = filter?.outputImage
        // 创建一个颜色滤镜,黑白色
        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setDefaults()
        colorFilter.setValue(outputImage, forKey: "inputImage")
        colorFilter.setValue(color0 ?? CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        colorFilter.setValue(color1 ?? CIColor(red: 1, green: 1, blue: 1, alpha: 0), forKey: "inputColor1")
        // 返回条形码image
        let codeImage = UIImage(ciImage: (colorFilter.outputImage!.transformed(by: CGAffineTransform(scaleX: 10, y: 10))))
        return codeImage
    }
    
    /**
     14.获取当前名称的本地图片
     */
    func image() -> UIImage? {
        return UIImage(named: self)
    }
    
    /**
     15.判断长度(中文占两个字符)
     */
    func chineseCount(_ string: String) -> Int {
        var count = 0
    
        for (_, value) in string.enumerated() {
            if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                count += 2
            }else {
                count += 1
            }
        }
        return count
    }
    
    /**
     16.打印自己打印自己并将自己返回
     */
    @discardableResult
    func log(_ title: String) -> String {
        #if DEBUG
        print("====================================")
        print(title + "  :  " + self)
        print("====================================")
        #endif
        
        return self
    }
    
    /**
     17.将原始的url编码为合法的url(解决url中文的问题)
     */
    func urlEncoded() -> String {
        var encodeUrlString:String?
        if isIncludeChineseIn(string: self) {
            encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
        }else{
            encodeUrlString = self
        }
        return encodeUrlString ?? ""
    }
    
    // 17.1 编码
    private func isIncludeChineseIn(string: String) -> Bool {
        for (_, value) in string.description.enumerated() {
            if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                return true
            }
        }
        return false
    }
    
    /**
     18.将编码后的url转换回原始的url
     */
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
    
    /**
     19.判断是不是Emoji Returns: true false
     */
    func containsEmoji()->Bool{
        if self.isNineKeyBoard(){
            return false
        }
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F,
                 0x1F300...0x1F5FF,
                 0x1F680...0x1F6FF,
                 0x2600...0x26FF,
                 0x2700...0x27BF,
                 0xFE00...0xFE0F,
                 0x1F900...0x1F9FF,
                  0x1F1FF...0x1F3F3:
                return true
            default:
                continue
            }
        }
        
        return false
    }
    
    /**
     20.判断是不是Emoji Returns: true false
     */
    func hasEmoji()->Bool {
        if self.isNineKeyBoard(){
            return false
        }
        let pattern = "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"
        let pred = NSPredicate(format: "SELF MATCHES %@",pattern)
        return pred.evaluate(with: self)
    }
    
    /**
     21.去除字符串中的表情
     */
    func disable_emoji()->String{
        do {
            let string_NS = self as NSString
            let regex = try NSRegularExpression(pattern: "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]", options: NSRegularExpression.Options.caseInsensitive)
            
            let modifiedString = regex.stringByReplacingMatches(in: string_NS as String, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, string_NS.length), withTemplate: "")
            
            return modifiedString
        } catch {
            "\(error)".log("去除字符串中的表情失败")
        }
        return ""
    }
    
    /**
     22.判断输入法是不是九宫格
     */
    func isNineKeyBoard()->Bool{
        let other : NSString = "➋➌➍➎➏➐➑➒"
        let len = self.count
        if len == 0 {
            return false
        }
        
        for _ in 0 ..< len {
            if !(other.range(of: self).location != NSNotFound) {
                return false
            }
        }
        
        return true
    }
}
