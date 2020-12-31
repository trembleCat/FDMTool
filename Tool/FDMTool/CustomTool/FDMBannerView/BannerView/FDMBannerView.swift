//
//  FDMBannerView.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/12/25.
//

/**
 * 隐藏Item 有4个 ，0 0 - - - - 0 0 ， 0 代表隐藏Item， - 代表使用者传进来的Item
 */

import UIKit

//MARK: - FDMBannerView
class FDMBannerView: UIView {
    
    let collectionLayout = FDMBannerLayout()
    var collectionView: UICollectionView
    
    weak var delegate: FDMBannerViewDelegate?
    weak var progressDelegate: FDMBannerViewProgressDelegate? { didSet { setProgressDelegate() } }
    
    /// 原图片数组
    var imageAry: [UIImage]?
    
    /// 原图片Url数组
    var urlImageAry: [String]?
    
    /// type类型
    var type: FDMBannerType = .Image { didSet { collectionView.reloadData() } }
    
    /// 水平间距
    var horizontalSpacing: CGFloat = 0 { didSet { collectionLayout.minimumLineSpacing = horizontalSpacing } }
    
    /// 垂直间距
    var verticalSpacing: CGFloat = 0 { didSet { collectionLayout.itemSize = getItemSize() } }
    
    /// 圆角
    var radius: CGFloat = 0
    
    /// 选中标识
    var selectedIndex: Int = 0
    
    /// itemWidth
    var itemWidth: CGFloat = 0 { didSet { collectionLayout.itemSize = getItemSize() } }
    
    /// 滚动时间 rollingTime == 0时停止自动滚动，默认为停止 毫秒
    var rollingTime: Int = 0 { didSet { startAutoScroll(scrollTime: rollingTime) } }
    
    /// cellId
    private let imageCellId = "FDMBannerImageCell"
    
    /// count总数量(包含隐藏Item数量)
    private var count: Int = 0 { didSet { countValueChange() } }
    
    /// 上一个选中标识
    private var prevSelectedIndex: Int = 0
    
    /// 开始拖动
    private var startDragX: CGFloat = 0
    
    /// 停止拖动
    private var endDragX: CGFloat = 0
    
    /// 新的图片数组
    private var newImageArray: [UIImage]?
    
    /// 新的图片Url数组
    private var newUrlImageArray: [String]?
    
    /// 定时器
    private var timeManager = FDMBannerTimer()
    
    /// 滚动间距
    private var contentSpacingX: CGFloat = 0
    
    /// 总的滚动距离
    private var completeScrollWidth: CGFloat = 0
    
    /// 左侧可展示隐藏Cell的中心X
    private var cellLeftHide_1_centerX: CGFloat = 0
    
    /// 右侧可展示隐藏Cell的中心X
    private var cellRightHide_1_centerX: CGFloat = 0
    
    /// 进度回调第一个ItemIndex
    private var firstItem = 0
    
    /// 进度回调第二个ItemIndex
    private var secondItem = 0
    
    /// 是否允许拖动
    private var isDrag = true

    /**
     初始化
     */
    override init(frame: CGRect) {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        super.init(frame: frame)
        
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - UI
extension FDMBannerView {
    
    private func createUI() {
        self.addSubview(collectionView)
        
        /* collectionView */
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(FDMBannerImageCell.self, forCellWithReuseIdentifier: imageCellId)
        
        /* layout */
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.minimumInteritemSpacing = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.collectionView.frame = self.bounds
        self.itemWidth = itemWidth <= 0 ? self.bounds.width - horizontalSpacing * 2 : itemWidth
        
        self.collectionLayout.minimumLineSpacing = horizontalSpacing
        self.collectionLayout.itemSize = getItemSize()
        self.setIndex(selectedIndex, animation: false)
    }
}


//MARK: - PrivateAction
extension FDMBannerView {
    
    /**
     count值改变的时候
     */
    private func countValueChange() {
        self.cellLeftHide_1_centerX = 0
        self.cellRightHide_1_centerX = 0
        
        setProgressDelegate()
    }
    
    /**
     设置进度代理
     */
    private func setProgressDelegate() {
        
        switch type {
        case .Image:
            self.progressDelegate?.bannerView?(self, itemCount: imageAry?.count ?? 0)
        case .UrlImage:
            self.progressDelegate?.bannerView?(self, itemCount: urlImageAry?.count ?? 0)
        }
    }
    
    /**
     获取ItemSize
     */
    private func getItemSize() -> CGSize {
        return CGSize(width: itemWidth, height: self.bounds.height - verticalSpacing * 2)
    }
    
    /**
     开启自动滚动
     
     - parameter scrollTime: 滚动间隔时间
     */
    private func startAutoScroll(scrollTime time: Int) {
        if timeManager.gcdTimer != nil { stopAutoScroll() }
        if time <= 0 { return }

        timeManager.timeCount = 20
        timeManager.createTimer(deadline: .now() + .milliseconds(time), repeating: .milliseconds(time), leeway: .milliseconds(100), calltime: 1) { (timeCount) in

        } timeInProgress: { [weak self] (timeCount) in

            self?.timeManager.timeCount = 20
            self?.setIndex((self?.selectedIndex ?? 0) + 1, animation: true)
        }

        timeManager.resume()
    }
    
    /**
     停止自动滚动
     */
    private func stopAutoScroll() {
        timeManager.cancel()
    }
    
    /**
     获取进度值的基本数据
     */
    private func getProgressBaseValue() {
        if cellLeftHide_1_centerX == 0 || cellRightHide_1_centerX == 0 {
            let cellLeftHide_1 = collectionView(collectionView, cellForItemAt: IndexPath.init(item: 1, section: 0))
            let cellRightHide_1 = collectionView(collectionView, cellForItemAt: IndexPath.init(item: count - 2, section: 0))
            
            cellLeftHide_1_centerX = cellLeftHide_1.center.x
            cellRightHide_1_centerX = cellRightHide_1.center.x
        }
        
        let progressCount = count - 2 - 1

        completeScrollWidth = cellRightHide_1_centerX - cellLeftHide_1_centerX
        contentSpacingX = completeScrollWidth / CGFloat(progressCount)


        // 选中回调
        var currentIndex = selectedIndex

        if currentIndex < 0 {     // 及时响应 ,第一个和最后一个会调用两次
            currentIndex = count - 5
        }else if currentIndex > count - 5 {
            currentIndex = 0
        }

        if prevSelectedIndex < 0 {
            prevSelectedIndex = count - 5
        }else if prevSelectedIndex > count - 5 {
            prevSelectedIndex = 0
        }

//        if currentIndex < 0 || currentIndex > count - 5 { return }    // 非及时响应， 只调用一次
        self.delegate?.bannerView?(currentSelectIndex: currentIndex)
        self.progressDelegate?.bannerView?(currentSelectIndex: currentIndex)

        if selectedIndex == prevSelectedIndex { return }
        self.delegate?.bannerView?(prevSelectedIndex: prevSelectedIndex)
        self.progressDelegate?.bannerView?(prevSelectedIndex: prevSelectedIndex)
    }
}


//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension FDMBannerView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch type {
        case .Image:
            return newImageArray?.count ?? 0
        case .UrlImage:
            return newUrlImageArray?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellId, for: indexPath) as! FDMBannerImageCell
        
        switch type {
        case .Image:
            cell.setImage(newImageArray?[indexPath.row])
            break
        case .UrlImage:
            self.delegate?.bannerView(cell.imgView, url: newUrlImageArray?[indexPath.row])
            break
        }
        
        cell.radius = radius
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        if indexPath.item > 0 && indexPath.item < count - 1 {
            var item = indexPath.item - 2
            
            if item < 0 { item = count - 5}
            if item > count - 5 { item = 0 }
            
            self.delegate?.bannerView(didSelectItemAt: .init(item: item, section: indexPath.section))
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startDragX = scrollView.contentOffset.x
        self.isDrag = false
        self.stopAutoScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollView.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {    // 禁止快速拖拽
            scrollView.isUserInteractionEnabled = true
        }
        
        endDragX = scrollView.contentOffset.x
        var currentSelectedIndex = selectedIndex
        
        if endDragX - startDragX > 20 { // 向右滚动
            if currentSelectedIndex >= count - 4 {
                currentSelectedIndex = count - 4
                return
            }
            
            currentSelectedIndex += 1

        }else if startDragX - endDragX > 20 { // 向左滚动
            if currentSelectedIndex <= -1 {
                currentSelectedIndex = -1
                return
            }
            currentSelectedIndex -= 1
        }
        
        if timeManager.gcdTimer == nil && rollingTime > 0 {
            startAutoScroll(scrollTime: rollingTime)
        }

        self.setIndex(currentSelectedIndex, animation: true)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if self.selectedIndex <= -1 {   // 到达隐藏内容第一个
            self.setIndex(count - 5, animation: false)

        }else if self.selectedIndex >= count - 4 {  // 隐藏内容最后一个
            self.setIndex(0, animation: false)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard contentSpacingX > 0 else { return }
        
        let currentCenterX = scrollView.contentOffset.x + collectionView.bounds.width * 0.5
        
        let itemProgress: Double = Double((currentCenterX - cellLeftHide_1_centerX) / contentSpacingX)
        var newItemProgress = itemProgress.bannerRoundTo(places: 2)
        
        let currentFirstItem = Int(floor(newItemProgress)) - 1
        let currentSecondItem = Int(ceil(newItemProgress)) - 1
        
        if currentFirstItem != currentSecondItem {
            firstItem = currentFirstItem
            secondItem = currentSecondItem
        }
        
        // 计算进度
        newItemProgress -= Double(secondItem)
        if newItemProgress > 1 { return }
        
        
        // 计算页面
        if currentFirstItem < 0 { // -1 页面
            firstItem = count - 5
        }else if currentSecondItem > count - 5 {
            secondItem = 0
        }
        
        let firstItemProgress = (1 - newItemProgress).bannerRoundTo(places: 2)
        let secondItemProgress = newItemProgress.bannerRoundTo(places: 2)
        
        self.progressDelegate?.bannerView?(firstItem, firstItemProgress: CGFloat(firstItemProgress), secondItem: secondItem, secondItemProgress: CGFloat(secondItemProgress))
    }

    
}


//MARK: - PublicAction - 功能方法
extension FDMBannerView {
    
    /**
     清空数据
     */
    func removeAllArray() {
        switch type {
        case .Image:
            self.imageAry?.removeAll()
            self.newImageArray?.removeAll()
            break
            
        case .UrlImage:
            self.urlImageAry?.removeAll()
            self.newUrlImageArray?.removeAll()
            break
        }
        
        self.collectionView.reloadData()
    }
    
    
    /**
     设置图片数组
     */
    func setImageArray(_ imgArray: [UIImage]?) {
        guard let imgs = imgArray else {
            BannerLog(title: "设置 imgArray 失败", message: " imgArray 为空 ")
            return
        }
        
        guard imgs.count >= 2 else {
            BannerLog(title: "设置 imgArray 失败", message: " 最少需要两条数据才能正常使用该工具 ")
            return
        }
        
        self.imageAry = imgs
        
        let endFirstImage = imgs[imgs.count - 1]
        let endSecondImage = imgs[imgs.count - 2]
        
        let startfirstImage = imgs[0]
        let startSecondImage = imgs[1]
        
        self.newImageArray = imgs
        self.newImageArray?.insert(endFirstImage, at: 0)
        self.newImageArray?.insert(endSecondImage, at: 0)
        self.newImageArray?.append(startfirstImage)
        self.newImageArray?.append(startSecondImage)
        
        self.count = newImageArray?.count ?? 0
        self.collectionView.reloadData()
    }
    
    /**
     设置Url图片数组
     */
    func setUrlImageArray(_ urlArray: [String]?) {
        guard let urls = urlArray else {
            BannerLog(title: "设置 urlArray 失败", message: " urlArray 为空 ")
            return
        }
        
        guard urls.count >= 2 else {
            BannerLog(title: "设置 urlArray 失败", message: " 最少需要两条数据才能正常使用该工具 ")
            return
        }
        
        self.urlImageAry = urls
        
        let endFirstUrl = urls[urls.count - 1]
        let endSecondUrl = urls[urls.count - 2]
        
        let startfirstUrl = urls[0]
        let startSecondUrl = urls[1]
        
        self.newUrlImageArray = urls
        self.newUrlImageArray?.insert(endFirstUrl, at: 0)
        self.newUrlImageArray?.insert(endSecondUrl, at: 0)
        self.newUrlImageArray?.append(startfirstUrl)
        self.newUrlImageArray?.append(startSecondUrl)
        
        self.count = newUrlImageArray?.count ?? 0
        self.collectionView.reloadData()
    }
    
    /**
     设置Index
     */
    func setIndex(_ index: Int, animation: Bool) {
        guard count - 4 > 1 else {
            BannerLog(title: "设置 Index 失败", message: " index 越界 ")
            return
        }
        var newIndex = index
        
        if newIndex < -1 { newIndex = -1 }
        if newIndex > count - 4 { newIndex = count - 4 }
        
        self.prevSelectedIndex = selectedIndex
        self.selectedIndex = newIndex
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.scrollToItem(at: .init(item: newIndex + 2, section: 0), at: .centeredHorizontally, animated: animation)
            self?.getProgressBaseValue()
        }
    }
}
