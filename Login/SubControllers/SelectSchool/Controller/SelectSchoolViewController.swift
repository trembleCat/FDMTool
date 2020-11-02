//
//  AccountViewController.swift
//  SXReaderS
//
//  Created by 刘涛 on 2019/7/2.
//  Copyright © 2019 FolioReader. All rights reserved.
//

import Foundation
import SwiftyStoreKit
import JGProgressHUD
import FWPopupView

class SelectSchoolViewController: UBaseViewController {
    let selectedTipsLabel = UILabel()
    let itemView1 = UIView()
    let areaLabel = UILabel()
    let schoolFiled = UITextField()
    let titleLabel = UILabel()
    let emptyView = UIView()
    
    let helpIconView = UIImageView.init(image: UIImage.init(named: "help_icon"))
    var request:UpdateSchoolRequest!
    
    var province: CityEntity!
    var city: CityEntity!
    var area: CityEntity!
    
    var showNextBtn:Bool = false
    var currentSchool:SchoolEntity!
    
    private var datas = [SchoolEntity]()
    
    lazy var resultTableView: UITableView = {
        let rw = UITableView(frame: CGRect.zero, style: .plain)
        rw.backgroundColor = UIColor.backgroundPrimary
        rw.delegate = self
        rw.dataSource = self
        rw.separatorStyle = .none
        rw.keyboardDismissMode = .onDrag
        rw.register(cellType: SchoolCell.self)
        rw.uHead = URefreshHeader{ [weak self] in  self?.loadData()}
        
        rw.emptyDataSetView({[weak self]view in
            let imageView = UIImageView(image: UIImage(named: "no_data"))
            let tipLabel = UILabel()
            tipLabel.textAlignment = NSTextAlignment.center
            tipLabel.textColor = UIColor.textPrimaryDark
            tipLabel.font = UIFont.systemFont(ofSize: 14)
            tipLabel.text = "搜索不到目标学校~"
            self?.emptyView.backgroundColor = .backgroundPrimary
            self?.emptyView.addSubview(imageView)
            imageView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(60)
            }
            
            self?.emptyView.addSubview(tipLabel)
            tipLabel.snp.makeConstraints {
                $0.centerX.width.equalToSuperview()
                $0.top.equalTo(imageView.snp.bottom).offset(20)
            }
            
            view.customView(self?.emptyView)
            self?.emptyView.snp.makeConstraints {
                $0.top.bottom.left.right.equalToSuperview()
            }
        })
        
        return rw
    }()
    
    lazy var areaPopView: SelectAreaPopupView = {
        
        let customPopupView = SelectAreaPopupView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight * 0.8))
        
        let vProperty = FWPopupViewProperty()
        vProperty.popupCustomAlignment = .bottomCenter
        vProperty.popupAnimationType = .frame
        vProperty.maskViewColor = UIColor(white: 0, alpha: 0.5)
        vProperty.touchWildToHide = "0"
        vProperty.popupViewEdgeInsets = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        vProperty.animationDuration = 0.2
        customPopupView.vProperty = vProperty
        customPopupView.delegate = self
        return customPopupView
    }()
    
    public convenience init(request: UpdateSchoolRequest , showNextBtn:Bool = false) {
        self.init()
        self.request = request
        self.showNextBtn = showNextBtn
        self.showBackBarBtnItem = !showNextBtn //如果展示下一步按钮，则不展示返回按钮
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPrimary
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(handleTap(sender:))))
        self.navigationItem.title = "选择学校"
        if self.showNextBtn {
            self.okBarButtonItem.title = "下一步"
        }else{
            self.okBarButtonItem.title = "确定"
        }
        self.navigationItem.rightBarButtonItem = okBarButtonItem
        self.schoolFiled.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        self.schoolFiled.delegate = self
        prepareUI()
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            schoolFiled.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
    func nextTapped() {
        self.schoolFiled.resignFirstResponder()
        if province == nil || city ==  nil || area == nil {
            SXToast.showToastAction(message: "请先选择地区")
            return
        }else if currentSchool == nil {
            SXToast.showToastAction(message: "请选择学校！")
            return
        }
        
        request.schoolName = currentSchool.name
        request.schoolId = currentSchool.id
        request.provinceId = province.id
        request.cityId = city.id
        request.countyId = area.id
        
        self.navigationController?.pushViewController(SelectClassViewController(request:request,showNextBtn: showNextBtn), animated:true)
    }
    
    func submitData(){
        self.schoolFiled.resignFirstResponder()
        if province == nil || city ==  nil || area == nil {
            SXToast.showToastAction(message: "请先选择地区")
            return
        }else if currentSchool == nil {
            SXToast.showToastAction(message: "请选择学校！")
            return
        }
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "正在提交数据"
        hud.show(in:self.view)
        
        request.schoolName = currentSchool.name
        request.schoolId = currentSchool.id
        
        HTTPProvider<UserApi<DBModel>>().request(.updateUserRegisterOrgInfo(request: request), responseHandler: {[weak self] response in
            hud.dismiss()
            if response.success{
                self?.navigationController?.popViewController(animated: true)
            } else{
                SXToast.showToast(message: response.message, aLocationStr: "bottom", aShowTime: 3.0)
            }
        })
    }
    
    @objc override func okTapped(_ sender: UIBarButtonItem) {
        if showNextBtn {
            nextTapped()
        }else{
            submitData()
        }
        
    }
    
    @objc func selectAreaAction(_ sender: Any) {
        self.province = nil
        self.city = nil
        self.area = nil
        areaPopView.show()
    }
    
    
    func loadData(){
        if province == nil || city ==  nil || area == nil {
            SXToast.showToastAction(message: "请先选择地区")
            return
        }
        
        let condition = schoolFiled.text
        HTTPProvider<UserApi<SchoolListResponse>>().request(.getSchoolByArea(provinceId: province.id, cityId: city.id, areaId: area.id, condition: condition!), responseHandler: {[weak self] response in
            self!.resultTableView.uHead.endRefreshing()
            self?.datas.removeAll()
            
            if let response = response.value{
                self?.datas.append(contentsOf: response.list)
            } else{
                SXToast.showToast(message: response.message, aLocationStr: "bottom", aShowTime: 3.0)
            }
            
            self?.resultTableView.reloadData()
        })
    }
    
    @objc func popHelpView(){
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

extension SelectSchoolViewController:AreaBackDelegate , UITextFieldDelegate , SchoolPopBackDelegate{
    func goNextViewController(schoolName: String) {
        self.schoolFiled.textAlignment = .right
        self.schoolFiled.text = schoolName
        self.currentSchool = SchoolEntity()
        self.currentSchool.name = schoolName
        loadData()
    }
    
    func delegate(province: CityEntity, city: CityEntity, area: CityEntity) {
        self.province = province
        self.city = city
        self.area = area
        self.currentSchool = nil
        self.areaLabel.text = province.name + city.name + area.name
        self.schoolFiled.text = ""
        self.selectedTipsLabel.isHidden = false
        self.resultTableView.isHidden = false
        self.helpIconView.isHidden = false
        loadData()
    }
    
    @objc func textDidChange(_ textField:UITextField){
        self.currentSchool = nil
        loadData()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if province == nil || city ==  nil || area == nil {
            SXToast.showToastAction(message: "请先选择地区")
            return false
        }
        
        textField.textAlignment = .right
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == nil || textField.text == "" {
            textField.textAlignment = .left
        }
    }
}

extension SelectSchoolViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = datas[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SchoolCell.self)
        cell.model = model
        if currentSchool != nil && currentSchool.name == model.name {
            cell.selectedItem = true
        }else{
            cell.selectedItem = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentSchool = datas[indexPath.row]
        self.schoolFiled.textAlignment = .right
        self.schoolFiled.text = currentSchool.name
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
}
