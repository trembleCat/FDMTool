//
//  ShareBrandView.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/12/10.
//

import UIKit

//MARK: - 分享App视图
class ShareBrandView: UIView {
    
    let iconImgView = UIImageView()
    let AppTitleLabel = UILabel()
    let AppSubTitleLabel = UILabel()
    let AppShareImgCode = UIImageView()

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
extension ShareBrandView {
    func createUI() {
        self.addSubview(iconImgView)
        self.addSubview(AppTitleLabel)
        self.addSubview(AppSubTitleLabel)
        self.addSubview(AppShareImgCode)
        
        /* App图标 */
        iconImgView.image = UIImage(named: "share_Logo")
        iconImgView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(35)
        }
        
        /* App标题 */
        AppTitleLabel.text = "书香阅读"
        AppTitleLabel.setFontName("PingFangSC-Medium", fontSize: 13, fontColor: .UsedHex333333())
        AppTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImgView.snp.right).offset(15)
            make.top.equalTo(iconImgView.snp.top)
            
        }
        
        /* App子标题 */
        AppSubTitleLabel.text = "让孩子爱上阅读!"
        AppSubTitleLabel.setFontName("PingFangSC-Regular", fontSize: 10, fontColor: .UsedHex999999())
        AppSubTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(AppTitleLabel.snp.left)
            make.top.equalTo(AppTitleLabel.snp.bottom).offset(6)
        }
        
        /* App二维码 */
        AppShareImgCode.backgroundColor = .orange
        AppShareImgCode.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
    }
}
