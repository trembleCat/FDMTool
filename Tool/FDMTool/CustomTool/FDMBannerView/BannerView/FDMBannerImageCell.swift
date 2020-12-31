//
//  FDMBannerImageCell.swift
//  FDMImageBannerDemo
//
//  Created by 发抖喵 on 2020/12/28.
//

import UIKit

class FDMBannerImageCell: UICollectionViewCell {
    
    let imgView = UIImageView()
    var radius: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imgView.layer.cornerRadius = radius
    }
}

//MARK: - UI
extension FDMBannerImageCell {
    func createUI() {
        self.contentView.addSubview(imgView)
        
        /* 图片 */
        imgView.layer.masksToBounds = true
        imgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    /**
     设置图片
     */
    func setImage(_ image: UIImage?) {
        imgView.image = image
    }
}
