//
//  SelectSchoolHelpPopview.swift
//  SXReaderS
//
//  Created by 刘涛 on 2020/2/27.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import Foundation
import UIKit
import FWPopupView
import Material
import RealmSwift

protocol SchoolPopBackDelegate {
    func goNextViewController(schoolName:String)
}

class SelectSchoolHelpPopview: FWPopupView , UITextFieldDelegate{
    public var delegate:SchoolPopBackDelegate?
    let schoolFiled = ErrorTextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.backgroundColor = UIColor.clear
        self.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(handleTap(sender:))))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func showPop() {
        super.show();
        
        let bgView = UIView()
        bgView.backgroundColor = UIColor.backgroundAccent
        bgView.cornerRadius = 8
        bgView.borderColor = UIColor.gray
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor.divider.cgColor
        addSubview(bgView)
        bgView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
        
        let closeImageView = UIImageView(image: UIImage.init(named: "popview_close_icon"))
        closeImageView.contentMode = .center
        closeImageView.isUserInteractionEnabled = true
        let closeTapGesture = UITapGestureRecognizer(target: self, action: #selector(closeView))
        closeImageView.addGestureRecognizer(closeTapGesture)
        
        bgView.addSubview(closeImageView)
        closeImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.width.equalTo(45)
        }
        
        let schoolImageView = UIImageView(image: UIImage.init(named: "school_icon"))
        schoolImageView.contentMode = .scaleAspectFill
        bgView.addSubview(schoolImageView)
        schoolImageView.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(20)
            $0.height.width.equalTo(28)
        }
        
        let titleView = UILabel()
        titleView.text = "找不到你的学校？"
        titleView.textColor = UIColor.textAccent
        titleView.font = UIFont.systemFont(ofSize: 18)
        bgView.addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.left.equalTo(schoolImageView.snp.right).offset(15)
            $0.centerY.equalTo(schoolImageView)
        }
        
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 10
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16),
                          NSAttributedString.Key.paragraphStyle: paraph]
        
        let contentLabel = UILabel()
        contentLabel.textColor = UIColor.textAccent
        contentLabel.attributedText = NSAttributedString(string: "没关系，你可以尝试手动输入校名以进入自己的学校。", attributes: attributes)
        contentLabel.numberOfLines = 2
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.sizeToFit()
        
        bgView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(schoolImageView.snp.bottom).offset(15)
            $0.right.equalToSuperview().offset(-20)
        }
        
        let attrString = NSAttributedString(string: "请输入真实校名...", attributes: [NSAttributedString.Key.foregroundColor:UIColor.textPrimary])
        schoolFiled.attributedPlaceholder = attrString
        schoolFiled.cornerRadius = 5
        schoolFiled.textColor = .textAccent
        schoolFiled.borderColor = UIColor.divider
        schoolFiled.layer.borderWidth = 1
        schoolFiled.layer.borderColor = UIColor.divider.cgColor
        schoolFiled.textAlignment = .left
        schoolFiled.isClearIconButtonEnabled = true
        schoolFiled.placeholderAnimation = .hidden
        schoolFiled.returnKeyType = .done
        schoolFiled.delegate = self
        schoolFiled.textInsets = EdgeInsets.init(top: 3, left: 10, bottom: 0, right: 0)
        schoolFiled.dividerActiveHeight = 1
        schoolFiled.clearIconButton?.tintColor = Color.grey.base.withAlphaComponent(0.4)
        schoolFiled.dividerActiveColor = Color.grey.lighten2
        
        bgView.addSubview(schoolFiled)
        schoolFiled.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
        }
        
        paraph.lineSpacing = 6
        let tipsLable = UILabel()
        tipsLable.textColor = UIColor.init(hexColor: "#ff6f6f")
        tipsLable.attributedText = NSAttributedString(string: "注意：输入的校名必须为真实存在的学校，工作人员完成审核后，将会为你匹配到你的目标学校。",
                                                      attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),
        NSAttributedString.Key.paragraphStyle: paraph])
        tipsLable.numberOfLines = 2
        tipsLable.lineBreakMode = .byWordWrapping
        tipsLable.sizeToFit()
        
        bgView.addSubview(tipsLable)
        tipsLable.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(schoolFiled.snp.bottom).offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
        
        let okBtn = RaisedButton(title: "确定", titleColor: .black)
        okBtn.pulseColor = .white
        okBtn.layer.cornerRadius = 17.5
        okBtn.backgroundColor = UIColor.theme
        okBtn.fontSize = fontFix(fontSize: 18)
        okBtn.addTarget(self, action: #selector(setSchool), for: .touchUpInside)
        bgView.addSubview(okBtn)
        okBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(tipsLable.snp.bottom).offset(30)
            $0.width.equalTo(140)
            $0.height.equalTo(40)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.divider
        bgView.addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.top.equalTo(okBtn.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(0.7)
        }
        
        let contactView = UILabel()
        contactView.text = "联系我们"
        contactView.textColor = UIColor.textAccent
        contactView.font = UIFont.systemFont(ofSize: 16)
        bgView.addSubview(contactView)
        contactView.snp.makeConstraints {
            $0.left.equalTo(schoolImageView.snp.left)
            $0.top.equalTo(lineView.snp.bottom).offset(20)
        }
        
        let wxImageView = UIImageView.init(image: UIImage.init(named: "sxreader_wx"))
        bgView.addSubview(wxImageView)
        wxImageView.snp.makeConstraints {
            $0.left.equalTo(schoolImageView.snp.left)
            $0.top.equalTo(contactView.snp.bottom).offset(15)
            $0.height.width.equalTo(95)
        }
        let wxLableView = UILabel()
        wxLableView.text = "官方微信"
        wxLableView.textColor = UIColor.textAccent
        wxLableView.font = UIFont.systemFont(ofSize: 14)
        bgView.addSubview(wxLableView)
        wxLableView.snp.makeConstraints {
            $0.centerX.equalTo(wxImageView)
            $0.top.equalTo(wxImageView.snp.bottom).offset(8)
        }
        
        let gzhImageView = UIImageView.init(image: UIImage.init(named: "sxreader_gzh"))
        bgView.addSubview(gzhImageView)
        gzhImageView.snp.makeConstraints {
            $0.left.equalTo(wxImageView.snp.right).offset(30)
            $0.centerY.equalTo(wxImageView)
            $0.height.width.equalTo(wxImageView)
        }
        
        let gzhLableView = UILabel()
        gzhLableView.text = "官方公众号"
        gzhLableView.textColor = UIColor.textAccent
        gzhLableView.font = UIFont.systemFont(ofSize: 14)
        bgView.addSubview(gzhLableView)
        gzhLableView.snp.makeConstraints {
            $0.centerX.equalTo(gzhImageView)
            $0.top.equalTo(gzhImageView.snp.bottom).offset(8)
        }
    }
    
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            schoolFiled.resignFirstResponder()
        }
    }
    
    @objc func setSchool(){
        schoolFiled.resignFirstResponder()
        
        guard let schoolName = schoolFiled.text else {
            return
        }
        
        if schoolName.isEmpty {
            SXToast.showToast(message: "请输入学校", aLocationStr: "bottom", aShowTime: 3.0)
            schoolFiled.shake(direction: .horizontal, times: 5, interval: 0.1, delta: 1.8)
            return
        }
        
        if delegate != nil {
            delegate?.goNextViewController(schoolName: schoolName)
        }
        self.hide()
    }
    
    @objc func closeView(){
        self.hide()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField.textInputMode?.primaryLanguage == "emoji"
            || textField.textInputMode?.primaryLanguage == nil
            || string.containsEmoji()){
            return false
        }
        
        let length = textField.text!.count + string.count - range.length
        if length > 50 {
            return false
        }
        
        if isPureChinese(string: string) || string == ""{
            return true
        }
        
        return false
    }
    
    /**
     只允许汉子和英文字母
     */
    func isPureChinese(string: String) -> Bool {
        let match: String = "[a-zA-Z\\u4e00-\\u9fa5]+$"
        let predicate = NSPredicate(format: "SELF matches %@", match)
        return predicate.evaluate(with: string)

    }
    
}
