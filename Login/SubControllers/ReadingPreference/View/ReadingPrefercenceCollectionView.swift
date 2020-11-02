//
//  ReadingPrefercenceCollectionView.swift
//  SXReaderS
//
//  Created by 发抖喵 on 2020/9/10.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import UIKit

class ReadingPrefercenceCollectionView: UIView {

    var collectionView: UICollectionView!
    let cellIdentifier = "prefercenceCell"
    let collectionLayout = PrefercenceCollectionViewLayout()
    
    let leftBtn = FDMCustomButton()
    let rightBtn = FDMCustomButton()
    
    var data = [UserPerferenceEntity]()
    var selectedData = [UserPerferenceEntity]()
    
    var beginDraggingOffSet = CGPoint.zero
    var isCellAnimation = true
    var cellScrollerdDirection: UIRectEdge = .right
    
    var selectedDataBlock: (([UserPerferenceEntity]) -> ())? // 选中数量回调
    var pageIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - UI + Action
extension ReadingPrefercenceCollectionView {
    func createUI() {
        
        /* 偏好列表 */
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.setCollectionViewLayout(collectionLayout, animated: false)
        collectionView.backgroundColor = .backgroundPrimary
        collectionView.register(PrefercenceCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
        }
        
        /* 上一组 */
        self.addSubview(leftBtn)
        leftBtn.isHidden = true
        leftBtn.imagePosition = .FDMButtomImageLeft
        leftBtn.titleLabel?.font = UIFont.init(name: "PingFangSC-Medium", size: 14)
        leftBtn.setTitle(" 上一组", for: .normal)
        leftBtn.setTitleColor(.create(light: .Hex("#666666"), dark: .Hex("#999999")), for: .normal)
        leftBtn.setImage(UIImage(named: "Information_Left"), for: .normal)
        leftBtn.addTarget(self, action: #selector(self.clickLeftBtn), for: .touchUpInside)
        leftBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(35)
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(25)
        }
        
        /* 下一步 */
        self.addSubview(rightBtn)
        rightBtn.imagePosition = .FDMButtomImageRight
        rightBtn.titleLabel?.font = UIFont.init(name: "PingFangSC-Medium", size: 14)
        rightBtn.setTitle("下一组 ", for: .normal)
        rightBtn.setTitleColor(.create(light: .Hex("#666666"), dark: .Hex("#999999")), for: .normal)
        rightBtn.setImage(UIImage(named: "Information_Right"), for: .normal)
        rightBtn.addTarget(self, action: #selector(self.clickRightBtn), for: .touchUpInside)
        rightBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-35)
            make.centerY.equalTo(leftBtn)
            make.height.equalTo(25)
        }
        
    }
    
    /**
     点击上一组
     */
    @objc func clickLeftBtn() {
        pageIndex -= 1
        beginDraggingOffSet = collectionView.contentOffset
        collectionView.setContentOffset(CGPoint(x: pageIndex * collectionView.width, y: 0), animated: true)
        
        if pageIndex > 0 {
            leftBtn.isHidden = false
        }else {
            leftBtn.isHidden = true
        }
        
        let nextPage = pageIndex + 1
        if nextPage * collectionView.width >= collectionView.contentSize.width {
            rightBtn.isHidden = true
        }else {
            rightBtn.isHidden = false
        }
    }
    
    /**
     点击下一组
     */
    @objc func clickRightBtn() {
        pageIndex += 1
        beginDraggingOffSet = collectionView.contentOffset
        collectionView.setContentOffset(CGPoint(x: pageIndex * collectionView.width, y: 0), animated: true)
        
        if pageIndex > 0 {
            leftBtn.isHidden = false
        }else {
            leftBtn.isHidden = true
        }
        
        let nextPage = pageIndex + 1
        if nextPage * collectionView.width >= collectionView.contentSize.width {
            rightBtn.isHidden = true
        }else {
            rightBtn.isHidden = false
        }
    }
    
    /**
     cell滚动动画
     */
    private func animationWidth(cell: UICollectionViewCell) {
        guard isCellAnimation else { return }
        
        let cellFrame = cell.frame
        var cellX = cellFrame.origin.x
        
        if cellScrollerdDirection == .right {
            cellX = cellFrame.origin.x + cellFrame.width
        }else if cellScrollerdDirection == .left {
            cellX = cellFrame.origin.x - cellFrame.width
        }
        
        cell.frame = CGRect(origin: CGPoint(x: cellX , y: cellFrame.origin.y), size: cellFrame.size)
        
        let arcTime = FDMTool.getArc4random(start: 30, end: 50)
        let duration = arcTime * 0.01
        
        UIView.animate(withDuration: TimeInterval(duration), animations: {
            cell.frame = cellFrame
        }) { (isAnimation) in
            
        }
    }
    
    /**
     cell 点击动画
     */
    func startCellSelectedAnimation(frame: CGRect) {
        
        let imgView = UIImageView()
        imgView.animationImages = [UIImage.init(named: "Preference_selected_1")!,
                                    UIImage.init(named: "Preference_selected_2")!,
                                    UIImage.init(named: "Preference_selected_3")!,
                                    UIImage.init(named: "Preference_selected_4")!,
                                    UIImage.init(named: "Preference_selected_5")!,
                                    UIImage.init(named: "Preference_selected_6")!,
                                    UIImage.init(named: "Preference_selected_7")!]
        
        imgView.animationRepeatCount = 1
        imgView.animationDuration = 0.7
        imgView.frame = frame
        collectionView.addSubview(imgView)
        
        imgView.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            imgView.removeFromSuperview()
        }
    }
    
    /**
     设置列表数据
     */
    func setPrefercenceData(_ data: [UserPerferenceEntity]) {
        self.data = data
        self.collectionLayout.dataAry = self.data
        self.collectionView.reloadData()
    }
    
    /**
     拼接列表数据
     */
    func appendPrefercenceData(_ data: [UserPerferenceEntity]) {
        self.data += data
        self.collectionLayout.dataAry = self.data
        self.collectionView.reloadData()
    }

}


//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ReadingPrefercenceCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PrefercenceCell
        item.titleLabel.text = data[indexPath.item].name
        item.setSelected(data[indexPath.item].isSelected)
        
        if selectedData.count >= 5 {
            if data[indexPath.item].isSelected {
                item.setSelected(data[indexPath.item].isSelected)
            }else {
                item.setProhibitClick()
            }
        }
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        isCellAnimation = false
        
        let item = collectionView.cellForItem(at: indexPath) as! PrefercenceCell
        if item.currentSelected {   // 已经选中，点击清除
            
            var i = 0
            let dataId = data[indexPath.row].id
            for model in selectedData {
                if model.id == dataId {
                    self.selectedData.remove(at: i)
                    break
                }
                
                i += 1
            }
            
            item.setSelected(false)
            data[indexPath.row].isSelected = false
        }else { // 未选中，点击选中
            
            if self.selectedData.count >= 5 {
                return
            }
            
            item.setSelected(true)
            data[indexPath.row].isSelected = true
            startCellSelectedAnimation(frame: item.convert(item.imageView.frame, to: collectionView))
            self.selectedData.append(data[indexPath.row])
        }
        
        collectionView.reloadData()
        self.selectedDataBlock?(self.selectedData)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        animationWidth(cell: cell)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        beginDraggingOffSet = scrollView.contentOffset
        isCellAnimation = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.x > beginDraggingOffSet.x { // 向右滚动
            isCellAnimation = true
            cellScrollerdDirection = .right
        }else { // 向左滚动
            isCellAnimation = true
            cellScrollerdDirection = .left
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isCellAnimation = false
    }
}
