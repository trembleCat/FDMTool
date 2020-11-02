//
//  ReadingPreferenceController.swift
//  SXReaderS
//
//  Created by 发抖喵 on 2020/9/9.
//  Copyright © 2020 FolioReader. All rights reserved.
//
//MARK: - 选择偏好

import UIKit
import Material

class ReadingPreferenceController: UBaseViewController {
    override var nameController: String {"注册选择偏好页"}
    
    let topBgImgView = UIImageView()
    let leftArrowView = IconButton()
    let whiteBgView = UIView()
    let bottomBgImgView = UIImageView()
    let titleBanner = UILabel()
    let subTitleBanner = UILabel()
    
    let preferenceView = ReadingPrefercenceCollectionView()
    
    let successBgView = UIView()
    let successBtn = UIButton()
    
    let successNormalSize = CGSize(width: 170, height: 44)
    let successAnimationSize = CGSize(width: 179, height: 52)
    
    var userId: String
    
    var isStartSuccessAnimation = false   // 修改该属性开启或关闭完成按钮动画
    
    let pageSize = 30
    var indexPage = 0
    var userPerferenceAry = [UserPerferenceEntity]()    // 阅读基因分类
    var selectedPerferenceAry = [UserPerferenceEntity]()
    
    init(userId: String) {
        self.userId = userId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.beginLogPageView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.endLogPageView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPrimary
        
        createUI()
        createAction()
    }
}


//MARK: - UI
extension ReadingPreferenceController {
    func createUI() {
        self.view.addSubview(topBgImgView)
        self.view.addSubview(leftArrowView)
        self.view.addSubview(whiteBgView)
        self.whiteBgView.addSubview(bottomBgImgView)
        self.whiteBgView.addSubview(titleBanner)
        self.whiteBgView.addSubview(subTitleBanner)
        self.whiteBgView.addSubview(preferenceView)
        self.whiteBgView.addSubview(successBgView)
        self.whiteBgView.addSubview(successBtn)
        
        /* 顶部背景图 */
        topBgImgView.image = UIImage(named: "Register_TopBackground")
        topBgImgView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(119)
        }
        
        /* 返回按钮 */
        leftArrowView.setImage(UIImage(named: "Login_Back"), for: .normal)
        leftArrowView.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(18)
            make.bottom.equalTo(topBgImgView.snp.bottom).offset(-47)
            make.size.equalTo(CGSize(width: 25, height: 30))
        }
        
        /* 白色背景 */
        whiteBgView.layer.cornerRadius = 20
        whiteBgView.backgroundColor = self.view.backgroundColor
        whiteBgView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(LoginHeaderHeight)
        }
        
        /* 底部背景图 */
        bottomBgImgView.image = UIImage(named: "Register_Background")
        bottomBgImgView.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 117.5, height: 117.5))
        }
        
        /* 标题 */
        titleBanner.text = "请选择你的阅读偏好"
        titleBanner.font = UIFont(name: "PingFangSC-Medium", size: 22)
        titleBanner.textColor = .textBlackPrimary
        titleBanner.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(40)
            make.top.equalTo(whiteBgView.snp.top).offset(40)
            make.height.equalTo(30)
        }
        
        /* 子标题 */
        subTitleBanner.text = "（1-5个）"
        subTitleBanner.font = UIFont(name: "PingFangSC-Regular", size: 15)
        subTitleBanner.textColor = .genderColor
        subTitleBanner.snp.makeConstraints { (mark) in
            mark.left.equalTo(titleBanner.snp.right).offset(3)
            mark.bottom.equalTo(titleBanner)
        }
        
        /* 阅读偏好视图 */
        preferenceView.backgroundColor = .backgroundPrimary
        preferenceView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.top.equalTo(titleBanner.snp.bottom).offset(30)
            make.height.equalTo(340)
        }
        
        /* 确认按钮的动画背景 */
        successBgView.backgroundColor = .Hex("#FFDB28", alpha: 0.55)
        successBgView.layer.cornerRadius = 22
        successBgView.snp.makeConstraints { (make) in
            make.top.equalTo(preferenceView.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.size.equalTo(successNormalSize)
        }
        
        /* 确认按钮 */
        successBtn.setTitle("开启书香之旅", for: .normal)
        successBtn.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 18)
        successBtn.setTitleColor(.textBlackPrimary, for: .normal)
        successBtn.backgroundColor = .Hex("#F6F6F6")
        successBtn.layer.cornerRadius = 22
        successBtn.isUserInteractionEnabled = false
        successBtn.snp.makeConstraints { (make) in
            make.top.equalTo(preferenceView.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.size.equalTo(successNormalSize)
        }
    }
}
