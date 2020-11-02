//
//  JoinByIdentificationCodeController.swift
//  SXReaderS
//
//  Created by 刘毅 on 2020/7/23.
//  Copyright © 2020 FolioReader. All rights reserved.
//  参与测评controller

import UIKit

class JoinByIdentificationCodeController: UBaseViewController {
    private var textFidld: UITextField!
    private var dataInfo: TourstInfoEntity?
    private var evalUserId: String?
    private var userData: CreateEvalutionUserResponse?
    private var sureBtn: UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "参与测评"
        
        //绘制大背景图片
        let imageBg = UIImage(named: "evalution_code_signin_big_bg")
        let imageBgView = UIImageView(image: imageBg)
        imageBgView.isUserInteractionEnabled = true
       let tap = UITapGestureRecognizer(target: self, action: #selector(tapView))
        imageBgView.addGestureRecognizer(tap)
        self.view.addSubview(imageBgView)
        imageBgView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
      //绘制小的背景图
        let imgBg = UIImage(named: "evalution_code_signin_little_bg")
        let imgBgView = UIImageView(image: imgBg)
        imgBgView.isUserInteractionEnabled = true
        self.view.addSubview(imgBgView)
        imgBgView.snp.makeConstraints{ (make) in
            make.left.equalToSuperview().offset(37)
            make.right.equalTo(-37)
            make.top.equalTo(117 * kAutoSizeScaleY)
            make.height.equalTo(382 * kAutoSizeScaleX)
        }
        
        //标题
        let titleLabel = UILabel()
        titleLabel.text = "口令"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = UIColor.textBlackPrimary
        imgBgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{ (make) in
                make.top.equalToSuperview().offset(38 * kAutoSizeScaleX)
                make.width.equalTo(imgBgView.snp.width)
                make.height.equalTo(28 * kAutoSizeScaleX)
        }
        
        //输入提示
        let entryTipLabel = UILabel()
        entryTipLabel.text = "请输入口令"
        entryTipLabel.font = UIFont.systemFont(ofSize: 14)
        entryTipLabel.textAlignment = .center
        entryTipLabel.textColor = UIColor.textPrimaryDark
        imgBgView.addSubview(entryTipLabel)
        entryTipLabel.snp.makeConstraints{ (make) in
                   make.top.equalToSuperview().offset(150 * kAutoSizeScaleX)
                   make.width.equalTo(imgBgView.snp.width)
                   make.height.equalTo(20 * kAutoSizeScaleX)
        }
        
        //文本输入框
        let identificationCodeField = UITextField()
        textFidld = identificationCodeField
        textFidld.keyboardType = .numberPad
        textFidld.delegate = self as! UITextFieldDelegate
        identificationCodeField.borderStyle = UITextField.BorderStyle.roundedRect
        identificationCodeField.textColor = UIColor.textBlackPrimary
        identificationCodeField.textAlignment = NSTextAlignment.center
        identificationCodeField.placeholder = "请输入识别码"
        identificationCodeField.font = UIFont.systemFont(ofSize: 16)
        imgBgView.addSubview(identificationCodeField)
        identificationCodeField.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(190 * kAutoSizeScaleX)
            make.left.equalTo(40 * kAutoSizeScaleX)
            make.right.equalTo(-40 * kAutoSizeScaleX)
            make.height.equalTo(46 * kAutoSizeScaleX)
        }
        
        //确定按钮
        let sureButton = UIButton(type: .custom)
        sureBtn = sureButton
        sureButton.backgroundColor = UIColor.theme
        sureButton.setTitle("确定", for: .normal)
        sureButton.setTitleColor(UIColor.textBlackPrimary, for: .normal)
        sureButton.cornerRadius = 22 * kAutoSizeScaleX
        sureButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        sureButton.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        imgBgView.addSubview(sureButton)
        sureButton.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(286 * kAutoSizeScaleX)
            make.left.equalTo(80 * kAutoSizeScaleX)
            make.right.equalTo(-80 * kAutoSizeScaleX)
            make.height.equalTo(44 * kAutoSizeScaleX)
        }
    }
    
    @objc func tapView() {
        view.endEditing(true)
    }
    
    @objc func btnAction() {
        sureBtn?.isUserInteractionEnabled = false
        if textFidld.text?.count ?? 0 > 0 {
            view.endEditing(true)
            HTTPProvider<EvaluationCopyApi<TourstInfoEntity>>().request(.getSchoolInfoByPassword(password: textFidld.text ?? ""), responseHandler: { response in
                if response.success && response.code == 200 {
                    self.dataInfo = response.value
                    //1、添加游客到测评用户
                    self.creatUser()
                }else{
                    SXToast.showToastAction(message: response.message)
                    self.sureBtn?.isUserInteractionEnabled = true
                }
                
            })
        }
    }
    
    private func creatUser() {
        let request = QuestionnaireRequest()
        request.userType = 2
        request.schoolName = dataInfo!.schoolName
        request.writeType = 2
        request.needQuestionCode = true
        
        HTTPProvider<EvaluationCopyApi<CreateEvalutionUserResponse>>().request(.createEvalutionUser(request:request), responseHandler: { response in
                if response.success{
                    if response.code == 200 && response.value != nil {
                        self.evalUserId = response.value?.evalUserId
                        self.userData = response.value
                        self.checkQuestionEvalutionId()
                    }else{
                        
                    }
                    
                    }else{
                        SXToast.hiddenIndicatorToastAction()
                        SXToast.showToast(message: response.message, aLocationStr: "bottom", aShowTime: 3.0)
                    self.sureBtn?.isUserInteractionEnabled = false
                    }
                })
            
        }
    
    // 查询问卷调查的测评ID
    private func checkQuestionEvalutionId (){
        HTTPProvider<EvaluationCopyApi<EvalationQuestionResponse>>().request(.getNewEvaluationByType(type:"question"), responseHandler: { response in
            if response.success && response.code == 200 {
                self.sureBtn?.isUserInteractionEnabled = true
                
                let question = QuestionnaireController.init(evaluetionId: response.value?.evaluationId ?? "" , evalUserId: self.evalUserId ?? "")
                question.tourseInfo = self.dataInfo
                question.questionCode = self.userData?.questionCode
                self.navigationController?.pushViewController(question, animated: true)
                
            }
        })
    }
}

extension JoinByIdentificationCodeController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textFidld.text?.count ?? 0 > 9 {
//            return false
//        }
//
//        return true
        
        guard let text = textField.text else{
            return true
        }

        let textLength = text.characters.count + string.characters.count - range.length

        return textLength<=10
        
    }
}
