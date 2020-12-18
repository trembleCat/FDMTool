//
//  BrilliantBookListController+ActionExtension.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/30.
//

import UIKit

//MARK: - Action
extension BrilliantBookListController {
    func createAction() {
        
        /* 绑定presenter */
        presenter.bindPresenter(delegate: self)
    }
}


//MARK: - UITableViewDataSource, UITableViewDelegate
extension BrilliantBookListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return listData.count
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(BrilliantBookListCell.self), for: indexPath) as! BrilliantBookListCell
        
//        cell.setModel(listData[indexPath.row])
        cell.titleLabel.text = "标题"
        cell.subLabel.text = "副标题"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        039a6c25366811e891a0fa163e29292b
        // 书单详情
        let vc = BrilliantBookDetailsListController(dynamicId: "")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
