//
//  FDMAccountField.swift
//  SXReaderS
//
//  Created by 发抖喵 on 2020/9/3.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import UIKit

class FDMAccountField: UIView {
    
    let titleImgView = UIImageView()
    let textField = UITextField()
    let lastButton = UIButton()
    
    var titleImage: UIImage? {
        get {
            return titleImgView.image
        }
        set {
            titleImgView.image = newValue
        }
    }
    
    var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UI
extension FDMAccountField {
    private func createUI() {
        self.addSubview(titleImgView)
        self.addSubview(textField)
        self.addSubview(lastButton)
        
        /* titleImage */
        titleImgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(19)
            make.size.equalTo(CGSize(width: 16, height: 18))
            make.centerY.equalToSuperview()
        }
        
        /* lastButton */
        lastButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 14, height: 14))
            make.right.equalToSuperview().offset(-19)
            make.centerY.equalToSuperview()
        }
        
        /* 输入框 */
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(titleImgView.snp.right).offset(9)
            make.right.equalTo(lastButton.snp.left).offset(-9)
            make.centerY.equalToSuperview()
            make.height.equalTo(35)
        }
    }
}

//MARK: - Action
extension FDMAccountField {
    
    /**
     为点击按钮添加事件
     */
    func addLastBtnTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        lastButton.addTarget(target, action: action, for: controlEvents)
    }
    
    /**
     为按钮设置图片
     */
    func setLastBtnImage(_ image: UIImage?, size: CGSize = CGSize(width: 15, height: 15), for state: UIControl.State) {
        lastButton.setImage(image, for: state)
        
        lastButton.snp.updateConstraints { (make) in
            make.size.equalTo(size)
        }
               
        lastButton.setNeedsLayout()
    }
    
    /**
     为按钮设置宽高固定文字
     */
    func setLastBtnTitle(_ title: String?, size: CGSize = CGSize(width: 80, height: 30) ,for state: UIControl.State) {
        lastButton.titleLabel?.text = title
        lastButton.setTitle(title, for: state)
        
        lastButton.snp.updateConstraints { (make) in
            make.size.equalTo(size)
        }
        
        lastButton.setNeedsLayout()
    }
    
    /**
     为按钮设置文字颜色
     */
    func setLastBtnTitleColor(_ color: UIColor?, for state: UIControl.State) {
        lastButton.setTitleColor(color, for: state)
    }
}
