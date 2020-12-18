//
//  EveryDayReadController.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/27.
//

import UIKit

class EveryDayReadController: UIBaseViewController {
    override var name: String {"每日一读"}
    
    let presenter = EveryDayReadPresenter()
    var readData: EveryDayReadData?
    
    let topTitleLabel = UILabel()
    
    let backBtn = UIButton()
    let shareBtn = UIButton()
    
    let bgImgView = UIImageView()
    let contentScrollV = UIScrollView()
    
    let contentView = EveryDayReadContentView()
    
    var beginTitleLabelRect: CGRect?        // 起点标题Rect
    var beginTitleLabelCenterY: CGFloat?    // 起点标题CenterY
    var endTitleLabelCenterY: CGFloat?      // 终点标题CenterY

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUI()
        createAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scrollViewDidScroll(contentScrollV)
    }
}

//MARK: - Ui
extension EveryDayReadController {
    func createUI() {
        self.view.addSubview(bgImgView)
        self.view.addSubview(backBtn)
        self.view.addSubview(shareBtn)
        self.view.addSubview(contentScrollV)
        self.contentScrollV.addSubview(contentView)
        self.view.addSubview(topTitleLabel)
        
        /* 背景图片 */
        bgImgView.image = UIImage(named: "bg_EveryDayBgImage")
        bgImgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        /* 返回按钮 */
        backBtn.setImage(UIImage(named: "icon_back"), for: .normal)
        backBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(FDMTool.statusHeight() + 15)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        
        /* 分享按钮 */
        shareBtn.setImage(UIImage(named: "icon_share"), for: .normal)
        shareBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalTo(backBtn)
            make.size.equalTo(backBtn)
        }
        
        /* 滚动背景 */
        contentScrollV.delegate = self
        contentScrollV.showsVerticalScrollIndicator = false
        contentScrollV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 35, right: 0)
        contentScrollV.snp.makeConstraints { (make) in
            make.top.equalTo(backBtn.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        /* 内容 */
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(FScreenW)
        }
        
        /* 顶部标题 */
        topTitleLabel.numberOfLines = 3
        topTitleLabel.lineBreakMode = .byTruncatingMiddle
        topTitleLabel.setFontName("PingFangSC-Medium", fontSize: 20, fontColor: .UsedHex333333())
        topTitleLabel.textAlignment = .center
    }
}
