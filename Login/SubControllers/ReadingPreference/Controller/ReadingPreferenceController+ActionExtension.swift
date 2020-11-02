//
//  ReadingPreferenceController+ActionExtension.swift
//  SXReaderS
//
//  Created by 发抖喵 on 2020/9/9.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import UIKit

//MARK: - Action
extension ReadingPreferenceController {
    func createAction() {
        // 点击返回按钮
        leftArrowView.addTarget(self, action: #selector(self.clickLeftArrowView), for: .touchUpInside)
        // 点击完成按钮
        successBtn.addTarget(self, action: #selector(self.clickSuccessBtn), for: .touchUpInside)
        
        // 阅读偏好选中回调
        preferenceView.selectedDataBlock = { [weak self] dataAry in
            self?.selectedPerferenceAry = dataAry
            
            if dataAry.count > 0 {
                self?.startSuccessAnimation(true)
            }else {
                self?.startSuccessAnimation(false)
            }
        }
        
        // 加载偏好数据
        loadPreferenceInfo()
    }
    
    /**
     点击返回按钮
     */
    @objc func clickLeftArrowView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /**
     点击开启书香之旅
     */
    @objc func clickSuccessBtn() {
        self.savePreferenceInfo()
    }
    
    /**
     开启或关闭完成按钮动画
     */
    func startSuccessAnimation(_ isAnimation: Bool) {
        if isAnimation {
            
            if isStartSuccessAnimation == false {
                startSuccessBtnAnimation()
            }
            
            isStartSuccessAnimation = true
            successBgView.isHidden = false
            successBtn.isUserInteractionEnabled = true
            successBtn.backgroundColor = .Hex("#FFDB28")
        }else {
            
            isStartSuccessAnimation = false
            successBgView.isHidden = true
            successBtn.isUserInteractionEnabled = false
            successBtn.backgroundColor = .Hex("#F6F6F6")
        }
    }
    
    /**
     开始完成按钮动画
     */
    private func startSuccessBtnAnimation() {
        DispatchQueue.main.async { [weak self] in
            
            UIView.animate(withDuration: 0.65, animations: {
                self?.successBgView.bounds = CGRect(origin: .zero, size: self!.successAnimationSize)
                self?.successBgView.layer.cornerRadius = 26
            }) { (isAnimation) in
                self?.endSuccessBtnAnimation()
            }
        }
    }
    
    /**
     完成按钮动画递归
     */
    private func endSuccessBtnAnimation() {
        DispatchQueue.main.async { [weak self] in
            
            UIView.animate(withDuration: 0.35, animations: {
                self?.successBgView.bounds = CGRect(origin: .zero, size: self!.successNormalSize)
                self?.successBgView.layer.cornerRadius = 22
            }) { (isAnimation) in
                
                if self?.isStartSuccessAnimation ?? false {
                    self?.startSuccessBtnAnimation()
                }
            }
        }
    }
}
