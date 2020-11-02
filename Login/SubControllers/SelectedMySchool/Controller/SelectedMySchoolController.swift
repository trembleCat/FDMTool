//
//  SelectedMySchoolController.swift
//  SXReaderS
//
//  Created by 发抖喵 on 2020/9/8.
//  Copyright © 2020 FolioReader. All rights reserved.
//
//MARK: - 选择学校

import UIKit
import FWPopupView

class SelectedMySchoolController: UBaseViewController {
    
    let selectedSchoolModel = SchoolModel()     // 学校模型
    var didSelectShoolBlock: ((SchoolModel) -> ())?  // 选中学校时block回调
    
    let regionProcessView = OptionsProgressView()
    let regionTableView = UITableView()
    let cellIdentifier = "schoolTableCell"
    
    var cityDict = [String:[CityEntity]]()
    var keysArray = [String]()
    
    var selectedIndex = 0   // 当前选择的省-市-县
    var loadDataIdAry = ["1"]
    
    var selectedEnable = true   // 是否允许点击选项
    var setCellTitleIsAnimation = true  // 设置标题时是否动画
    
    lazy var loadSchoolTipsView: LoadAnimationView_01 = {
        let loadSchoolTipsView = LoadAnimationView_01(radius: 8, color: .Hex("#26C8AB"))
        loadSchoolTipsView.isHidden = true
        regionTableView.addSubview(loadSchoolTipsView)
        return loadSchoolTipsView
    }()
    
    lazy var schoolTableView: SchoolTableView = {   // 学校列表
        let tableView = SchoolTableView()
        
        self.view.addSubview(tableView)
        tableView.isHidden = true
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(regionProcessView.snp.bottom)
            make.bottom.equalToSuperview().offset(-FDMTool.screenWithBottomSafeHeight())
        }
        
        tableView.didSelectRowBlock = { [weak self] model in
            self?.selectedSchoolModel.schoolName = model.name
            self?.selectedSchoolModel.schoolId = model.id
            
            self?.didSelectShoolBlock?(self!.selectedSchoolModel)
            self?.clickBarButtonBackItem()
        }
        
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavBarItem()
        self.navigationController?.barStyle(.theme)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPrimary
        
        createUI()
        createAction()
    }
}

//MARK: - UI
extension SelectedMySchoolController {
    func createUI() {
        self.view.addSubview(regionProcessView)
        self.view.addSubview(regionTableView)
        
        /* 选择进度 */
        regionProcessView.backgroundColor = .backgroundPrimary
        regionProcessView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(53)
        }
        
        /* 选择学校列表 */
        regionTableView.tableFooterView = UIView()
        regionTableView.tableHeaderView = UIView()
        regionTableView.separatorStyle = .none
        regionTableView.rowHeight = 53
        regionTableView.dataSource = self
        regionTableView.delegate = self
        regionTableView.backgroundColor = .backgroundPrimary
        regionTableView.register(SelectedMySchoolCell.self, forCellReuseIdentifier: cellIdentifier)
        regionTableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(regionProcessView.snp.bottom)
            make.bottom.equalToSuperview().offset(-FDMTool.screenWithBottomSafeHeight())
        }
    }
    
    /**
     设置导航栏按钮
     */
    func setNavBarItem() {
        let backItem = UIBarButtonItem(image: UIImage(named: "Login_Back"), target: self, action: #selector(self.clickBarButtonBackItem))
        
        let rightButton = UIButton()
        rightButton.setTitle(" 找不到", for: .normal)
        rightButton.setImage(UIImage(named: "Information_Doubt"), for: .normal)
        rightButton.setTitleColor(.Hex("#F46A57"), for: .normal)
        rightButton.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 15)
        rightButton.addTarget(self, action: #selector(self.clickNavRightItem), for: .touchUpInside)
        
        let rightItem = UIBarButtonItem(customView: rightButton)
        self.navigationItem.leftBarButtonItem = backItem
        self.navigationItem.rightBarButtonItem = rightItem
        
        self.navigationItem.title = "我的学校"
    }
}
