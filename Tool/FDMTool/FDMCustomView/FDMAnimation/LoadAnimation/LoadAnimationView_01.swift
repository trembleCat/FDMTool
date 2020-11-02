//
//  LoadAnimationView_01.swift
//  LoadAnimation
//
//  Created by 发抖喵 on 2020/9/30.
//

import UIKit

class LoadAnimationView_01: UIView {
    
    /// 半径
    var radius: CGFloat = 35
    /// 圆心
    var arcCenter: CGPoint = .zero
    /// 颜色
    var animationColor: UIColor
    
    private let LoadAnimationView_01 = "LoadAnimationView_01"
    
    private lazy var animationLayer: CALayer = {    // 动画层
        let animationLayer = CALayer()
        animationLayer.frame = self.bounds
        self.layer.addSublayer(animationLayer)
        
        return animationLayer
    }()
    
    private lazy var lazyAnimation: Void = {    // 绘制线条
        createAnimation()
    }()
    
    init(radius: CGFloat, color: UIColor = .purple) {
        self.radius = radius
        self.animationColor = color
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        arcCenter = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        
        _ = lazyAnimation
    }
}

//MARK: - UI
extension LoadAnimationView_01 {
    
    /**
     绘制线条
     */
    func createAnimation() {
        let path_1 = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: .pi * 5 / 6, endAngle: .pi * 4 / 3, clockwise: true)
        let path_2 = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: .pi * 3 / 2, endAngle: .pi * 2, clockwise: true)
        let path_3 = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: .pi / 6, endAngle: .pi * 2 / 3, clockwise: true)
        
        let circleLayer_1 = CAShapeLayer()
        circleLayer_1.path = path_1.cgPath
        circleLayer_1.lineWidth = 1
        circleLayer_1.strokeColor = animationColor.cgColor
        circleLayer_1.fillColor = UIColor.clear.cgColor
        animationLayer.addSublayer(circleLayer_1)
        
        
        let circleLayer_2 = CAShapeLayer()
        circleLayer_2.path = path_2.cgPath
        circleLayer_2.lineWidth = 1
        circleLayer_2.strokeColor = animationColor.cgColor
        circleLayer_2.fillColor = UIColor.clear.cgColor
        animationLayer.addSublayer(circleLayer_2)
        
        
        let circleLayer_3 = CAShapeLayer()
        circleLayer_3.path = path_3.cgPath
        circleLayer_3.lineWidth = 1
        circleLayer_3.strokeColor = animationColor.cgColor
        circleLayer_3.fillColor = UIColor.clear.cgColor
        animationLayer.addSublayer(circleLayer_3)
    }
    
    /**
     开始动画
     */
    func startAnimation() {
        let animation_1 = CABasicAnimation(keyPath: "transform.rotation.z")
        animation_1.toValue = NSNumber.init(floatLiteral: .pi * 2)
        animation_1.duration = 0.6
        animation_1.repeatCount = 1 / 0.0
        animation_1.timingFunction = .init(name: .easeInEaseOut)
        
        let animation_2 = CABasicAnimation(keyPath: "transform.scale")
        animation_2.toValue = 1.3
        animation_2.duration = 0.6
        animation_2.repeatCount = 1 / 0.0
        animation_2.autoreverses = true
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = CFTimeInterval(CGFloat.greatestFiniteMagnitude)
        animationGroup.animations = [animation_1, animation_2]
        
        animationLayer.add(animationGroup, forKey: LoadAnimationView_01)
    }
    
    /**
     停止动画
     */
    func stopAnimation() {
        animationLayer.removeAnimation(forKey: LoadAnimationView_01)
    }
}
