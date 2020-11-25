//
//  FDMLayerExtension.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/24.
//

import UIKit

//MARK: Base - CALayer
extension CALayer {
    
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
