//
//  FDMBannerManager.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/12/25.
//

import UIKit
//import SnapKit

/// Banner类型
enum FDMBannerType {
    case Image
    case UrlImage
}



//MARK: - FDMBannerViewDelegate - 功能回调
@objc protocol FDMBannerViewDelegate: NSObjectProtocol {
    
    /**
     imageView与Url回调，可自行使用第三方库加载
     */
    @objc func bannerView(_ imageView: UIImageView, url: String?)
    
    
    /**
     点击item回调
     */
    @objc func bannerView(didSelectItemAt indexPath: IndexPath)
    
    
    /**
     选中回调
     
     - parameter currentSelectIndex: 当前选中
     */
    @objc optional func bannerView(currentSelectIndex: Int)
    
    /**
     选中回调
     
     - parameter prevSelectedIndex: 上一次选中
     */
    @objc optional func bannerView(prevSelectedIndex: Int)
}




//MARK: - FDMBannerViewProgressDelegate - 滚动进度值回调
@objc protocol FDMBannerViewProgressDelegate: NSObjectProtocol {
    
    /**
     选中回调
     
     - parameter currentSelectIndex: 当前选中
     */
    @objc optional func bannerView(currentSelectIndex: Int)
    
    /**
     选中回调
     
     - parameter prevSelectedIndex: 上一次选中
     */
    @objc optional func bannerView(prevSelectedIndex: Int)
    
    /**
     bannerView回调，用于添加TagView
     
     注: 可能会多次回调，请自行判断是否已添加TagView
     */
    @objc optional func bannerView(_ bannerView: UIView, itemCount: Int)
    
    /**
     滚动进度值回调
     
     - parameter firstItem: 排在前的 ItemIndex
     - parameter firstItemProgress: 排在前的 ItemIndex 的进度值
     - parameter secondItem: 排在后的 ItemIndex
     - parameter secondItemProgress: 排在后的 ItemIndex 的进度值
     */
    @objc optional func bannerView(_ firstItem: Int, firstItemProgress: CGFloat, secondItem: Int, secondItemProgress: CGFloat)
}



//MARK: - FDM图片轮播图
class FDMBannerManager: NSObject {
    
    /// 添加此视图
    let contentView = FDMBannerView()
    
    /// 代理
    weak var delegate: FDMBannerViewDelegate? { set { contentView.delegate = newValue } get { contentView.delegate } }
    
    /// 滚动进度代理
    weak var progressDelegate: FDMBannerViewProgressDelegate? { set { contentView.progressDelegate = newValue } get { contentView.progressDelegate } }
    
    /// type类型
    var type: FDMBannerType { set { contentView.type = newValue  } get { contentView.type } }
    
    /// 滚动时间 rollingTime <= 0 时停止自动滚动，默认为停止 毫秒
    var rollingTime: Int { set { contentView.rollingTime = newValue } get { contentView.rollingTime } }
    
    /// 选中index
    var selectedIndex: Int { set { setIndex(newValue) } get { contentView.selectedIndex } }
    
    /// itemWidth
    var itemWidth: CGFloat { set{ contentView.itemWidth = newValue } get { contentView.itemWidth } }
    
    /// 图片数组
    var imageArray: [UIImage]? { set { contentView.setImageArray(newValue) } get { contentView.imageAry } }
    
    /// 图片Url数组
    var urlImageArray: [String]? { set { contentView.setUrlImageArray(newValue) } get { contentView.urlImageAry } }
    
    /// 水平间距  默认为0
    var horizontalSpacing: CGFloat { set { contentView.horizontalSpacing = newValue } get { contentView.horizontalSpacing } }
    
    /// 垂直间距  默认为0
    var verticalSpacing: CGFloat { set { contentView.verticalSpacing = newValue } get { contentView.verticalSpacing } }
    
    /// 圆角  默认为0
    var radius: CGFloat { set { contentView.radius = newValue } get { contentView.radius } }
    
}


//MARK: - Action - 功能方法
extension FDMBannerManager {
    
    /**
     设置Index
     
     - parameter index: 标识
     - parameter animtion: 是否执行动画
     */
    func setIndex(_ index: Int, animtion: Bool = true) {
        contentView.setIndex(index, animation: animtion)
    }
}
