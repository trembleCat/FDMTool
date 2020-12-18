//
//  BookInfoView.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/26.
//

import UIKit

//MARK: - 书籍信息(名称，图片，作者)
class BookInfoView: UIView {
    
    let bookImgBgView = UIImageView()
    let bookImgView = UIImageView()
    let bookTitleLabel = UILabel()
    let bookSubTitleLabel = UILabel()
    lazy var bookAbstractLabel: UILabel = { UILabel() }()
    
    var isShowAbstract: Bool
    private(set) var data: WorkDetailsBookInfoData?
    
    /**
     初始化
     
     @param isShowAbstract 是否显示简介, 默认显示
     */
    init(isShowAbstract: Bool) {
        self.isShowAbstract = isShowAbstract
        super.init(frame: .zero)
        
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - UI
extension BookInfoView {
    func createUI() {
        self.addSubview(bookImgBgView)
        self.addSubview(bookTitleLabel)
        self.addSubview(bookSubTitleLabel)
        
        self.bookImgBgView.addSubview(bookImgView)
        
        if isShowAbstract { // 显示简介
            self.addSubview(bookAbstractLabel)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /* 书籍图片背景 */
        bookImgBgView.image = UIImage.init(named: "bg_BookImage")
        bookImgBgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(85)
        }
        
        /* 书籍图片 适用于高度为114 */
        bookImgView.layer.cornerRadius = 3
        bookImgView.layer.masksToBounds = true
        bookImgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(4)
            make.left.equalToSuperview().offset(6)
            make.right.equalToSuperview().offset(-6)
            make.bottom.equalToSuperview().offset(-7.5)
        }
        
        if isShowAbstract { // 显示简介
            showAbstractLayout()
        }else {
            unAbstractLayout()
        }
    }
    
    /**
     不显示简介布局
     */
    func unAbstractLayout() {
        
        /* 标题 */
        bookTitleLabel.numberOfLines = 1
        bookTitleLabel.setFontName("PingFangSC-Semibold", fontSize: 17, fontColor: .UsedHex333333())
        bookTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bookImgBgView.snp.right).offset(18)
            make.top.equalTo(bookImgView.snp.top).offset(15)
            make.right.lessThanOrEqualToSuperview().offset(-15)
            make.height.equalTo(21)
        }
        
        /* 子标题 */
        bookSubTitleLabel.numberOfLines = 1
        bookSubTitleLabel.setFontName("PingFangSC-Regular", fontSize: 15, fontColor: .UsedHex666666())
        bookSubTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bookTitleLabel.snp.left)
            make.top.equalTo(bookTitleLabel.snp.bottom).offset(15)
            make.right.lessThanOrEqualToSuperview().offset(-15)
            make.height.equalTo(20)
        }
    }
    
    /**
     显示简介布局
     */
    func showAbstractLayout() {
        
        /* 标题 */
        bookTitleLabel.numberOfLines = 1
        bookTitleLabel.setFontName("PingFangSC-Regular", fontSize: 15, fontColor: .UsedHex333333())
        bookTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bookImgBgView.snp.right).offset(18)
            make.top.equalTo(bookImgView.snp.top).offset(10)
            make.right.lessThanOrEqualToSuperview().offset(-15)
            make.height.equalTo(18)
        }
        
        /* 子标题 */
        bookSubTitleLabel.numberOfLines = 1
        bookSubTitleLabel.setFontName("PingFangSC-Regular", fontSize: 14, fontColor: .UsedHex666666())
        bookSubTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bookTitleLabel.snp.left)
            make.top.equalTo(bookTitleLabel.snp.bottom).offset(8)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(18)
        }
        
        /* 简介 */
        bookAbstractLabel.numberOfLines = 2
        bookAbstractLabel.setFontName("PingFangSC-Regular", fontSize: 13, fontColor: .UsedHex999999())
        bookAbstractLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bookSubTitleLabel.snp.left)
            make.top.equalTo(bookSubTitleLabel.snp.bottom).offset(3)
            make.right.lessThanOrEqualToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-3)
        }
        
    }
}

//MARK: - Action
extension BookInfoView {
    /**
     设置优秀作品书籍数据
     */
    func setBookModel(_ data: WorkDetailsBookInfoData?) {
        self.data = data
        
        self.bookTitleLabel.text = data?.bookName ?? "书名"
        self.bookSubTitleLabel.text = data?.author  ?? "作者"
        
        if isShowAbstract {
            self.bookAbstractLabel.text = data?.contentAbstract ?? "简介"
        }
        
        // 设置图片
        self.bookImgView.setImage_simulation()
    }
    
    
}
