//
//  FDMBannerNormalTagView.swift
//  FDMImageBannerDemo
//
//  Created by 发抖喵 on 2020/12/30.
//

import UIKit

//MARK: - 动画Tag
class FDMBannerNormalTagView: NSObject {
    var tagView: UIView?
    var tagAry = [UIImageView]()
}

//MARK: - UI
extension FDMBannerNormalTagView {
    func createUI(bannerView: UIView, itemCount: Int) {
        let tagView = UIView()
        bannerView.addSubview(tagView)
        
        /* tagView */
        tagView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalTo(40)
            make.height.equalTo(10)
        }
        
        for _ in 0 ..< itemCount {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "tagView_Normal")
            tagAry.append(imageView)
        }
        
        /* stack */
        let stackView = UIStackView(arrangedSubviews: tagAry)
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        
        tagView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.tagView = tagView
    }
}


//MARK: - FDMBannerViewProgressDelegate
extension FDMBannerNormalTagView: FDMBannerViewProgressDelegate {
    func bannerView(_ firstItem: Int, firstItemProgress: CGFloat, secondItem: Int, secondItemProgress: CGFloat) {
        
    }
    
    func bannerView(prevSelectedIndex: Int) {
//        tagAry[prevSelectedIndex].image = UIImage(named: "tagView_Normal")
    }
    
    func bannerView(currentSelectIndex: Int) {
//        tagAry[currentSelectIndex].image = UIImage(named: "tagView_Selected")
    }
    
    func bannerView(_ bannerView: UIView, itemCount: Int) {
//        if tagAry.count == itemCount || itemCount <= 0 {
//            return
//        }else {
//            tagView?.removeFromSuperview()
//            tagAry.removeAll()
//        }
//
//        createUI(bannerView: bannerView, itemCount: itemCount)
    }
}
