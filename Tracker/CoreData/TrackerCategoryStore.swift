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
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "categoryName", ascending: true)]
//        
//        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
//                                                             managedObjectContext: context,
//                                                             sectionNameKeyPath: nil,
//                                                             cacheName: nil)
//        fetchedResultController?.delegate = self
        
        let categories = try context.fetch(fetchRequest)
        
        
//        do {
//            try fetchedResultController?.performFetch()
//            print("ВЫПОЛНЕНА ПОДГРУЗКА СПИСКА КАТЕГОРИЙ ИЗ CORE DATA")
//        } catch {
//            print("ОШИБКА ВЫЗОВА fetchedResultController ПРИ ЗАГРУЗКЕ СПИСКА КАТЕГОРИЙ: \(error.localizedDescription)")
//        }
        
//        return fetchedResultController?.fetchedObjects ?? []
        return categories.compactMap({$0.categoryName})
    }
    
}
