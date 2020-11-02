//
//  SelectAreaPopupView.swift
//  SXReaderS
//
//  Created by 刘涛 on 2020/2/21.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import Foundation
import UIKit
import FWPopupView
import RealmSwift

//定义协议
@objc protocol AreaBackDelegate {
    func delegate(province:CityEntity,city:CityEntity,area:CityEntity)
}

class SelectAreaPopupView: FWPopupView {
     weak var delegate:AreaBackDelegate?
    
    var cityDict = [String:[CityEntity]]()
    var keysArray = [String]()
    var citysArray = [CityEntity]()
    var tabIndex = 0
    
    let cityLine = UIView()
    let cityLabel = UILabel()
    let areaLine = UIView()
    let areaLabel = UILabel()
    let provinceLine = UIView()
    let provinceLabel = UILabel()
    
    var provinceEntity:CityEntity!
    var cityEntity:CityEntity!
    var areaEntity:CityEntity!
    
    lazy var tableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .plain)
        tw.backgroundColor = UIColor.backgroundPrimary
        tw.delegate = self
        tw.dataSource = self
        tw.separatorStyle = .none
        tw.sectionIndexColor = UIColor.textPrimaryDark
        tw.register(cellType: CityCell.self)
        tw.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 67, right: 0)
        return tw
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.backgroundPrimary
        
        let titleLabel = UILabel()
        titleLabel.text = "选择地区"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
        }
        
        let closeBtn = UIImageView.init(image: UIImage.init(named: "popview_close_icon"))
        closeBtn.contentMode = .center
        closeBtn.isUserInteractionEnabled = true
        let signTapGesture = UITapGestureRecognizer(target: self, action: #selector(closeAction))
        closeBtn.addGestureRecognizer(signTapGesture)
        self.addSubview(closeBtn)
        closeBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalTo(titleLabel)
            $0.width.height.equalTo(40)
        }
        
        
        provinceLabel.text = "请选择"
        provinceLabel.isUserInteractionEnabled = true
        provinceLabel.textColor = UIColor.textPrimaryDark
        provinceLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(provinceAction)))
        provinceLabel.font = UIFont.systemFont(ofSize: 16)
        self.addSubview(provinceLabel)
        provinceLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.top.equalTo(titleLabel).offset(50)
        }
        
        provinceLine.backgroundColor = UIColor.theme
        self.addSubview(provinceLine)
        provinceLine.snp.makeConstraints {
            $0.left.right.equalTo(provinceLabel)
            $0.top.equalTo(provinceLabel.snp.bottom).offset(5)
            $0.height.equalTo(3)
        }
        
        
        cityLabel.text = "请选择"
        cityLabel.isHidden = true
        cityLabel.isUserInteractionEnabled = true
        cityLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cityAction)))
        cityLabel.font = UIFont.systemFont(ofSize: 16)
        cityLabel.textColor = UIColor.textPrimaryDark
        self.addSubview(cityLabel)
        cityLabel.snp.makeConstraints {
            $0.left.equalTo(provinceLabel.snp.right).offset(45)
            $0.centerY.equalTo(provinceLabel)
        }
        
        cityLine.isHidden = true
        cityLine.backgroundColor = UIColor.theme
        self.addSubview(cityLine)
        cityLine.snp.makeConstraints {
            $0.left.right.equalTo(cityLabel)
            $0.top.equalTo(cityLabel.snp.bottom).offset(5)
            $0.height.equalTo(3)
        }
        
        
        areaLabel.text = "请选择"
        areaLabel.isHidden = true
        areaLabel.textColor = UIColor.textPrimaryDark
        self.addSubview(areaLabel)
        areaLabel.snp.makeConstraints {
            $0.left.equalTo(cityLabel.snp.right).offset(45)
            $0.centerY.equalTo(provinceLabel)
        }
        
        areaLine.isHidden = true
        areaLine.backgroundColor = UIColor.theme
        self.addSubview(areaLine)
        areaLine.snp.makeConstraints {
            $0.left.right.equalTo(areaLabel)
            $0.top.equalTo(areaLabel.snp.bottom).offset(5)
            $0.height.equalTo(3)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.divider
        self.addSubview(lineView)
        lineView.snp.makeConstraints {
            $0.top.equalTo(provinceLine.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(0.7)
        }
        
        self.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-15)
        }
        
        loadData(id: "1")
    }
    
    @objc func closeAction(_ sender: Any) {
        self.hide()
    }
    
    @objc func provinceAction() {
        if tabIndex != 0{
            selectedProvinceTab()
            loadData(id:"1")
        }
    }
    
    @objc func cityAction() {
        if provinceEntity != nil && tabIndex == 2{
            selectedCityTab()
            loadData(id:provinceEntity.id)
        }
    }
    
    
    func loadData(id:String){
        HTTPProvider<UserApi<CityResponse>>().request(.getCityById(id:id), responseHandler: {[weak self] response in
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
                let nameKeys = Array(self!.cityDict.keys).sorted()
                self!.keysArray.append(contentsOf: nameKeys)
            } else{
                SXToast.showToast(message: response.message, aLocationStr: "bottom", aShowTime: 3.0)
            }
            
            self?.tableView.reloadData()
        })
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SelectAreaPopupView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return keysArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let key = keysArray[section]
        let array = cityDict[key]

        return (array?.count)!
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keysArray[section]
    }

    // 右侧索引
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return keysArray
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CityCell.self)
        
        let modelArray = cityDict[keysArray[indexPath.section]]
        let model = modelArray![indexPath.row]

        cell.model = model
        cell.showIndex = indexPath.row == 0
        
        if self.tabIndex == 0 && self.provinceEntity != nil && self.provinceEntity.id==model.id{
            cell.selectedItem = true
        }else if self.tabIndex == 1 && self.cityEntity != nil && self.cityEntity.id==model.id{
            cell.selectedItem = true
        }else if self.tabIndex == 2 && self.areaEntity != nil && self.areaEntity.id==model.id{
            cell.selectedItem = true
        }else{
            cell.selectedItem = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let modelArray = cityDict[keysArray[indexPath.section]]
        let model = modelArray![indexPath.row]
        if self.tabIndex == 0{
            self.tabIndex = 1
            self.provinceLabel.text = model.name
            self.provinceEntity = model
            self.selectedCityTab()
            self.loadData(id:model.id)
        }else if self.tabIndex == 1{
            self.tabIndex = 2
            self.cityEntity = model
            self.cityLabel.text = model.name
            self.selectedAreaTab()
            self.loadData(id:model.id)
        }else if self.tabIndex == 2{
            self.areaEntity = model
            self.areaLabel.text = model.name
            if delegate != nil {
                delegate?.delegate(province: provinceEntity, city: cityEntity, area: areaEntity)
            }
            self.hide()
        }
        
        tableView.reloadData()
    }
    
    func selectedProvinceTab(){
        cityLabel.text = "请选择"
        areaLabel.text = "请选择"
        cityLabel.isHidden = true
        areaLabel.isHidden = true
        cityLine.isHidden = true
        provinceLine.isHidden = false
        areaLine.isHidden = true
        tabIndex = 0
        cityEntity = nil
        areaEntity = nil
    }
    
    func selectedCityTab(){
        areaLabel.text = "请选择"
        cityLabel.isHidden = false
        areaLabel.isHidden = true
        cityLine.isHidden = false
        provinceLine.isHidden = true
        areaLine.isHidden = true
        tabIndex = 1
        areaEntity = nil
    }
    
    func selectedAreaTab() {
        areaLabel.isHidden = false
        cityLine.isHidden = true
        provinceLine.isHidden = true
        areaLine.isHidden = false
        tabIndex = 2
    }
}

