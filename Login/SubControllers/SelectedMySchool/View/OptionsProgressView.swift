//
//  OptionsProgressView.swift
//  SXReaderS
//
//  Created by 发抖喵 on 2020/9/8.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import UIKit

class OptionsProgressView: UIView {
    
    let oneProgressLabel = UILabel()
    let twoProgressLabel = UILabel()
    let threeProgressLabel = UILabel()
    
    let animationLabel = UILabel()
    
    let divisionImgView_1 = UIImageView()
    let divisionImgView_2 = UIImageView()
    
    let dividingView = UIView()
    
    var divisionWidth = 6

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - UI
extension OptionsProgressView {
    func createUI() {
        self.addSubview(oneProgressLabel)
        self.addSubview(twoProgressLabel)
        self.addSubview(threeProgressLabel)
        
        self.addSubview(divisionImgView_1)
        self.addSubview(divisionImgView_2)
        
        self.addSubview(dividingView)
        
        self.addSubview(animationLabel)
        
        /* 第一个标题 */
        oneProgressLabel.text = "请选择"
        oneProgressLabel.textAlignment = .center
        oneProgressLabel.font = UIFont(name: "PingFangSC-Regular", size: 14)
        oneProgressLabel.textColor = .Hex("#CCCCCC")
        oneProgressLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-0.5)
            make.width.equalTo((FScreenW - 2 * divisionWidth) / 3)
        }
        
        /* 分割图片 */
        divisionImgView_1.image = UIImage(named: "Information_RouteNormal")
        divisionImgView_1.snp.makeConstraints { (make) in
            make.left.equalTo(oneProgressLabel.snp.right)
            make.centerY.equalToSuperview()
            make.width.equalTo(divisionWidth)
            make.height.equalTo(10)
        }
        
        /* 第二个标题 */
        twoProgressLabel.text = "请选择"
        twoProgressLabel.textAlignment = .center
        twoProgressLabel.font = UIFont(name: "PingFangSC-Regular", size: 14)
        twoProgressLabel.textColor = .Hex("#CCCCCC")
        twoProgressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(divisionImgView_1.snp.right)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-0.5)
            make.width.equalTo(oneProgressLabel.snp.width)
        }
        
        /* 分割图片 */
        divisionImgView_2.image = UIImage(named: "Information_RouteNormal")
        divisionImgView_2.snp.makeConstraints { (make) in
            make.left.equalTo(twoProgressLabel.snp.right)
            make.centerY.equalToSuperview()
            make.width.equalTo(divisionWidth)
            make.height.equalTo(10)
        }
        
        /* 第三个标题 */
        threeProgressLabel.text = "请选择"
        threeProgressLabel.textAlignment = .center
        threeProgressLabel.font = UIFont(name: "PingFangSC-Regular", size: 14)
        threeProgressLabel.textColor = .Hex("#CCCCCC")
        threeProgressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(divisionImgView_2.snp.right)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-0.5)
            make.width.equalTo(oneProgressLabel.snp.width)
        }
        
        /* 动画标题 */
        animationLabel.text = "请选择"
        animationLabel.textAlignment = .center
        animationLabel.font = UIFont(name: "PingFangSC-Regular", size: 14)
        animationLabel.textColor = .Hex("#26C8AB")
        animationLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(oneProgressLabel)
        }
        
        /* 分割线 */
        dividingView.backgroundColor = .Hex("#E8E8E8")
        dividingView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}


//MARK: - Action
extension OptionsProgressView {
    
    /**
     根据Index设置选项标题
     */
    func setTitle(_ title: String, index: Int) {
        var indexLabel: UILabel?
        
        if index == 0 {
            indexLabel = oneProgressLabel
            animationLabel.isHidden = false
        }else if index == 1 {
            indexLabel = twoProgressLabel
            animationLabel.isHidden = false
        }else if index == 2 {
            indexLabel = threeProgressLabel
            animationLabel.isHidden = true
        }
        
        indexLabel?.text = title
        indexLabel?.textColor = .Hex("#333333")
    }
    
    /**
     清除所有效果恢复默认
     */
    func restoreDefault() {
        divisionImgView_1.image = UIImage(named: "Information_RouteNormal")
        divisionImgView_2.image = UIImage(named: "Information_RouteNormal")
        
        oneProgressLabel.text = "请选择"
        oneProgressLabel.isHidden = true
        oneProgressLabel.textColor = .Hex("#CCCCCC")
        
        twoProgressLabel.text = "请选择"
        twoProgressLabel.textColor = .Hex("#CCCCCC")
        
        threeProgressLabel.text = "请选择"
        threeProgressLabel.textColor = .Hex("#CCCCCC")
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.animationLabel.frame = self!.oneProgressLabel.frame
        }) { [weak self] (isAnimation) in
            self?.oneProgressLabel.isHidden = false
        }
    }
    
    /**
     移动高亮Label到Index位置
     */
    func moveHighlightLabelWidth(index: Int) {
        animationLabel.isHidden = false
        var indexLabel: UILabel?
        
        if index <= 2 {
            
            if index == 0 {
                self.restoreDefault()
                
                return
            }else if index == 1 {
                indexLabel = twoProgressLabel
                threeProgressLabel.text = "请选择"
                threeProgressLabel.textColor = .Hex("#CCCCCC")
                divisionImgView_1.image = UIImage(named: "Information_RouteSelected")
                divisionImgView_2.image = UIImage(named: "Information_RouteNormal")
                        
            }else if index == 2 {
                indexLabel = threeProgressLabel
                divisionImgView_1.image = UIImage(named: "Information_RouteSelected")
                divisionImgView_2.image = UIImage(named: "Information_RouteSelected")
            }
            
            indexLabel?.text = "请选择"
            indexLabel?.isHidden = true
            indexLabel?.textColor = .Hex("#CCCCCC")
            
            UIView.animate(withDuration: 0.45, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 15, options: .curveLinear, animations: { [weak self] in
                
                self?.animationLabel.frame = indexLabel!.frame
            }) { (isAnimation) in
                
                indexLabel?.isHidden = false
            }
        }
    }
    
    /**
     添加点击事件
     */
    func addTarget(_ target: Any?, action: Selector?, index: Int) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        
        if index == 0 {
            
            oneProgressLabel.isUserInteractionEnabled = true
            oneProgressLabel.addGestureRecognizer(tapGesture)
        }else if index == 1 {
            
            twoProgressLabel.isUserInteractionEnabled = true
            twoProgressLabel.addGestureRecognizer(tapGesture)
        }else if index == 2 {
            
            threeProgressLabel.isUserInteractionEnabled = true
            threeProgressLabel.addGestureRecognizer(tapGesture)
        }
    }
    
}
