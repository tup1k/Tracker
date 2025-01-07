//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Олег Кор on 01.12.2024.
//

import UIKit
import CoreData

final class TrackerCategoryStore: NSObject, NSFetchedResultsControllerDelegate {
    static let shared = TrackerCategoryStore()
    private override init() {}
    
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedResultController: NSFetchedResultsController<TrackerCategoryCoreData>?
    
    /// Метод выгрузки трекеров с категорий
    func importCategoryWithTrackersFromCoreData() throws -> [TrackerCategory] {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        var resultCategories = [TrackerCategory]()
        let categories = try context.fetch(fetchRequest)
        
        for category in categories {
            guard let name = category.categoryName, let trackersCoreData = category.trackersInCategory as? Set<TrackerCoreData> else { continue }
        
            let trackers = trackersCoreData.compactMap({ (trackerCoreData: TrackerCoreData) -> Tracker? in
                guard
                    let id = trackerCoreData.id,
                    let name = trackerCoreData.trackerName,
                    let color = UIColor.init(hex: trackerCoreData.trackerColor ?? ""),
                    let emoji = trackerCoreData.trackerEmoji,
                    let type = trackerCoreData.trackerType
                else { return nil }
                
                let pin = trackerCoreData.pinned
                let schedule = CoreDataScheduleTransformer.shared.stringToDays(stringDays: trackerCoreData.trackerShedule ?? "")
                return Tracker(id: id, trackerName: name, trackerColor: color, trackerEmoji: emoji, trackerShedule: schedule, trackerType: type, pinned: pin)
            })
            resultCategories.append(TrackerCategory(categoryName: name, categoryTrackers: trackers))
        }
        return resultCategories
    }
    
    /// Метод сохранения категорий в CoreData
    func saveCategoryToCoreData(categoryName: String) {
        
        let trackerCategoryCoreDataEntity = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreDataEntity.categoryName = categoryName
        
        do {
            try context.save()
            print("НОВАЯ КАТЕГОРИЯ С ИМЕНЕМ \(categoryName) ЗАГРУЖЕНА В CORE DATA.")
        } catch {
            print("ОШИБКА СОХРАНЕНИЯ КАТЕГОРИИ С ИМЕНЕМ \(categoryName) В CORE DATA: \(error.localizedDescription)")
        }
    }
    
    /// Метод корректировки названия категории
    func editCategoryNameToCoreData(categoryName: String, newCategoryName: String) throws {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "categoryName == %@", categoryName)
        let categories = try context.fetch(fetchRequest)
        categories.forEach({$0.categoryName = newCategoryName})
        
        do {
            try context.save()
            print("ВЫПОЛНЕНА СМЕНА ИМЕНИ КАТЕГОРИИ НА \(newCategoryName) И ЗАГРУЗКА В CORE DATA.")
        } catch {
            print("ОШИБКА СОХРАНЕНИЯ НОВОГО ИМЕНИ КАТЕГОРИИ \(newCategoryName) В CORE DATA: \(error.localizedDescription)")
        }
    }
    
    /// Метод удаления категории из CoreData
    func deleteCategoryFromCoreData(_ name: String) throws {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "categoryName == %@", name)
        let categories = try context.fetch(fetchRequest)
        categories.forEach{context.delete($0)}
        
        do {
            try context.save()
            print("КАТЕГОРИЯ С ИМЕНЕМ \(name) УСПЕШНО УДАЛЕНА ИЗ CORE DATA.")
        } catch {
            print("ОШИБКА УДАЛЕНИЯ КАТЕГОРИИ С ИМЕНЕМ \(name) ИЗ CORE DATA: \(error.localizedDescription)")
        }
    }
    
    /// Метод выгрузки актуальных категорий из CoreData
    func importCategoryFromCoreData() throws -> [String] {
        
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        
        let categories = try context.fetch(fetchRequest)

        return categories.compactMap({$0.categoryName})
    }
}
