//
//  EveryDayReadContentView.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/12/10.
//

import UIKit

//MARK: - 每日一读内容视图
class EveryDayReadContentView: UIView {
    
    let imageView = UIImageView()
    
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    
    let recommendBtn = UIButton()
    let unRecommendBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - UI
extension EveryDayReadContentView {
    func createUI() {
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        self.addSubview(contentLabel)
        self.addSubview(recommendBtn)
        self.addSubview(unRecommendBtn)
        
        /* 背景图片 */
        imageView.contentMode = .scaleToFill
        imageView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        /* 标题 */
        titleLabel.numberOfLines = 3
        titleLabel.setFontName("PingFangSC-Medium", fontSize: 20, fontColor: .UsedHex333333())
        titleLabel.textAlignment = .center
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
        }

        /* 内容 */
        contentLabel.numberOfLines = 0
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
        }

        /* 推荐按钮 */
        recommendBtn.setImage(UIImage(named: "icon_Recommend"), for: .normal)
        recommendBtn.titleLabel?.font = UIFont.init(name: "PingFangSC-Medium", size: 14)
        recommendBtn.setTitleColor(.UsedHex333333(), for: .normal)
        recommendBtn.layer.cornerRadius = 18
        recommendBtn.layer.borderWidth = 1
        recommendBtn.layer.borderColor = .Hex("#979797")
        recommendBtn.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview().offset(-75)
            make.size.equalTo(CGSize.init(width: 76, height: 36))
            make.bottom.equalToSuperview().offset(-20)
        }

        /* 不推荐按钮 */
        unRecommendBtn.setImage(UIImage(named: "icon_unRecommend"), for: .normal)
        unRecommendBtn.titleLabel?.font = UIFont.init(name: "PingFangSC-Medium", size: 14)
        unRecommendBtn.setTitleColor(.UsedHex333333(), for: .normal)
        unRecommendBtn.layer.cornerRadius = 18
        unRecommendBtn.layer.borderWidth = 1
        unRecommendBtn.layer.borderColor = .Hex("#979797")
        unRecommendBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(75)
            make.centerY.equalTo(recommendBtn)
            make.size.equalTo(recommendBtn)
        }
    }
}

//MARK: - Action
extension EveryDayReadContentView {
    
    /**
     设置背景图片
     */
    func setBackgroundImage(_ image: UIImage?) {
        self.imageView.image = image
    }
    
    /**
     设置内容数据
     */
    func setContent(_ data: EveryDayReadData?) {
        titleLabel.text = "一片垃圾的旅程 --- 啦啦啦阿里奥术大师"
        recommendBtn.setTitle(" 120", for: .normal)
        unRecommendBtn.setTitle(" 120", for: .normal)

        let attrs = NSMutableAttributedString(string: "la 萨鲁大师结婚sad搜啊少海湖和还睡得家伙死还是就撒谎ID啊哈斯U盾我啊回安徽已我安徽对暗号思安hi会丢按上uaihi啊萨鲁大师结婚sad搜啊少海湖和还睡得家伙死还是就撒谎ID啊哈斯U盾我啊回安徽已我安徽对暗号思安hi会丢按上uaihi啊萨鲁大师结婚sad搜啊少海湖和还睡得家伙死还是就撒谎ID啊哈斯U盾我啊回安徽已我安徽对暗号思安hi会丢按上uaihi啊萨鲁大师结婚sad搜啊少海湖和还睡得家伙死还是就撒谎ID啊哈斯U盾我啊回安徽已我安徽对暗搜啊少海湖和还睡得家伙死还是就撒谎ID啊哈斯U盾我啊回安徽已我安徽对暗号思安hi会丢按上uaihi啊萨鲁大师结婚sad搜啊少海湖和还睡得萨鲁大师结婚sad搜啊少海湖和还睡得家伙死还是就撒谎ID啊哈斯U盾我啊回安徽已我安徽对暗号思安hi会丢按上uaihi啊萨鲁大师结婚sad搜啊少海湖和还睡得家伙死还是就撒谎ID啊哈斯U盾我啊回安徽已我安徽对暗号思安hi会丢按上uaihi啊萨鲁大师结婚sad搜啊少海湖和还睡得家伙死还是就撒谎ID啊哈斯U盾我啊回安徽已我安徽对暗号思安hi会丢按上uaihi啊萨鲁大师结婚sad搜啊少海湖和还睡得家伙死还是就撒谎ID啊哈斯U盾我啊回安徽已我安徽对暗搜啊少海湖和还睡得家伙死还是就撒谎ID啊哈斯U盾我啊回安徽已我安徽对暗号思安hi会丢按上uaihi啊萨鲁大师结婚sad搜啊少海湖和还睡得家伙死还是就撒谎ID啊哈斯U盾我啊回安徽已我安徽对暗号思安hi会丢按上uaihi啊萨鲁大师结婚sad搜啊少海湖和还睡得家伙死还是就撒谎ID啊哈斯U")
        attrs.addFont(UIFont.init(name: "PingFangSC-Regular", size: 15)!)
        attrs.addForegroundColor(.Hex("#505050"))
        contentLabel.attributedText = attrs
    }
}
