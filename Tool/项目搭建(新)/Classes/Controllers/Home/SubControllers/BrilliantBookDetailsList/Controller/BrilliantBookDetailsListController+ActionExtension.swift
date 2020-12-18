//
//  BrilliantBookDetailsListController+ActionExtension.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/30.
//

import UIKit

//MARK: - Action
extension BrilliantBookDetailsListController {
    func createAction() {
        
        /* 设置列表禁止自动移动 */
        if #available(iOS 13.0, *) {
            tableView.automaticallyAdjustsScrollIndicatorInsets = false
        }
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
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
        let shareHeaderView = BrilliantBookDetailsListHeader()
        let shareView = BrilliantBookDetailsTableView()
        shareView.layer.cornerRadius = 10
        shareView.clipsToBounds = true
        shareView.contentOffset = .zero
        shareView.isUserInteractionEnabled = false
        shareView.dataSource = self
        shareView.tableHeaderView = shareHeaderView
        shareHeaderView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalTo(FScreenW - 30)
        }
        shareView.layoutIfNeeded()
        
        let vc = ShareController(shareView: shareView, shareSize: tableView.contentSize)
        vc.setTagImage(UIImage(named: "share_TagBookList"))
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    /**
     禁止顶部下拉bounces
     */
    func unTopBunces(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            scrollView.contentOffset.y = 0
            scrollView.bounces = false
        }else {
            scrollView.bounces = true
        }
    }
    
    /**
     导航栏滚动渐变
     */
    func navBarAlphaWithScroll(_ scrollView: UIScrollView) {
        if headerWhiteViewRect == nil {
            headerWhiteViewRect = self.headerView.convert(headerView.whiteView.frame, to: self.view)
        }
        
        // 渐变导航栏
        let contentOffsetY = scrollView.contentOffset.y
        var alpha = contentOffsetY / (headerWhiteViewRect!.origin.y - navBar.height)
        
        if alpha >= 1 {
            alpha = 1
        }else if alpha <= 0 {
            alpha = 0
        }
        
        navBar.backgroundColor = .Hex("#FFFFFF", alpha: alpha)
        
        self.scrollDidTitleMove(scrollView, alpha: alpha)
    }
    
    /**
     标题移动
     */
    func scrollDidTitleMove(_ scrollView: UIScrollView, alpha: CGFloat) {
        if headerTitleLabelRect == nil {
            headerTitleLabelRect = self.headerView.whiteView.convert(headerView.titleLabel.frame, to: self.view)
            
            titleLabel.frame = headerTitleLabelRect!
            // 设置数据移动到数据回调位置
            titleLabel.text = headerView.titleLabel.text
            
            titleWidthValue = headerTitleLabelRect!.width > (FScreenW / 2) ? (headerTitleLabelRect!.width - FScreenW / 2) : 0
            
            titleValueWithCenterX = navBar.center.x - headerView.titleLabel.center.x
            titleEndCenterY = self.navBar.contentView.convert(self.navBar.firstLeftView!.center, to: self.view).y
        
        }
        
        // 宽度改变
        titleLabel.bounds = CGRect(origin: .zero, size: .init(width: headerTitleLabelRect!.width - alpha * titleWidthValue!, height: headerTitleLabelRect!.height))
        
        // X轴移动
        titleLabel.center.x = headerView.titleLabel.center.x + titleValueWithCenterX! * alpha
        
        // Y轴移动
        titleLabel.frame = CGRect(origin: .init(x: titleLabel.origin.x,
                                                y: headerTitleLabelRect!.origin.y - (scrollView.contentOffset.y * 1.2)),
                                  size: titleLabel.size)
        
        if titleLabel.center.y <= titleEndCenterY! {
            titleLabel.center.y = titleEndCenterY!
        }
        
        // 显示隐藏标题
        headerView.titleLabel.isHidden = alpha != 0
        titleLabel.isHidden = alpha == 0
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension BrilliantBookDetailsListController: UITableViewDelegate, UITableViewDataSource {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.unTopBunces(scrollView)
        self.navBarAlphaWithScroll(scrollView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(BrilliantBookDetailsListCell.self), for: indexPath) as! BrilliantBookDetailsListCell
        
        return cell
    }
}

