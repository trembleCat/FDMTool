//
//  WorkDetailsController+ActionExtension.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/24.
//

import UIKit

//MARK: - Action
extension WorkDetailsController {
    func createAction() {
        contentView.setContentData(nil)
    }
    
    /**
     点击分享
     */
    @objc func clickShareBtn() {
        let shareView = WorkDetailsContentView()
        shareView.layer.cornerRadius = 10
        shareView.layer.masksToBounds = true
        shareView.setContentData(nil)
        
        let vc = ShareController(shareView: shareView, shareSize: nil)
        vc.setTagImage(UIImage(named: "share_TagWorkDetails"))
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}

