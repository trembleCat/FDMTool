//
//  FDMCoreDataTool.swift
//  FDMCoreData
//
//  Created by 发抖喵 on 2020/5/13.
//  Copyright © 2020 发抖喵. All rights reserved.
//

import UIKit
import CoreData

class FDMCoreDataTool: NSObject {
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    lazy var storeContainer: NSPersistentContainer = {
       let container = NSPersistentContainer(name: self.modelName)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                debugPrint("FDMCoreDataTool - storeContainer error\(error)")
            }
        })
        return container
    }()
    
    /// 使用managedContext进行增删改查
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    /// 保存
    func saveContext() -> Bool {
        guard managedContext.hasChanges else { return false }
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            debugPrint("FDMCoreDataTool - save error\(error)")
            return false
        }
    }
}
