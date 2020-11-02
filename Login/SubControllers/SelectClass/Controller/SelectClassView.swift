//
//  AccountView.swift
//  SXReaderS
//
//  Created by 刘涛 on 2019/7/2.
//  Copyright © 2019 FolioReader. All rights reserved.
//

import Foundation

/*
 
 let gradeItemView = UIView()
    let gradeLabel = UILabel()
    
    let classItemView = UIView()
    let classLabe = UILabel()
 
 */
extension SelectClassViewController{
    
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
        
        gradeItemView.isUserInteractionEnabled = true
        let signTapGesture = UITapGestureRecognizer(target: self, action: #selector(selectGradeAction))
        gradeItemView.addGestureRecognizer(signTapGesture)
        gradeItemView.backgroundColor = UIColor.clear
        view.addSubview(gradeItemView)
        gradeItemView.snp.makeConstraints {
            $0.top.equalTo(tipsBgView.snp.bottom)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(55)
        }
        
        let gradeTipsLabel = UILabel()
        gradeTipsLabel.text = "年级"
        gradeItemView.addSubview(gradeTipsLabel)
        gradeTipsLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        let rightArrow = UIImageView.init(image: UIImage.init(named: "mine_right_arrow_icon"))
        gradeItemView.addSubview(rightArrow)
        rightArrow.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(15)
            $0.width.equalTo(8)
            $0.right.equalToSuperview().offset(-20)
        }
        
        gradeLabel.text = ""
        gradeLabel.textAlignment = .right
        gradeItemView.addSubview(gradeLabel)
        gradeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(gradeTipsLabel.snp.right).offset(20)
            $0.right.equalTo(rightArrow.snp.left).offset(-10)
        }
        
        let lineView1 = UIView()
        lineView1.backgroundColor = UIColor.divider
        gradeItemView.addSubview(lineView1)
        lineView1.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.right.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(0.7)
        }
        
        
        //-----------------------
        classItemView.isUserInteractionEnabled = true
        let signTapGesture2 = UITapGestureRecognizer(target: self, action: #selector(selectClassAction))
        classItemView.addGestureRecognizer(signTapGesture2)
        classItemView.backgroundColor = UIColor.clear
        view.addSubview(classItemView)
        classItemView.snp.makeConstraints {
            $0.top.equalTo(lineView1.snp.bottom)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(55)
        }
        
        let classTipsLabel = UILabel()
        classTipsLabel.text = "班级"
        classItemView.addSubview(classTipsLabel)
        classTipsLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
        }
        
        let rightArrow2 = UIImageView.init(image: UIImage.init(named: "mine_right_arrow_icon"))
        classItemView.addSubview(rightArrow2)
        rightArrow2.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(15)
            $0.width.equalTo(8)
            $0.right.equalToSuperview().offset(-20)
        }
        
        classLabel.text = ""
        classLabel.textAlignment = .right
        classItemView.addSubview(classLabel)
        classLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(classTipsLabel.snp.right).offset(20)
            $0.right.equalTo(rightArrow2.snp.left).offset(-10)
        }
        
        let lineView2 = UIView()
        lineView2.backgroundColor = UIColor.divider
        classItemView.addSubview(lineView2)
        lineView2.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(0.7)
            $0.left.equalToSuperview().offset(20)
        }
    }
}

