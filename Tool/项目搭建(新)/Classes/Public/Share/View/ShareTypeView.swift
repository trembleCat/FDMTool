//
//  ShareTypeView.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/12/10.
//

import UIKit

//MARK: - 分享类型选择回调
protocol shareTypeViewDelegate: NSObjectProtocol {
    
    /// 点击微信
    func clickWechatBtn()
    
    /// 点击朋友圈
    func clickWechatMomentsBtn()
    
    /// 点击QQ
    func clickQQBtn()
    
    /// 点击QQ空间
    func clickQQZone()
    
    /// 点击关闭
    func clickCloseBtn()
}

//MARK: - 分享类型选择
class ShareTypeView: UIView {
    
    weak var delegate: shareTypeViewDelegate?
    
    private let closeBtn = UIButton()
    private let closeTitle = UILabel()
    
    private let stackView = UIStackView()
    private let wechatBtn = FDMCustomButton()
    private let wechatMomentsBtn = FDMCustomButton()
    private let qqBtn = FDMCustomButton()
    private let qqZone = FDMCustomButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        createUI()
        createAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UI
extension ShareTypeView {
    private func createUI() {
        self.addSubview(stackView)
        self.addSubview(closeBtn)
        self.closeBtn.addSubview(closeTitle)
        
        /* 取消按钮 */
        closeBtn.backgroundColor = .Hex("#FBFBFB")
        closeBtn.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(55 + FDMTool.bottomSafeHeight())
        }
        
        /* 取消分享 */
        closeTitle.text = "取消分享"
        closeTitle.setFontName("PingFangSC-Regular", fontSize: 16, fontColor: .UsedHex999999())
        closeTitle.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(FPhoneIsScreen() ? 12 : 8)
        }
        
        /* 微信 */
        wechatBtn.imageSpacing = 5
        wechatBtn.titleLabel?.setFontName("PingFangSC-Regular", fontSize: 13)
        wechatBtn.setTitle("微信好友", for: .normal)
        wechatBtn.imagePosition = .FDMButtomImageTop
        wechatBtn.setTitleColor(.UsedHex666666(), for: .normal)
        wechatBtn.setImage(UIImage(named: "share_Wechat"), for: .normal)
        
        /* 朋友圈 */
        wechatMomentsBtn.imageSpacing = 5
        wechatMomentsBtn.titleLabel?.setFontName("PingFangSC-Regular", fontSize: 13)
        wechatMomentsBtn.setTitle("朋友圈", for: .normal)
        wechatMomentsBtn.imagePosition = .FDMButtomImageTop
        wechatMomentsBtn.setTitleColor(.UsedHex666666(), for: .normal)
        wechatMomentsBtn.setImage(UIImage(named: "share_WechatMoments"), for: .normal)
        
        /* QQ */
        qqBtn.imageSpacing = 5
        qqBtn.titleLabel?.setFontName("PingFangSC-Regular", fontSize: 13)
        qqBtn.setTitle("QQ好友", for: .normal)
        qqBtn.imagePosition = .FDMButtomImageTop
        qqBtn.setTitleColor(.UsedHex666666(), for: .normal)
        qqBtn.setImage(UIImage(named: "share_QQ"), for: .normal)
        
        /* QQ空间 */
        qqZone.imageSpacing = 5
        qqZone.titleLabel?.setFontName("PingFangSC-Regular", fontSize: 13)
        qqZone.setTitle("QQ空间", for: .normal)
        qqZone.imagePosition = .FDMButtomImageTop
        qqZone.setTitleColor(.UsedHex666666(), for: .normal)
        qqZone.setImage(UIImage(named: "share_QQZone"), for: .normal)
        
        /* stackView */
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(wechatBtn)
        stackView.addArrangedSubview(wechatMomentsBtn)
        stackView.addArrangedSubview(qqBtn)
        stackView.addArrangedSubview(qqZone)
        stackView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.bottom.equalTo(closeBtn.snp.top).offset(-15)
            make.top.equalToSuperview().offset(15)
        }
    }
}

//MARK: - 分享类型选择
extension ShareTypeView {
    private func createAction() {
        wechatBtn.addTarget(self, action: #selector(clickWechatBtn), for: .touchUpInside)
        wechatMomentsBtn.addTarget(self, action: #selector(clickWechatMomentsBtn), for: .touchUpInside)
        qqBtn.addTarget(self, action: #selector(clickQQBtn), for: .touchUpInside)
        qqZone.addTarget(self, action: #selector(clickQQZone), for: .touchUpInside)
        closeBtn.addTarget(self, action: #selector(clickCloseBtn), for: .touchUpInside)
    }
    
    /**
     点击微信
     */
    @objc private func clickWechatBtn() {
        delegate?.clickWechatBtn()
    }
    
    /**
     点击朋友圈
     */
    @objc private func clickWechatMomentsBtn() {
        delegate?.clickWechatMomentsBtn()
    }
    
    /**
     点击QQ
     */
    @objc private func clickQQBtn() {
        delegate?.clickQQBtn()
    }
    
    /**
     点击QQ空间
     */
    @objc private func clickQQZone() {
        delegate?.clickQQZone()
    }
    
    /**
     点击关闭
     */
    @objc private func clickCloseBtn() {
        delegate?.clickCloseBtn()
    }
}
