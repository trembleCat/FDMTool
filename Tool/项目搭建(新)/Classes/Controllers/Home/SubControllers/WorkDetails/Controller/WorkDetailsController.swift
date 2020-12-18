//
//  WorkDetailsController.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/24.
//

import UIKit

class WorkDetailsController: UIBaseViewController {
    override var name: String {"优秀作品详情"}
    
    let presenter = WorkDetailsPresenter()  // 协议
    var detailsData: WorkDetailsData?   // 详情数据
    
    let contentScrollV = UIScrollView()
    let contentView = WorkDetailsContentView()
    
    /**
     初始化 dynamicId： 作品id
     */
    init(dynamicId: String) {
        super.init(nibName: nil, bundle: nil)
        
        presenter.dynamicId = dynamicId
        presenter.bindPresenter(delegate: self)
        presenter.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = name
        self.view.backgroundColor = .white
        
        createNavShareItem()
        createUI()
        createAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarHidden(false, animated: true)
    }
}

//MARK: - UI
extension WorkDetailsController {
    func createNavShareItem() {
        let shareItem = UIBarButtonItem(image: UIImage(named: "icon_share"), style: .done, target: self, action: #selector(clickShareBtn))
        self.navigationItem.rightBarButtonItem = shareItem
    }
    
    func createUI() {
        self.view.addSubview(contentScrollV)
        self.contentScrollV.addSubview(contentView)
        
        /* 滚动背景 */
        contentScrollV.showsVerticalScrollIndicator = false
        contentScrollV.contentInset = .init(top: 0, left: 0, bottom: FDMTool.bottomSafeHeight(), right: 0)
        contentScrollV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        /* 滚动内容 */
        contentView.backgroundColor = view.backgroundColor
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(FScreenW)
        }
        
        
    }
}
