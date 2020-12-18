//
//  EveryDayReadController+ActionExtension.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/27.
//

import UIKit

//MARK: - Action
extension EveryDayReadController {
    func createAction() {
        /* 展示数据 */
        setData()
        
        /* 绑定presenter */
        presenter.bindPresenter(delegate: self)
        presenter.reloadData()
        
        /* 点击事件 */
        self.backBtn.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
        self.shareBtn.addTarget(self, action: #selector(clickShareBtn), for: .touchUpInside)
    }
    
    /**
     点击返回按钮
     */
    @objc func clickBackBtn() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /**
     点击分享按钮
     */
    @objc func clickShareBtn() {
        let shareView = EveryDayReadContentView()
        shareView.layer.cornerRadius = 13
        shareView.layer.masksToBounds = true
        shareView.isUserInteractionEnabled = false
        shareView.setBackgroundImage(UIImage(named: "bg_EveryDayBgImage"))
        shareView.setContent(nil)
        
        let vc = ShareController(shareView: shareView, shareSize: nil)
        vc.setTagImage(UIImage(named: "share_TagEveryDayRead"))
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    /**
     展示数据
     */
    func setData() {
        contentView.setContent(nil)
        topTitleLabel.text = contentView.titleLabel.text
    }
}


//MARK: - UIScrollViewDelegate
extension EveryDayReadController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if beginTitleLabelCenterY == nil {
            beginTitleLabelCenterY = contentView.convert(contentView.titleLabel.center, to: self.view).y
            endTitleLabelCenterY = self.backBtn.center.y
            beginTitleLabelRect = contentView.convert(contentView.titleLabel.frame, to: self.view)
            topTitleLabel.frame = beginTitleLabelRect!
        }

        topTitleLabel.frame = CGRect(origin: .init(x: beginTitleLabelRect!.origin.x,
                                                   y: beginTitleLabelRect!.origin.y - scrollView.contentOffset.y), size: beginTitleLabelRect!.size)

        if topTitleLabel.center.y <= endTitleLabelCenterY! {
            topTitleLabel.center.y = endTitleLabelCenterY!

            UIView.animate(withDuration: 0.2) {
                self.topTitleLabel.numberOfLines = 1
            }
        }else {
            UIView.animate(withDuration: 0.2) {
                self.topTitleLabel.numberOfLines = 3
            }
        }
    }
}
