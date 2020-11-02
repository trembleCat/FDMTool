//
//  ImproveInformationController.swift
//  SXReaderS
//
//  Created by 发抖喵 on 2020/9/7.
//  Copyright © 2020 FolioReader. All rights reserved.
//
//MARK: - 完善信息

import UIKit
import Material
import JGProgressHUD

class ImproveInformationController: UBaseViewController {
    
    /// 转场动画
    let transitionAnimation = InproveInformationTransitionAnimation()
    
    let topBgImgView = UIImageView()
    let leftArrowView = IconButton()
    let whiteBgView = UIView()
    let bottomBgImgView = UIImageView()
    let titleBanner = UILabel()
    
    let skipBtn = UIButton()
    
    let tipsImgView = UIImageView()
    let tipsLabel = UILabel()
    
    let manView = GenderView()
    let womanView = GenderView()
    let selectedGender = UIImageView()
    
    let optionSchool = InformationOptionView()
    let optionGrade = InformationOptionView()
    let optionClass = InformationOptionView()
    
    var gradePickerView:FWPickerView!
    var classPickerView:FWPickerView!
    
    let successBtn = UIButton()
    
    var userGender = 1  // 用户性别
    var request: UpdateSchoolRequest  // 学校班级年级请求
    
    init(request: UpdateSchoolRequest) {
        self.request = request
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.barStyle(.clear)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroundPrimary

        createUI()
        createAction()
    }
}

//MARK: - UI
extension ImproveInformationController {
    func createUI() {
        self.view.addSubview(topBgImgView)
        self.view.addSubview(leftArrowView)
        self.view.addSubview(whiteBgView)
        self.whiteBgView.addSubview(bottomBgImgView)
        self.whiteBgView.addSubview(titleBanner)
        self.whiteBgView.addSubview(skipBtn)
        self.whiteBgView.addSubview(tipsImgView)
        self.whiteBgView.addSubview(tipsLabel)
        self.whiteBgView.addSubview(manView)
        self.whiteBgView.addSubview(womanView)
        self.whiteBgView.addSubview(selectedGender)
        self.whiteBgView.addSubview(optionSchool)
        self.whiteBgView.addSubview(optionGrade)
        self.whiteBgView.addSubview(optionClass)
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
        whiteBgView.backgroundColor = .white
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
        titleBanner.text = "完善信息"
        titleBanner.font = UIFont(name: "PingFangSC-Medium", size: 22)
        titleBanner.textColor = .Hex("#333333")
        titleBanner.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().offset(40)
            make.top.equalTo(whiteBgView.snp.top).offset(40)
            make.height.equalTo(30)
        }
        
        /* 跳过 */
        skipBtn.setTitle("跳过", for: .normal)
        skipBtn.layer.borderWidth = 1
        skipBtn.layer.borderColor = UIColor.Hex("#E7E7E7").cgColor
        skipBtn.layer.cornerRadius = 15
        skipBtn.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 13)
        skipBtn.setTitleColor(.Hex("#999999"), for: .normal)
        skipBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
            make.size.equalTo(CGSize(width: 60, height: 30))
        }
        
        /* 提示图标 */
        tipsImgView.image = UIImage(named: "SetPwd_Tips")
        tipsImgView.snp.makeConstraints { (make) in
            make.left.equalTo(titleBanner.snp.left)
            make.top.equalTo(titleBanner.snp.bottom).offset(20)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        
        /* 提示文字 */
        tipsLabel.text = "为了找到你的同学和老师，请完善你的真实信息"
        tipsLabel.font = UIFont(name: "PingFangSC-Regular", size: 13)
        tipsLabel.textColor = .Hex("#FFB7A2")
        tipsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(tipsImgView.snp.right).offset(5)
            make.height.equalTo(22)
            make.centerY.equalTo(tipsImgView)
        }
        
        /* 男生图标 */
        userGender = 1
        manView.setSelected(true)
        manView.isUserInteractionEnabled = true
        manView.setImage(UIImage(named: "Information_Man"), title: "男生")
        manView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 70, height: 100))
            make.top.equalTo(tipsLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview().offset(-65)
        }
        
        /* 女生图标 */
        womanView.isUserInteractionEnabled = true
        womanView.setImage(UIImage(named: "Information_Woman"), title: "女生")
        womanView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 70, height: 100))
            make.top.equalTo(tipsLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview().offset(65)
        }
        
        /* 选择性别图标 */
        selectedGender.image = UIImage(named: "Information_Selected")
        selectedGender.snp.makeConstraints { (make) in
            make.right.equalTo(manView.snp.right)
            make.top.equalTo(manView.snp.top).offset(5)
            make.width.height.equalTo(18)
        }
        
        /* 选择学校 */
        optionSchool.setTitle("我的学校")
        optionSchool.isUserInteractionEnabled = true
        optionSchool.snp.makeConstraints { (make) in
            make.top.equalTo(manView.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(52)
        }
        
        /* 选择年级 */
        optionGrade.setTitle("我的年级")
        optionGrade.isUserInteractionEnabled = true
        optionGrade.snp.makeConstraints { (make) in
            make.top.equalTo(optionSchool.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(52)
        }
        
        /* 选择班级 */
        optionClass.setTitle("我的班级")
        optionClass.isUserInteractionEnabled = true
        optionClass.snp.makeConstraints { (make) in
            make.top.equalTo(optionGrade.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(52)
        }
        
        /* 完成 */
        successBtn.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 18)
        successBtn.setTitleColor(.black, for: .normal)
        successBtn.setTitle("完成", for: .normal)
        successBtn.layer.cornerRadius = 22
        successBtn.backgroundColor = UIColor.theme
        successBtn.snp.makeConstraints { (make) in
            make.top.equalTo(optionClass.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(140)
        }
        
        /* 选择年级弹框 */
        gradePickerView = FWPickerView.date(confirmBlock: {[weak self] (title) in
            self?.optionGrade.setSelectedTitle(title)
            self?.request.gradeName = title
            }, suffix: "年级", maxSize: 12)
        
        /* 选择班级弹框 */
        classPickerView = FWPickerView.date(confirmBlock: {[weak self] (title) in
            self?.optionClass.setSelectedTitle(title)
            self?.request.className = title
            }, suffix: "班", maxSize: 100)
    
    }
}
