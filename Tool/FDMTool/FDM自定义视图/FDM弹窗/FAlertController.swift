//
//  FAlertController.swift
//
//
//  Created by 发抖喵 on 2021/7/20.
//

import UIKit
import SnapKit

//MARK: - Type
extension FAlertAction {
    public enum Style : Int {
        case `default` = 0

        case cancel = 1
        
        case destructive = 2
    }
}

//MARK: - FAlertAction
public class FAlertAction: NSObject {
    public var defaultColor: UIColor = .init(red: 0, green: 189/255, blue: 203/255, alpha: 1.0)
    public var destructiveColor: UIColor = .red
    
    fileprivate var title: String
    fileprivate var style: FAlertAction.Style
    fileprivate var handle: (() -> ())?
    fileprivate var endHandle: (() -> ())?
    fileprivate lazy var alertButton: UIButton = { getAlertButton() }()
    
    public init(title: String, style: FAlertAction.Style, handle: (() -> ())? = nil) {
        self.title = title
        self.style = style
        self.handle = handle
    }
}

//MARK: - AlertButton
extension FAlertAction {
    private func getAlertButton() -> UIButton {
        let button = UIButton.init(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .init(name: "PingFangSC-Medium", size: 18)
        button.setTitleColor(style == .destructive ? destructiveColor : defaultColor, for: .normal)
        button.addTarget(self, action: #selector(clickAlertButton), for: .touchUpInside)
        
        return button
    }
    
    @objc private func clickAlertButton() {
        handle?()
        endHandle?()
    }
}

//MARK: - 青湖弹窗
public class FAlertController: UIViewController {
    
    //MARK: - BaseValue
    public var alertTitle: String? {
        set{ titleLabel.text = newValue }
        get{ titleLabel.text }
    }
    
    public var alertMessage: String? {
        set{ messageLabel.text = newValue }
        get{ messageLabel.text }
    }
    
    public var contetColor: UIColor = .white
    
    //MARK: - BaseView
    fileprivate let contentView = UIView()
    fileprivate let titleLabel = UILabel()
    fileprivate let messageLabel = UILabel()
    fileprivate let actionContentView = UIView()
    fileprivate let actionStackView = UIStackView()
    fileprivate var actionArray = [QHAlertAction]()
    
    //MARK: - BaseAction
    public init() {
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    public init(title: String, message: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.alertTitle = title
        self.alertMessage = message
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.3)
        
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Public Action
public extension FAlertController {
    /**
     添加Action
     */
    func addAction(_ action: FAlertAction) {
        action.alertButton.backgroundColor = contetColor
        actionStackView.addArrangedSubview(action.alertButton)
        actionArray.append(action)
        
        guard action.style == .cancel else {
            return
        }
        
        action.endHandle = { [weak self] in
            self?.dismiss()
        }
    }
}

//MARK: - UI
extension FAlertController {
    private func setupUI() {
        self.view.addSubview(contentView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(messageLabel)
        self.contentView.addSubview(actionContentView)
        self.actionContentView.addSubview(actionStackView)
        
        /* contentView */
        contentView.backgroundColor = contetColor
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
        }
        
        /* titleLabel */
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = .init(name: "PingFangSC-Medium", size: 16)
        titleLabel.textColor = .init(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        
        /* messageLabel */
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = .init(name: "PingFangSC-Regular", size: 14)
        messageLabel.textColor = .init(red: 102/255, green: 102/255, blue: 102/255, alpha: 1.0)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        
        /* actionContentView */
        actionContentView.backgroundColor = .init(red: 236/255, green: 236/255, blue: 236/255, alpha: 1.0)
        actionContentView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(messageLabel.snp.bottom).offset(25)
            make.height.equalTo(0)
        }
        
        /* actionStackView */
        actionStackView.spacing = 1
        actionStackView.alignment = .fill
        actionStackView.distribution = .fillEqually
        actionStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.lessThanOrEqualToSuperview().offset(1)
        }
    }
}

//MARK: - Layout
extension FAlertController {
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if actionStackView.arrangedSubviews.count >= 3 {
            verticalLayout()
        }else if actionStackView.arrangedSubviews.count >= 1{
            horizontalLayout()
        }
    }
    
    /**
     水平布局
     */
    private func horizontalLayout() {
        actionStackView.axis = .horizontal
        actionContentView.snp.updateConstraints { make in
            make.height.equalTo(45)
        }
    }
    
    /**
     垂直布局
     */
    private func verticalLayout() {
        let height = actionStackView.arrangedSubviews.count * 45
        
        actionStackView.axis = .vertical
        actionContentView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }
}

//MARK: - Action
extension QHAlertController {
    private func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}
