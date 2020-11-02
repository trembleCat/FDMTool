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

class SelectClassViewController: UBaseViewController {

    let gradeItemView = UIView()
    let gradeLabel = UILabel()
    
    let classItemView = UIView()
    let classLabel = UILabel()
    
    var gradePickerView:FWPickerView!
    var classPickerView:FWPickerView!
    
    var request:UpdateSchoolRequest!
    var showNextBtn:Bool = false
    
    public convenience init(request: UpdateSchoolRequest,showNextBtn:Bool = false) {
        self.init()
        self.request = request
        self.showNextBtn = showNextBtn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "选择班级"

        if self.showNextBtn {
            self.okBarButtonItem.title = "下一步"
        }else{
            self.okBarButtonItem.title = "确定"
        }
        self.navigationItem.rightBarButtonItem = okBarButtonItem
        prepareUI()
        
        classPickerView = FWPickerView.date(confirmBlock: {[weak self] (title) in
            self?.classLabel.text = title
            }, suffix: "班", maxSize: 100)
        
        gradePickerView = FWPickerView.date(confirmBlock: {[weak self] (title) in
            self?.gradeLabel.text = title
            }, suffix: "年级", maxSize: 12)
        
    }

    func nextTapped(classTxt:String, gradeTxt:String){
        request.className = classTxt
        request.gradeName = gradeTxt
        
        self.navigationController?.pushViewController(SetUserNameViewController(request:request), animated:true)
    }
    
    func submitTapped(classTxt:String, gradeTxt:String){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "正在提交数据"
        hud.show(in:self.view)
        
        request.className = classTxt
        request.gradeName = gradeTxt
        
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
        guard let gradeTxt = self.gradeLabel.text, let classTxt = self.classLabel.text else {
            return
        }
        
        if gradeTxt == ""{
            SXToast.showToastAction(message: "请选择年级！")
            return
        }else if classTxt == ""{
            SXToast.showToastAction(message: "请选择班级！")
            return
        }
       
        if self.showNextBtn {
            nextTapped(classTxt: classTxt , gradeTxt:gradeTxt)
        }else{
            submitTapped(classTxt: classTxt , gradeTxt:gradeTxt)
        }
    }
    
    
    @objc func selectGradeAction(_ sender: Any) {
        gradePickerView.show()
    }
    
    @objc func selectClassAction(_ sender: Any) {
        classPickerView.show()
    }
}
