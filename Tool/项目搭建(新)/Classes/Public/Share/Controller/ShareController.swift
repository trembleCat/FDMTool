//
//  ShareController.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/12/10.
//

import UIKit

//MARK: - 分享
class ShareController: UIBaseViewController {
    override var name: String { "分享" }
    
    var shareView: UIView   // 分享的页面
    var shareSize: CGSize?  // 分享页面的大小
    var shareImage: UIImage?    // 要分享的图片
    var tagImage: UIImage?
    
    let statusBarLayer = CALayer()
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    
    let brandView = ShareBrandView()
    let typeView = ShareTypeView()
    
    let tagImageView = UIImageView()
    
    init(shareView: UIView, shareSize: CGSize?) {
        self.shareView = shareView
        self.shareSize = shareSize
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        createUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarHidden(true, animated: false)
    }
}

//MARK: - UI
extension ShareController {
    func createUI() {
        self.view.layer.addSublayer(statusBarLayer)
        self.view.addSubview(scrollView)
        self.view.addSubview(typeView)
        self.scrollView.addSubview(contentView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(subTitleLabel)
        self.contentView.addSubview(shareView)
        self.contentView.addSubview(brandView)
        self.contentView.addSubview(tagImageView)
        
        /* 状态栏 */
        statusBarLayer.backgroundColor = .Hex("#294A67")
        statusBarLayer.frame = .init(origin: .zero, size: .init(width: FScreenW, height: FDMTool.statusHeight()))
        
        /* 分享类型视图 */
        typeView.delegate = self
        typeView.layer.cornerRadius = 10
        typeView.layer.shadowColor = UIColor.black.cgColor
        typeView.layer.shadowOffset = .init(width: 0, height: -6)
        typeView.layer.shadowRadius = 6
        typeView.layer.shadowOpacity = 0.2
        typeView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(15)
            make.left.right.equalToSuperview()
            make.height.equalTo(155 + FDMTool.bottomSafeHeight())
        }
        
        /* 滚动视图 */
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        scrollView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(typeView.snp.top).offset(10)
        }
        
        /* 滚动视图背景 */
        contentView.backgroundColor = .Hex("#294A67")
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(FScreenW)
        }
        
        /* 标题 */
        titleLabel.numberOfLines = 1
        titleLabel.text = "西顿动物小说全集"
        titleLabel.setFontName("PingFangSC-Semibold", fontSize: 19, fontColor: .white)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-20)
        }
        
        /* 副标题 */
        subTitleLabel.numberOfLines = 1
        subTitleLabel.text = "发现一个不错的书单，分享给你～"
        subTitleLabel.setFontName("PingFangSC-Regular", fontSize: 13, fontColor: .white)
        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalToSuperview().offset(-15)
        }
        
        /* 分享的页面 */
        shareView.snp.makeConstraints { (make) in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            if let size = shareSize{ make.height.equalTo(size.height) }
        }
        
        /* 分享App标识 */
        brandView.snp.makeConstraints { (make) in
            make.top.equalTo(shareView.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(70)
        }
        
        /* 页面标识 */
        tagImageView.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.width.height.equalTo(40)
        }
    }
}
