//
//  VerifyEvaluationResponse.swift
//  SXReaderS
//
//  Created by 刘毅 on 2020/7/22.
//  Copyright © 2020 FolioReader. All rights reserved.
//这个是接口verifyEvaluation和verifyEvaluationByDeviceNum的返回数据

import UIKit
import RealmSwift

class VerifyEvaluationResponse: DBModel {
    @objc dynamic var quickEntryDisplay:Bool  = false
    @objc dynamic var myEvaluationDisplay:Bool = false
    @objc dynamic var questionnaireDisplay:Bool = false
    @objc dynamic var evaluationResultDisplay:Bool = false
}
