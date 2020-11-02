//
//  ImproveInformationController+ActionExtension.swift
//  SXReaderS
//
//  Created by 发抖喵 on 2020/9/7.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import UIKit

//MARK: - Action
extension ImproveInformationController {
    func createAction() {
        
        // 点击返回按钮
        leftArrowView.addTarget(self, action: #selector(self.clickLeftArrowView), for: .touchUpInside)
        
        // 男生点击手势
        let manTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.clickManView))
        manView.addGestureRecognizer(manTapGesture)
        
        // 女生点击手势
        let womanTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.clickWomanView))
        womanView.addGestureRecognizer(womanTapGesture)
        
        // 学校点击手势
        let optionSchoolTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.clickOptionSchool))
        optionSchool.addGestureRecognizer(optionSchoolTapGesture)
        
        // 年级点击手势
        let optionGradeTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.clickOptionGrade))
        optionGrade.addGestureRecognizer(optionGradeTapGesture)
        
        // 班级点击手势
        let optionClassTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.clickOptionClass))
        optionClass.addGestureRecognizer(optionClassTapGesture)
        
        // 点击完成
        successBtn.addTarget(self, action: #selector(self.clickSuccessBtn), for: .touchUpInside)
        
        // 点击跳过
        skipBtn.addTarget(self, action: #selector(self.clickSkipBtn), for: .touchUpInside)
    }
    
    /**
     点击返回按钮
     */
    @objc func clickLeftArrowView() {
        self.navigationController?.delegate = self
        self.navigationController?.popViewController(animated: true)
    }
    
    /**
     点击男生
     */
    @objc func clickManView() {
        userGender = 1
        manView.setSelected(true)
        womanView.setSelected(false)
        moveSelectedGenderWithMan(true)
    }
    
    /**
     点击女生
     */
    @objc func clickWomanView() {
        userGender = 0
        manView.setSelected(false)
        womanView.setSelected(true)
        moveSelectedGenderWithMan(false)
    }
    
    /**
     移动性别选中图标
     */
    private func moveSelectedGenderWithMan(_ isSelectedMan: Bool) {
        manView.isUserInteractionEnabled = false
        womanView.isUserInteractionEnabled = false
        
        if isSelectedMan {  // 是否选中的男生
            
            self.selectedGender.snp.remakeConstraints { (make) in
                make.right.equalTo(manView.snp.right)
                make.top.equalTo(manView.snp.top).offset(5)
                make.width.height.equalTo(18)
            }
        }else {
            
            self.selectedGender.snp.remakeConstraints { (make) in
                make.right.equalTo(womanView.snp.right)
                make.top.equalTo(womanView.snp.top).offset(5)
                make.width.height.equalTo(18)
            }
        }
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            
            self?.view.layoutIfNeeded()
        }) { [weak self] (isAnimation) in
            
            self?.manView.isUserInteractionEnabled = true
            self?.womanView.isUserInteractionEnabled = true
        }
    }
    
    /**
     点击选择学校
     */
    @objc func clickOptionSchool() {
        self.navigationController?.delegate = nil
        
        let vc = SelectedMySchoolController()
        vc.didSelectShoolBlock = { [weak self] model in
            self?.optionSchool.setSelectedTitle(model.schoolName ?? "请重新选择学校")
            
            self?.request.schoolName = model.schoolName
            self?.request.schoolId = model.schoolId
            self?.request.provinceId = model.provinceId
            self?.request.cityId = model.cityId
            self?.request.countyId = model.countyId
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /**
     点击选择年级
     */
    @objc func clickOptionGrade() {
        gradePickerView.show()
    }
    
    /**
     点击我的班级
     */
    @objc func clickOptionClass() {
        classPickerView.show()
    }
    
    /**
     点击跳过
     */
    @objc func clickSkipBtn() {
        GlobalUIManager.loadHomeVC()
    }
    
    /**
     点击完成
     */
    @objc func clickSuccessBtn() {
        
        // 判断是否选择学校年级等
        guard self.request.schoolName != nil else {
            SXToast.showToastAction(message: "请选择学校")
            return
        }

        guard self.request.gradeName != nil else {
            SXToast.showToastAction(message: "请选择年级")
            return
        }

        guard self.request.className != nil else {
            SXToast.showToastAction(message: "请选择班级")
            return
        }
        
        FLog(title: "提交学校信息", message: request.toJSON())

        // 提交数据
        self.upLoadUserImproveInformation(request)
    }
}
