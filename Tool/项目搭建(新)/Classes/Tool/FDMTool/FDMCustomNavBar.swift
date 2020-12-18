//
//  FDMCustomNavBar.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/12/1.
//

import UIKit

class FDMCustomNavBar: UIView {
    
    let contentView = UIView()
        
    var firstLeftView: UIView?
    var lastLeftView: UIView?
    var titleView: UIView?
    var firstRightView: UIView?
    var lastRightView: UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.backgroundColor = .clear
        contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
    }
}

//MARK: - UI
extension FDMCustomNavBar {
    
    /**
     设置导航栏最左边按钮
     */
    func setFirstLeftView(_ view: UIView, size: CGSize = .init(width: 30, height: 30)) {
        firstLeftView?.removeFromSuperview()
        firstLeftView = view
        
        self.contentView.addSubview(firstLeftView!)
        firstLeftView?.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(size)
        })
    }
    
    /**
     设置导航栏最右边按钮
     */
    func setFirstRightView(_ view: UIView, size: CGSize = .init(width: 30, height: 30)) {
        firstRightView?.removeFromSuperview()
        firstRightView = view
        
        self.contentView.addSubview(firstRightView!)
        firstRightView?.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(size)
        })
    }
    
    /**
     设置TitleView
     */
    func setTitleView(_ view: UIView, size: CGSize = .init(width: FScreenW / 3, height: 30)) {
        titleView?.removeFromSuperview()
        titleView = view
        
        self.contentView.addSubview(titleView!)
        titleView?.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
            make.size.equalTo(size)
        })
    }
}
