//
//  AccountView.swift
//  SXReaderS
//
//  Created by 刘涛 on 2019/7/2.
//  Copyright © 2019 FolioReader. All rights reserved.
//

import Foundation

extension SetUserNameViewController:UITextFieldDelegate{
    
    func prepareUI() {
        view.backgroundColor = .backgroundPrimary
        
        let tipsBgView = UIView()
        tipsBgView.backgroundColor = UIColor.init(hexColor: "#ffefef")
        view.addSubview(tipsBgView)
        tipsBgView.snp.makeConstraints {
            $0.top.equalTo(navigationBg.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(38)
        }
        
        let tipsLabel = UILabel()
        tipsLabel.textColor = UIColor.init(hexColor: "#ff6f6f")
        tipsLabel.font = UIFont.systemFont(ofSize: 14)
        tipsLabel.text = "为了找到你的同学和老师，请完善你的真实信息！"
        tipsBgView.addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.bottom.right.equalToSuperview()
        }
        
        let itemView2 = UIView()
        itemView2.backgroundColor = UIColor.clear
        view.addSubview(itemView2)
        itemView2.snp.makeConstraints {
            $0.top.equalTo(tipsBgView.snp.bottom)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(55)
        }
        
        let schoolTipsLabel = UILabel()
        schoolTipsLabel.text = "姓名"
        itemView2.addSubview(schoolTipsLabel)
        schoolTipsLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.width.lessThanOrEqualTo(60)
        }
        
        let attrString = NSAttributedString(string: "请输入你的姓名...", attributes: [NSAttributedString.Key.foregroundColor:UIColor.textPrimary])
        userNameFiled.attributedPlaceholder = attrString
        userNameFiled.delegate = self
        userNameFiled.returnKeyType = .done
        userNameFiled.textAlignment = .left
        itemView2.addSubview(userNameFiled)
        userNameFiled.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(schoolTipsLabel.snp.right)
            $0.right.equalToSuperview().offset(-20)
        }
        
        let lineView2 = UIView()
        lineView2.backgroundColor = UIColor.divider
        itemView2.addSubview(lineView2)
        lineView2.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.right.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(0.7)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField.textInputMode?.primaryLanguage == "emoji" || textField.textInputMode?.primaryLanguage == nil){
            return false
        }
        if string.containsEmoji(){
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

