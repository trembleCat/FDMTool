//
//  SetUserNameViewController.swift
//  SXReaderS
//
//  Created by 刘涛 on 2020/2/27.
//  Copyright © 2020 FolioReader. All rights reserved.
//

import Foundation
import SwiftyStoreKit
import JGProgressHUD
import FWPopupView

class SetUserNameViewController: UBaseViewController {
    let userNameFiled = UITextField()
    
    var request:UpdateSchoolRequest!
    
    private var datas = [SchoolEntity]()
    
    public convenience init(request: UpdateSchoolRequest) {
        self.init()
        self.request = request
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(handleTap(sender:))))
        self.navigationItem.title = "设置姓名"
        self.navigationItem.rightBarButtonItem = okBarButtonItem
        prepareUI()
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            userNameFiled.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
    @objc override func okTapped(_ sender: UIBarButtonItem) {
        userNameFiled.resignFirstResponder()
        
        guard let userName = self.userNameFiled.text else {
            return
        }
        
        if userName.isEmpty {
            SXToast.showToast(message: "请输入姓名", aLocationStr: "bottom", aShowTime: 3.0)
            userNameFiled.shake(direction: .horizontal, times: 5, interval: 0.1, delta: 1.8)
            return
        }
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "正在提交数据"
        hud.show(in:self.view)
        
        request.fullName = userName
        
        HTTPProvider<UserApi<DBModel>>().request(.updateUserRegisterOrgInfo(request: request), responseHandler: { response in
            hud.dismiss()
            if response.success{
                let webVC = SXWebViewController(urlString: NetworkConfig.CFirstLoginURL,showNavigation:false)
                self.navigationController?.pushViewController(webVC, animated: true)
            } else{
                SXToast.showToast(message: response.message, aLocationStr: "bottom", aShowTime: 3.0)
            }
        })
    }
    
    
}
