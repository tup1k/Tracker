//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Олег Кор on 01.12.2024.
//

import UIKit
import CoreData

final class TrackerCategoryStore: NSObject {
    static let shared = TrackerCategoryStore()
    private override init() {}
    
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /// Метод сохранения категорий в CoreData - TODO (16 спринт)
    func saveCategoryToCoreData(categoryName: String, categoryTrackers: [Tracker] ) {
        
        let trackerCategoryCoreDataEntity = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreDataEntity.categoryName = categoryName
        
        do {
            try context.save()
            print("ТРЕКЕРЫ КАТЕГОРИИ \(categoryName) ЗАГРУЖЕН В CORE DATA.")
        } catch {
            print("ОШИБКА СОХРАНЕНИЯ \(categoryName) В CORE DATA: \(error.localizedDescription)")
        }
        
    }
    
    /// Метод выгрузки актуальных категорий из CoreData - TODO (16 спринт)
    func importCoreDataCategory() {
        
    }
    
}
