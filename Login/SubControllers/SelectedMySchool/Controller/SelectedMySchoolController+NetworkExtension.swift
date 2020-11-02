//
//  SelectedMySchoolController+NetworkExtension.swift
//  SXReaderS
//
//  Created by 发抖喵 on 2020/9/8.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import UIKit
import JGProgressHUD

//MARK: - Network
extension SelectedMySchoolController {
    
    /**
     加载地区数据 id = 1 为获取省数据
     */
    func loadData(id:String){
        selectedEnable = false
        
        HTTPProvider<UserApi<CityResponse>>().request(.getCityById(id:id), responseHandler: {[weak self] response in
            
            self?.loadSchoolTipsView.stopAnimation()
            self?.loadSchoolTipsView.isHidden = true
            
            if let response = response.value{
                self?.cityDict.removeAll()
                self?.keysArray.removeAll()
                
                for item in response.list {
                    if self?.cityDict[item.first] != nil {
                        self?.cityDict[item.first]?.append(item)
                    } else {
                        self?.cityDict[item.first] = [item]
                    }
                }
                
                // 将addressBookDict字典中的所有Key值进行排序: A~Z
                let optionKey: Dictionary<String, [CityEntity]>.Keys = ["":[]].keys
                let cityDicKeys = self?.cityDict.keys ?? optionKey
                let nameKeys = Array(cityDicKeys).sorted()
                self?.keysArray.append(contentsOf: nameKeys)
            } else{
                SXToast.showToast(message: response.message, aLocationStr: "bottom", aShowTime: 3.0)
            }
            
            self?.regionTableView.reloadData()
            self?.regionTableView.contentOffset = CGPoint(x: 0, y: 0)
            self?.selectedEnable = true
        })
    }
    
    /**
     加载学校数据
     */
    func loadSchoolData(provinceId: String, cityId: String, areaId: String){
        selectedEnable = false
        
        HTTPProvider<UserApi<SchoolListResponse>>().request(.getSchoolByArea(provinceId: provinceId, cityId: cityId, areaId: areaId, condition: ""), responseHandler: {[weak self] response in
            
            if let response = response.value {
                
                var schoolDataAry = [String: [SchoolEntity]]()
                var schoolKeysAry = [String]()
                
                for item in response.list {
                    
                    if schoolDataAry[item.simpleName] != nil {
                        schoolDataAry[item.simpleName]?.append(item)
                    } else {
                        schoolDataAry[item.simpleName] = [item]
                    }
                }
                
                
                // 将字典中的所有Key值进行排序: A~Z
                let nameKeys = Array(schoolDataAry.keys).sorted()
                schoolKeysAry.append(contentsOf: nameKeys)
                
                // 设置数据
                self?.schoolTableView.setKeysArray(schoolKeysAry, dataAry: schoolDataAry)
                
                self?.schoolTableView.isHidden = false
                self?.selectedEnable = true
                
                self?.loadSchoolTipsView.stopAnimation()
                self?.loadSchoolTipsView.isHidden = true
            }
        })
    }
}
