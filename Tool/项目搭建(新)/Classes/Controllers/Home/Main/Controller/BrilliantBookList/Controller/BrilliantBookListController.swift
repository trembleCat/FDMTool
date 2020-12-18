//
//  BrilliantBookListController.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/30.
//

import UIKit

class BrilliantBookListController: UIBaseViewController{
    override var name: String {"书单"}
    
    let presenter = BrilliantBookListPresenter()
    var listData = [BrilliantBookListData]()
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUI()
        createAction()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarHidden(false, animated: false)
    }
}

//MARK: - UI
extension BrilliantBookListController {
    func createUI() {
        self.view.addSubview(tableView)
        
        /* 列表 */
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 255
        tableView.separatorStyle = .none
        tableView.register(BrilliantBookListCell.self, forCellReuseIdentifier: NSStringFromClass(BrilliantBookListCell.self))
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
