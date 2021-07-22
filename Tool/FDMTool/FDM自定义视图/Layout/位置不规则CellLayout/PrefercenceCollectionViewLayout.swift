//
//  PrefercenceCollectionViewLayout.swift
//  SXReaderS
//
//  Created by 发抖喵 on 2020/9/10.
//  Copyright © 2020 FolioReader. All rights reserved.
//
//MARK: - 阅读偏好不规则距离CellLayout

import UIKit

class PrefercenceCollectionViewLayout: UICollectionViewFlowLayout {
    
    var itemHeight: CGFloat = 40
    var space: CGFloat = 20
    
    var count = 0
    var pageCount = 0
    
    var dataAry = [UserPerferenceEntity]()
    var attributeWidthAry = [CGFloat]()
    var attributeAry = [UICollectionViewLayoutAttributes]()
    
    var itemSpace: CGFloat {
        get {
            return FDMTool.getArc4random(start: 15, end: 30)
        }
    }
    
    var startX: CGFloat {
        get {
            return FDMTool.getArc4random(start: 10, end: 60)
        }
    }
    
    override func prepare() {
        super.prepare()
        
        createAction()
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributeAry
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        return attributeAry[indexPath.row]
    }
    
    /// 返回滚动范围
    override var collectionViewContentSize: CGSize {
        return CGSize(width: (pageCount + 1) * (self.collectionView?.width ?? 200), height: 0)
    }
}


//MARK: - Action
extension PrefercenceCollectionViewLayout {
    func createAction() {
        count = self.collectionView?.numberOfItems(inSection: 0) ?? 0
        
        guard dataAry.count > 0 else {return}
        self.configAllItemWidth()
        self.reckonValue()
    }
    
    /**
     计算所有值坐标 -- 子线程
     */
    private func reckonValue() {
        guard count > 0 && count > attributeAry.count else { return }
        
        pageCount = 0
        for currentTag in 1...count{
            let indexPath = IndexPath.init(item: currentTag - 1, section: 0)
            self.attributeAry.append(reckonValueWith(indexPath: indexPath))
        }
    }
    
    /// 计算某个值坐标返回位置属性 currentTag: 第几个 modifySize：是否修改size
    private func reckonValueWith(indexPath: IndexPath) -> UICollectionViewLayoutAttributes{
        
        if indexPath.row == 0 {
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attribute.frame = CGRect(x: FDMTool.getArc4random(start: 20, end: 50), y: 0, width:  attributeWidthAry[0] , height: itemHeight)
            
            return attribute
        }else {
            // 获取上一个frame
            let itemFrame = self.attributeAry[indexPath.row - 1].frame
            // 获取collectionFrame
            let collectionFrame = self.collectionView?.frame
            
            // 计算新 item 的Y值
            var newItemY = itemFrame.origin.y
            
            // 计算新item 的X值 (随机的间距)
            var newItemX = itemFrame.origin.x + itemFrame.width + itemSpace
            
            if newItemX + attributeWidthAry[indexPath.row] >= collectionFrame?.size.width ?? 200 { // x超出当前页
                
                // 新坐标所在页面
                let itemPage = floor((newItemX + attributeWidthAry[indexPath.row]) / (collectionFrame?.size.width ?? 200))
                
                // 判断x是在当前页面还是需要新的页面 (随机的开始距离)
                if Int(itemPage) > pageCount { // x 在新的页面
                    
                    if newItemY + itemHeight * 2 + space > collectionFrame?.size.height ?? 200 {    // y超出当前页 - 新的页面
                        pageCount += 1
                        
                        newItemY = 0
                        newItemX = startX + (collectionFrame?.size.width ?? 200) * pageCount
                    }else { // 换行
                        
                        newItemX = startX + (collectionFrame?.size.width ?? 200) * pageCount
                        newItemY = itemFrame.origin.y + itemHeight + space
                    }
                    
                }
            }
            
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attribute.frame = CGRect(x: newItemX, y: newItemY, width:  attributeWidthAry[indexPath.row] , height: itemHeight)
            
            return attribute
        }
    }
    
    /**
    计算所有Item宽度
    */
    func configAllItemWidth(){
        guard count > attributeWidthAry.count else { return }
        attributeWidthAry.removeAll()
        
        // 计算所有item高度
        for data in self.dataAry {
            let width = labelWidth(data.name, 21)
            attributeWidthAry.append(width + 20)
        }
    }
    
    /**
     计算文本宽度
     */
    func labelWidth(_ text: String, _ height: CGFloat) -> CGFloat {
        let size = CGSize(width: 2000, height: height)
        let font = UIFont(name: "PingFang-SC-Regular", size: height)!
        let attributes = [NSAttributedString.Key.font: font]
        let labelSize = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return labelSize.width
    }
}
