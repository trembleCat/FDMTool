//
//  FPopupController.swift
//
//
//  Created by 发抖喵 on 2021/7/19.
//

import UIKit
import SnapKit

//MARK: - 弹窗控制器
open class FPopupController: UIViewController {
    
    //MARK: - BaseProperty
    
    /// 内容高度
    open var contentHeight: CGFloat { 300 }
    
    /// 取消按钮高度
    open var cancelHeight: CGFloat { 50 }
    
    /// 动画执行时长
    open var animationDuration: TimeInterval { 0.15 }
    
    /// 显示 Frame
    public var showFrame: CGRect { getShowFrame() }
    
    /// 隐藏 Frame
    public var dismissFrame: CGRect { getDismissFrame() }
    
    
    //MARK: - InitUI
    public let presentView = UIView()
    public let cancelButton = UIButton()
    public let spacingView = UIView()
    public let contentView = UIView()
    
    
    //MARK: - BaseAction
    public init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        fSetupUI()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        show()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hidden()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UI
extension FPopupController {
    private func fSetupUI() {
        self.view.addSubview(presentView)
        self.presentView.addSubview(cancelButton)
        self.presentView.addSubview(contentView)
        self.cancelButton.addSubview(spacingView)
        
        /* presentView */
        presentView.backgroundColor = .white
        presentView.frame = dismissFrame
        
        /* cancelButton */
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.titleLabel?.font = .init(name: "PingFangSC-Regular", size: 18)
        cancelButton.setTitleColor(.init(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0), for: .normal)
        cancelButton.addTarget(self, action: #selector(clickCancelButton), for: .touchUpInside)
        cancelButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(cancelHeight)
        }
        
        /* spacingView */
        spacingView.backgroundColor = .init(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0)
        spacingView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        /* contentView */
        contentView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(cancelButton.snp.top)
        }
    }
}

//MARK: - Target
extension FPopupController {
    
    /**
     点击取消
     */
    @objc func clickCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Action
extension FPopupController {
    
    /**
     显示
     */
    private func show() {
        UIView.animate(withDuration: animationDuration) { [unowned self] in
            self.presentView.frame = self.showFrame
            self.viewCornerRadius(self.presentView.bounds)
            
        }
        
    }
    
    /**
     隐藏退出
     */
    private func hidden() {
        UIView.animate(withDuration: animationDuration) { [unowned self] in
            self.presentView.frame = self.dismissFrame
            
        }
        
    }
}

//MARK: - GetSet
extension FPopupController {
    /**
     获取显示Frame
     */
    private func getShowFrame() -> CGRect {
        let width = view.bounds.width
        
        let height = (contentHeight + cancelHeight) > (view.bounds.height - 88) ? (view.bounds.height - 88) : (contentHeight + cancelHeight)
        
        let y = view.bounds.height - height
        
        return .init(x: 0, y: y, width: width, height: height)
    }
    
    /**
     获取隐藏Frame
     */
    private func getDismissFrame() -> CGRect {
        let y = view.bounds.height + 10
        let width = view.bounds.width
        
        let height = (contentHeight + cancelHeight) > (view.bounds.height - 88) ? (view.bounds.height - 88) : (contentHeight + cancelHeight)
        
        return .init(x: 0, y: y, width: width, height: height)
    }
}

//MARK: - OtherAction
extension FPopupController {
    
    /**
     圆角
     */
    private func viewCornerRadius(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: .init(width: 20, height: 20))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.frame = .init(origin: .zero, size: rect.size)
        
        presentView.layer.mask = shapeLayer
    }
}
