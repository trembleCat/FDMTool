//
//  WorkDetailsContentView.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/12/11.
//

import UIKit

//MARK: - 优秀作品详情内容视图
class WorkDetailsContentView: UIView {
    
    let workDetailsView = UIView()
    
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    let contentLabel = UILabel()
    let contentImg = UIImageView()
    let timeLabel = UILabel()
    let recommendBtn = UIButton()
    
    
    let dividingLine = UIView()
    let bookInfoTitle = UILabel()
    let bookInfoView = BookInfoView(isShowAbstract: false)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - UI
extension WorkDetailsContentView {
    func createUI() {
        self.addSubview(workDetailsView)
        self.workDetailsView.addSubview(titleLabel)
        self.workDetailsView.addSubview(subTitleLabel)
        self.workDetailsView.addSubview(contentLabel)
        self.workDetailsView.addSubview(contentImg)
        self.workDetailsView.addSubview(timeLabel)
        self.workDetailsView.addSubview(recommendBtn)
        
        self.addSubview(dividingLine)
        self.addSubview(bookInfoTitle)
        self.addSubview(bookInfoView)
        
        /* 作品背景 */
        workDetailsView.backgroundColor = self.backgroundColor
        workDetailsView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        /* 标题 */
        titleLabel.numberOfLines = 3
        titleLabel.textAlignment = .center
        titleLabel.setFontName("PingFangSC-Medium", fontSize: 18, fontColor: .UsedHex333333())
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
        }
        
        /* 副标题 */
        subTitleLabel.textAlignment = .center
        subTitleLabel.setFontName("PingFangSC-Regular", fontSize: 12, fontColor: .UsedHex666666())
        subTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
        
        /* 内容 */
        contentLabel.numberOfLines = 0
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(15)
        }
        
        /* 图片 */
        contentImg.backgroundColor = .darkGray
        contentImg.layer.cornerRadius = 5
        contentImg.layer.masksToBounds = true
        contentImg.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.height.equalTo(180)
        }
        
        /* 发表时间 */
        timeLabel.setFontName("PingFangSC-Regular", fontSize: 14, fontColor: .UsedHex999999())
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(contentImg.snp.bottom).offset(15)
        }
        
        /* 推荐 */
        recommendBtn.setImage(UIImage(named: "icon_Flower"), for: .normal)
        recommendBtn.setTitleColor(.UsedHex333333(), for: .normal)
        recommendBtn.titleLabel?.font = UIFont.init(name: "PingFangSC-Medium", size: 14)
        recommendBtn.layer.cornerRadius = 22
        recommendBtn.layer.borderWidth = 1
        recommendBtn.layer.borderColor = .Hex("#979797")
        recommendBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(timeLabel.snp.bottom).offset(25)
            make.size.equalTo(CGSize.init(width: 90, height: 44))
            make.bottom.equalToSuperview()
        }
        
        /* 分割线 */
        dividingLine.backgroundColor = .Hex("#E8E8E8")
        dividingLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(workDetailsView.snp.bottom).offset(20)
            make.height.equalTo(1)
        }
        
        /* 关联书籍标题 */
        bookInfoTitle.text = "关联书籍"
        bookInfoTitle.setFontName("PingFangSC-Semibold", fontSize: 16, fontColor: .UsedHex333333())
        bookInfoTitle.snp.makeConstraints { (make) in
            make.top.equalTo(dividingLine.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(15)
        }
        
        /* 关联书籍信息 */
        bookInfoView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(bookInfoTitle.snp.bottom).offset(10)
            make.height.equalTo(114)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
}

//MARK: - Action
extension WorkDetailsContentView {
    func setContentData(_ data: WorkDetailsData?) {
        titleLabel.text = "读《契诃夫短篇小说》有感"
        subTitleLabel.text = "王军 / 乌鲁木齐天山中学 / 四年级一班"
        contentLabel.attributedText = simulationModelContentText()
        timeLabel.text = "发表于2019.08.28"
        recommendBtn.setTitle("  120", for: .normal)

        contentImg.setImage_simulation()    // 设置图片，没有图片隐藏图片

        /* 设置书籍伪信息 没有书籍信息隐藏书籍信息 */
        bookInfoView.setBookModel(WorkDetailsBookInfoData(JSONString: ""))
    }
    
    func simulationModelContentText() -> NSMutableAttributedString {
        let text = "        小说最大的特色是讽刺手法的大量运用。首先以夸张的笔墨给别里科夫画了一张惟纱惟肖的漫画，显得多么迂腐和可笑。另外还运用巧妙的对比手法，以他荒谬绝伦的思想和他一本正经的语言构成一种对比。\n        文章创作的年代，正是俄国农奴制度崩溃、资本主义迅速发展、沙皇专制制度极端反动和无产阶级革命逐渐兴起的时期。所以契诃夫对旧社会腐败灰暗，对人形成的束缚对人生活的反面影响，一种不正常的社会形态进行批判。也是对维新，与时俱进，改革创新型社会期待。"
        
        let attrs = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        
        attrs.addParagraphStyle(style)
        attrs.addFont(.systemFont(ofSize: 14))
        attrs.addForegroundColor(.UsedHex333333())
        
        return attrs
    }
}
