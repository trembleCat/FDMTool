//
//  BrilliantBookDetailsListController.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/30.
//

import UIKit

//MARK: - 书单详情列表
class BrilliantBookDetailsListController: UIBaseViewController {
    override var name: String {"书单详情"}
    
    let present = BrilliantBookDetailsListPresenter()
    var listData = [BrilliantBookDetailsListData]() // 列表数据
    
    let navBar = FDMCustomNavBar()
    let headerView = BrilliantBookDetailsListHeader()
    let tableView = BrilliantBookDetailsTableView()
    let titleLabel = UILabel()
    
    var headerWhiteViewRect: CGRect?    // header白色viewRect
    var headerTitleLabelRect: CGRect?   // header标题Rect
    
    var titleWidthValue: CGFloat?     // 最终标题宽度与header标题宽度差距
    var titleValueWithCenterX: CGFloat?    // header标题与anvBar的centerX间距
    var titleEndCenterY: CGFloat?    // 标题最终CenterY
    
    init(dynamicId: String) {
        super.init(nibName: nil, bundle: nil)
        
        present.dynamicId = dynamicId
        present.bindPresenter(delegate: self)
        present.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createUI()
        createAction()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scrollViewDidScroll(tableView)
    }
}

//MARK: - UI
extension BrilliantBookDetailsListController {
    func createUI() {
        self.view.addSubview(tableView)
        self.view.addSubview(navBar)
        self.view.addSubview(titleLabel)
        
        /* 列表 */
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        /* 表头 */
        tableView.tableHeaderView = headerView
        headerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalTo(FScreenW)
        }
        headerView.layoutIfNeeded()
        
        /* 自定义导航栏 */
        navBar.backgroundColor = .Hex("#FFFFFF", alpha: 0)
        navBar.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(FDMTool.statusHeight() + 44)
        }
        
        /* 顶部标题 */
        titleLabel.numberOfLines = 1
        titleLabel.setFontName(headerView.titleLabel.font.fontName, fontSize: 18, fontColor: headerView.titleLabel.textColor)
        
        
        createCustomNavBarItem()
    }
    
    /**
     设置自定义导航栏按钮
     */
    func createCustomNavBarItem() {
        let backBtn = UIButton()
        backBtn.setImage(UIImage(named: "icon_back"), for: .normal)
        backBtn.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
        
        let shareBtn = UIButton()
        shareBtn.setImage(UIImage(named: "icon_share"), for: .normal)
        shareBtn.addTarget(self, action: #selector(clickShareBtn), for: .touchUpInside)
        
        navBar.setFirstLeftView(backBtn)
        navBar.setFirstRightView(shareBtn)
    }
}
