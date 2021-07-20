//
//  FButton.swift
//  FButton
//
//  Created by 发抖喵 on 2021/6/17.
//

import UIKit
import SnapKit

//MARK: - Button图片方向
public enum FButtonDirection {
    case left
    case top
    case right
    case bottom
}

//MARK: - QHButton
open class FButton: UIControl {
    var imageDic = [UInt: UIImage]()
    var titleDic = [UInt: String]()
    var titleColorDic = [UInt: UIColor]()
    var backgroundColorDic = [UInt: UIColor]()
    
    /// 内容布局大小
    public var contentSize: CGSize?
    
    /// 图片大小, 该值优先设置
    public var imageSize: CGSize? 
    
    /// 图片与文本的间距
    public var spacing: CGFloat = 0
    
    /// 图片方向
    public var imageDirection: FButtonDirection = .left
    
    /// 是否选中状态
    open override var isSelected: Bool { didSet { changeControlState() } }
    
    /// 是否高亮状态
    open override var isHighlighted: Bool { didSet { changeControlState() } }
    
    public let imageView = UIImageView()
    public let titleLabel = UILabel()
    public let contentView = UIView()
    public lazy var backgroundImageView: UIImageView = { lazyBackgroundImageView() }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UI
extension FButton {
    func setup() {
        self.addSubview(contentView)
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(titleLabel)
        
        /* contentView */
        contentView.isUserInteractionEnabled = false
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.changeControlState()
        
        contentView.snp.makeConstraints { make in
            if contentSize?.width ?? 0 > 0 && contentSize?.height ?? 0 > 0 {
                make.size.equalTo(contentSize!)
                
                if bounds.width == 0 && bounds.height == 0 {
                    make.edges.equalToSuperview()
                }else if bounds.width == 0 {
                    make.left.right.equalToSuperview()
                }else if bounds.height == 0 {
                    make.top.bottom.equalToSuperview()
                }
                
                make.center.equalToSuperview()
            }else {
                make.edges.equalToSuperview()
            }
        }
        
        let currentImageSize = imageSize ?? imageView.image?.size ?? .zero
        let contentWidth =  contentSize?.width ?? currentImageSize.width
        let contentHeight = contentSize?.height ?? currentImageSize.height
        let needWidth = currentImageSize.width > contentWidth ? contentWidth : currentImageSize.width
        let needHeight = currentImageSize.height > contentHeight ? contentHeight : currentImageSize.height
        
        switch imageDirection {
        case .left:
            
            imageOnLeft(.init(width: needWidth, height: needHeight))
            break
        case .top:
            
            imageOnTop(.init(width: needWidth, height: needHeight))
            break
        case .right:
            
            imageOnRight(.init(width: needWidth, height: needHeight))
            break
        case .bottom:
            
            imageOnBottom(.init(width: needWidth, height: needHeight))
            break
        }
    }
    
    /**
     图片在左
     */
    func imageOnLeft(_ size: CGSize) {
        imageView.snp.removeConstraints()
        titleLabel.snp.removeConstraints()
        
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.size.equalTo(size)
            make.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview().priorityMedium()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(size == .zero ? 0 : getNeedSpacing(size))
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    
    /**
     图片在上
     */
    func imageOnTop(_ size: CGSize) {
        imageView.snp.removeConstraints()
        titleLabel.snp.removeConstraints()
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.size.equalTo(size)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().priorityMedium()
        }
        
        titleLabel.textAlignment = .center
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(size == .zero ? 0 : getNeedSpacing(size))
            make.left.right.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    /**
     图片在右
     */
    func imageOnRight(_ size: CGSize) {
        imageView.snp.removeConstraints()
        titleLabel.snp.removeConstraints()
        
        imageView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.size.equalTo(size)
            make.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview().priorityMedium()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.right.equalTo(imageView.snp.left).offset(size == .zero ? 0 : -getNeedSpacing(size))
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    
    /**
     图片在下
     */
    func imageOnBottom(_ size: CGSize) {
        imageView.snp.removeConstraints()
        titleLabel.snp.removeConstraints()
        
        imageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.size.equalTo(size)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().priorityMedium()
        }
        
        titleLabel.textAlignment = .center
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.top).offset(size == .zero ? 0 : -getNeedSpacing(size))
            make.left.right.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    /**
     延迟加载背景图
     */
    func lazyBackgroundImageView() -> UIImageView {
        let imageView = UIImageView()
        self.insertSubview(imageView, at: 0)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return imageView
    }
}

//MARK: - Action
extension FButton {
    /**
     控制状态改变
     */
    func changeControlState() {
        var state = self.state
        
        if isHighlighted {
            
            state = .highlighted
        }else if isSelected {
            
            state = .selected
        }
        
        if let image = imageDic[state.rawValue] {
            imageView.image = image
        }

        if let title = titleDic[state.rawValue] {
            titleLabel.text = title
        }
        
        if let textColor = titleColorDic[state.rawValue] {
            titleLabel.textColor = textColor
        }
        
        if let bgColor = backgroundColorDic[state.rawValue] {
            backgroundColor = bgColor
        }
    }
    
    /**
     设置默认状态
     */
    func setNormalState() {
        imageView.image = imageDic[UIControl.State.normal.rawValue]
        titleLabel.text = titleDic[UIControl.State.normal.rawValue]
        titleLabel.textColor = titleColorDic[UIControl.State.normal.rawValue]
        backgroundColor = backgroundColorDic[UIControl.State.normal.rawValue]
    }
    
    /**
     获取需要的间距
     */
    func getNeedSpacing(_ size: CGSize) -> CGFloat {
        guard let contentSize = self.contentSize else { return spacing }
        
        switch imageDirection {
        case .left:
            return spacing + size.width > contentSize.width ? (contentSize.width - size.width) : spacing
        case .top:
            
            return spacing + size.height > contentSize.height ? (contentSize.height - size.height) : spacing
        case .right:
            
            return spacing + size.width > contentSize.width ? (contentSize.width - size.width) : spacing
        case .bottom:
            
            return spacing + size.height > contentSize.height ? (contentSize.height - size.height) : spacing
        }
    }
}

//MARK: - Public Action
public extension FButton {
    /**
     设置标题
     */
    func setTitle(_ title: String?, for state: UIControl.State) {
        titleDic[state.rawValue] = title
        if state == .normal { titleLabel.text = title }
    }
    
    /**
     设置图片
     */
    func setImage(_ image: UIImage?, for state: UIControl.State) {
        imageDic[state.rawValue] = image
        if state == .normal { imageView.image = image }
    }
    
    /**
     设置文字颜色
     */
    func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        titleColorDic[state.rawValue] = color
        if state == .normal { titleLabel.textColor = color }
    }
    
    /**
     设置背景颜色
     */
    func setBackgroundColor(_ color: UIColor?, for state: UIControl.State) {
        backgroundColorDic[state.rawValue] = color
    }
}
