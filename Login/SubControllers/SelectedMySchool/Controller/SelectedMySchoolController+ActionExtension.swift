//
//  SelectedMySchoolController+ActionExtension.swift
//  SXReaderS
//
//  Created by 发抖喵 on 2020/9/8.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import UIKit

//MARK: - Action
extension SelectedMySchoolController {
    
    func createAction() {
        
        // 设置进度点击事件
        regionProcessView.addTarget(self, action: #selector(self.clickProgressViewWithOne), index: 0)
        regionProcessView.addTarget(self, action: #selector(self.clickProgressViewWithTwo), index: 1)
        regionProcessView.addTarget(self, action: #selector(self.clickProgressViewWithThree), index: 2)
        
        // 设置默认为选择省
        clickProgressViewWithOne()
        
        // 加载省数据
        loadData(id: loadDataIdAry[0])
        selectedIndex = 0
    }
    
    /**
     点击返回按钮
     */
    @objc func clickBarButtonBackItem() {
        self.navigationController?.delegate = nil
        self.navigationController?.popViewController(animated: true)
    }
    
    /**
     点击找不到
     */
    @objc func clickNavRightItem() {
        
        if schoolTableView.isHidden  {  // 没有选省市
            SXToast.showToast(message: "请先选择学校地址", aLocationStr: "bottom", aShowTime: 3.0)
        }else {
            let customPopupView = SelectSchoolHelpPopview(frame: CGRect(x: 25, y: (kScreenHeight-500)/2, width: kScreenWidth - 50 , height: 530))
            customPopupView.vProperty = self.vcProperty
            customPopupView.vProperty.touchWildToHide = "0"
            customPopupView.vProperty.popupCustomAlignment = .center
            customPopupView.vProperty.popupAnimationType = .position
            customPopupView.withKeyboard = true
            customPopupView.delegate = self
            customPopupView.showPop()
        }
    }
    
    /**
     点击省
     */
    @objc func clickProgressViewWithOne() {
        selectedIndex = 0
        setCellTitleIsAnimation = true
        schoolTableView.isHidden = true
        
        regionProcessView.moveHighlightLabelWidth(index: selectedIndex)
        regionProcessView.oneProgressLabel.isUserInteractionEnabled = true
        regionProcessView.twoProgressLabel.isUserInteractionEnabled = false
        regionProcessView.threeProgressLabel.isUserInteractionEnabled = false
        
        clickLoadData()
    }
    
    /**
    点击市
    */
    @objc func clickProgressViewWithTwo() {
        selectedIndex = 1
        setCellTitleIsAnimation = true
        schoolTableView.isHidden = true
        
        regionProcessView.moveHighlightLabelWidth(index: selectedIndex)
        regionProcessView.oneProgressLabel.isUserInteractionEnabled = true
        regionProcessView.twoProgressLabel.isUserInteractionEnabled = true
        regionProcessView.threeProgressLabel.isUserInteractionEnabled = false
        
        clickLoadData()
    }
    
    /**
    点击区
    */
    @objc func clickProgressViewWithThree() {
        selectedIndex = 2
        setCellTitleIsAnimation = true
        schoolTableView.isHidden = true
        
        regionProcessView.moveHighlightLabelWidth(index: selectedIndex)
        regionProcessView.oneProgressLabel.isUserInteractionEnabled = true
        regionProcessView.twoProgressLabel.isUserInteractionEnabled = true
        regionProcessView.threeProgressLabel.isUserInteractionEnabled = true
        
        clickLoadData()
    }
    
    /**
     点击时加载数据
     */
    func clickLoadData() {
        loadData(id: loadDataIdAry[selectedIndex])
        
        let count = loadDataIdAry.count - selectedIndex - 1
        if count > 0 { // 更换选择时移除尾部Id
            for _ in 0 ..< count {
                loadDataIdAry.removeLast()
            }
        }
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension SelectedMySchoolController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return keysArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = keysArray[section]
        let cityEntityAry = cityDict[key]
        
        return cityEntityAry?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! SelectedMySchoolCell
        
        let key = keysArray[indexPath.section]
        let cityEntityAry = cityDict[key]
        let cityEntity = cityEntityAry?[indexPath.row]
        
        // 设置文字延迟动画
        cell.setTitle(cityEntity?.name ?? "", animation: setCellTitleIsAnimation)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard selectedEnable else { return }
        
        let key = keysArray[indexPath.section]
        let cityEntityAry = cityDict[key]
        let cityEntity = cityEntityAry?[indexPath.row]
        let cityId = cityEntity?.id
        
        regionProcessView.setTitle(cityEntity?.name ?? "", index: selectedIndex)
        loadDataIdAry.append(cityId ?? "1")
        
        let cell = tableView.cellForRow(at: indexPath)
        let cellFrame = cell?.frame ?? .zero
        
        loadSchoolTipsView.isHidden = false
        loadSchoolTipsView.frame = CGRect(x: FScreenW - 25, y: cellFrame.origin.y + (cellFrame.height / 2), width: 20, height: 20)
        loadSchoolTipsView.startAnimation()
        
        if selectedIndex == 0 { // 选择省
            
            selectedSchoolModel.provinceId = cityId
            clickProgressViewWithTwo()
        }else if selectedIndex == 1 {   // 选择市
            
            selectedSchoolModel.cityId = cityId
            clickProgressViewWithThree()
        }else if selectedIndex == 2 {   // 选择区
            
            selectedSchoolModel.countyId = cityId
            self.loadSchoolData(provinceId: loadDataIdAry[1], cityId: loadDataIdAry[2], areaId: cityId ?? "")
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        setCellTitleIsAnimation = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setCellTitleIsAnimation = true
    }
}

//MARK: - SchoolPopBackDelegate
extension SelectedMySchoolController: SchoolPopBackDelegate {
    func goNextViewController(schoolName: String) {
        self.selectedSchoolModel.schoolName = schoolName
        self.didSelectShoolBlock?(selectedSchoolModel)
        
        clickBarButtonBackItem()
    }
}
