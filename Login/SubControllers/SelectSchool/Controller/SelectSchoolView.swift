//
//  AccountView.swift
//  SXReaderS
//
//  Created by 刘涛 on 2019/7/2.
//  Copyright © 2019 FolioReader. All rights reserved.
//

import Foundation

extension SelectSchoolViewController{
    
    func prepareUI() {
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
        
        itemView1.isUserInteractionEnabled = true
        let signTapGesture = UITapGestureRecognizer(target: self, action: #selector(selectAreaAction))
        itemView1.addGestureRecognizer(signTapGesture)
        itemView1.backgroundColor = UIColor.backgroundPrimary
        view.addSubview(itemView1)
        itemView1.snp.makeConstraints {
            $0.top.equalTo(tipsBgView.snp.bottom)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(55)
        }
        
        let areaTipsLabel = UILabel()
        areaTipsLabel.text = "所在地区"
        itemView1.addSubview(areaTipsLabel)
        areaTipsLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.width.equalTo(85)
        }
        
        let rightArrow = UIImageView.init(image: UIImage.init(named: "mine_right_arrow_icon"))
        itemView1.addSubview(rightArrow)
        rightArrow.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(15)
            $0.width.equalTo(8)
            $0.right.equalToSuperview().offset(-20)
        }
        
        areaLabel.text = ""
        areaLabel.textAlignment = .right
        itemView1.addSubview(areaLabel)
        areaLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(areaTipsLabel.snp.right).offset(20)
            $0.right.equalTo(rightArrow.snp.left).offset(-10)
        }
        
        let lineView1 = UIView()
        lineView1.backgroundColor = UIColor.divider
        itemView1.addSubview(lineView1)
        lineView1.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview()
            $0.height.equalTo(0.7)
        }
        
        let itemView2 = UIView()
        itemView2.backgroundColor = UIColor.backgroundPrimary
        view.addSubview(itemView2)
        itemView2.snp.makeConstraints {
            $0.top.equalTo(lineView1.snp.bottom)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(55)
        }
        
        let schoolTipsLabel = UILabel()
        schoolTipsLabel.text = "所在学校"
        itemView2.addSubview(schoolTipsLabel)
        schoolTipsLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.width.equalTo(areaTipsLabel)
        }
        
        schoolFiled.placeholder = "搜索学校名称..."
        schoolFiled.textAlignment = .left
        itemView2.addSubview(schoolFiled)
        schoolFiled.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(schoolTipsLabel.snp.right).offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
        
        let lineView2 = UIView()
        lineView2.backgroundColor = UIColor.divider
        itemView2.addSubview(lineView2)
        lineView2.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview()
            $0.height.equalTo(0.7)
        }
        
        
        selectedTipsLabel.text = "你所选地区的学校:"
        selectedTipsLabel.isHidden = true
        selectedTipsLabel.font = UIFont.systemFont(ofSize: 16)
        selectedTipsLabel.textColor = UIColor.gray
        view.addSubview(selectedTipsLabel)
        selectedTipsLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(itemView2.snp.bottom).offset(20)
        }
        
        helpIconView.contentMode = .center
        helpIconView.isHidden = true
        helpIconView.isUserInteractionEnabled = true
        let coinTapGesture = UITapGestureRecognizer(target: self, action: #selector(popHelpView))
        helpIconView.addGestureRecognizer(coinTapGesture)
        
        view.addSubview(helpIconView)
        helpIconView.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-5)
            $0.centerY.equalTo(selectedTipsLabel)
            $0.width.height.equalTo(45)
        }
        
        resultTableView.isHidden = true
        view.addSubview(resultTableView)
        resultTableView.snp.makeConstraints {
            $0.top.equalTo(selectedTipsLabel.snp.bottom).offset(10)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    
    }
}

