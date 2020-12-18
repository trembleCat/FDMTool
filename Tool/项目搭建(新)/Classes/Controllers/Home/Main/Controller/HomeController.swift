//
//  HomeController.swift
//  SXReader_2020
//
//  Created by 发抖喵 on 2020/11/24.
//

import UIKit

class HomeController: UIBaseViewController {
    override var name: String {"首页"}

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .colorWithLight(.orange, Dark: .green)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarHidden(false, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = BrilliantBookListController() //标准
//        let vc = EveryDayReadController()
//        let vc = WorkDetailsController(dynamicId: "")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
 
