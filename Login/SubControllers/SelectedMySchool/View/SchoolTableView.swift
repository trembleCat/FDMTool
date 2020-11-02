//
//  SchoolTableView.swift
//  SXReaderS
//
//  Created by 发抖喵 on 2020/9/9.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import UIKit

class SchoolTableView: UIView {

    let tableView = UITableView()
    
    let cellIdentifier = "schoolCellIdentifier"
    
    var keysArray = [String]()
    var schoolDataAry = [String: [SchoolEntity]]()
    
    var setCellTitleIsAnimation = true  // 设置标题时是否动画
    
    var didSelectRowBlock: ((SchoolEntity) -> ())?  // 选中学校时block回调
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - UI + Action
extension SchoolTableView {
    private func createUI() {
        self.addSubview(tableView)
        
        /* 学校列表 */
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
        tableView.register(SelectedMySchoolCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    /**
     设置Key与学校数据
     */
    func setKeysArray(_ keyAry: [String], dataAry: [String: [SchoolEntity]]) {
        self.keysArray = keyAry
        self.schoolDataAry = dataAry
        
        self.tableView.reloadData()
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension SchoolTableView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return keysArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = keysArray[section]
        let dataAry = schoolDataAry[key]
        
        return dataAry?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! SelectedMySchoolCell
        
        let key = keysArray[indexPath.section]
        let dataAry = schoolDataAry[key]
        let data = dataAry?[indexPath.row]
        
        cell.setTitle(data?.name ?? "", animation: setCellTitleIsAnimation)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        setCellTitleIsAnimation = true
        
        let key = keysArray[indexPath.section]
        let dataAry = schoolDataAry[key]
        let data = dataAry?[indexPath.row]
        
        self.didSelectRowBlock?(data!)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        setCellTitleIsAnimation = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setCellTitleIsAnimation = true
    }
}
