//
//  TrackerStore.swift
//  Tracker
//
//  Created by Олег Кор on 01.12.2024.
//

import UIKit
import CoreData

final class TrackerStore: NSObject, NSFetchedResultsControllerDelegate {
    static let shared = TrackerStore()
    private override init() {}
    
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchedResultController: NSFetchedResultsController<TrackerCoreData>?
    
    /// Функция записи параметров нового трекера в CoreData
    func saveTrackerToCoreData(tracker: Tracker, categoryName: String) {
        
        let trackerCoreDataEntity = TrackerCoreData(context: context)
        let trackerCategoryCoreData = try? getCoreDataFromCategory(categoryName: categoryName)
        let stringTrackerSchedule = CoreDataScheduleTransformer.shared.daysToString(days: tracker.trackerShedule)
        
        trackerCoreDataEntity.id = tracker.id
        trackerCoreDataEntity.trackerName = tracker.trackerName
        trackerCoreDataEntity.trackerColor = tracker.trackerColor.toHexString()
        trackerCoreDataEntity.trackerEmoji = tracker.trackerEmoji
        trackerCoreDataEntity.trackerShedule = stringTrackerSchedule
        trackerCoreDataEntity.trackerType = tracker.trackerType
        trackerCoreDataEntity.pinned = tracker.pinned
        
        trackerCoreDataEntity.categoryLink = trackerCategoryCoreData
        trackerCategoryCoreData?.addToTrackersInCategory(trackerCoreDataEntity)
        
        do {
            try context.save()
            print("ТРЕКЕР С НОМЕРОМ \(tracker.id), ИМЕНЕМ \(tracker.trackerName), КАТЕГОРИЕЙ \(categoryName) ЗАГРУЖЕН В CORE DATA.")
        } catch {
            print("ОШИБКА СОХРАНЕНИЯ ТРЕКЕРА С НОМЕРОМ \(tracker.id), ИМЕНЕМ \(tracker.trackerName), КАТЕГОРИЕЙ \(categoryName) В CORE DATA: \(error.localizedDescription)")
        }
    }
    
    /// Функция записи параметров нового трекера в CoreData
    func editTrackerInCoreData(tracker: Tracker, categoryName: String) throws {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        
        let trackerCategoryCoreData = try? getCoreDataFromCategory(categoryName: categoryName)
        let stringTrackerSchedule = CoreDataScheduleTransformer.shared.daysToString(days: tracker.trackerShedule)
        
        do {
            let trackers = try context.fetch(fetchRequest)
            
            guard let newTracker = trackers.first else {
                print("ТРЕКЕР С НОМЕРОМ \(tracker.id) НЕ НАЙДЕН В CORE DATA.")
                return
            }
            
            newTracker.id = tracker.id
            newTracker.trackerName = tracker.trackerName
            newTracker.trackerColor = tracker.trackerColor.toHexString()
            newTracker.trackerEmoji = tracker.trackerEmoji
            newTracker.trackerShedule = stringTrackerSchedule
            newTracker.trackerType = tracker.trackerType
            newTracker.pinned = tracker.pinned
            
            newTracker.categoryLink = trackerCategoryCoreData
//            trackerCategoryCoreData?.addToTrackersInCategory(trackerCoreDataEntity)
            
            do {
                try context.save()
                print("ТРЕКЕР С НОМЕРОМ \(newTracker.id), ИМЕНЕМ \(newTracker.trackerName), КАТЕГОРИЕЙ \(trackerCategoryCoreData) ЗАГРУЖЕН В CORE DATA.")
            } catch {
                print("ОШИБКА РЕДАКТИРОВАНИЯ ТРЕКЕРА С НОМЕРОМ \(newTracker.id), ИМЕНЕМ \(newTracker.trackerName), КАТЕГОРИЕЙ \(trackerCategoryCoreData) В CORE DATA: \(error.localizedDescription)")
            }
        }
    }
    
    /// Функция выгрузки параметров сохраненного в CoreData трекера
    func importCoreDataTracker() -> [TrackerCoreData] {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "trackerName", ascending: true)]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                             managedObjectContext: context,
                                                             sectionNameKeyPath: nil,
                                                             cacheName: nil)
        fetchedResultController?.delegate = self
        
        do {
            try fetchedResultController?.performFetch()
            print("ВЫПОЛНЕНА ПОДГРУЗКА ТРЕКЕРОВ ИЗ CORE DATA")
        } catch {
            print("ОШИБКА ВЫЗОВА fetchedResultController: \(error.localizedDescription)")
        }
        return fetchedResultController?.fetchedObjects ?? []
    }
    
    /// Метод вызова названия категории из CoreData
    private func getCoreDataFromCategory(categoryName: String) throws -> TrackerCategoryCoreData  {
        
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "categoryName == %@", categoryName)
        
        guard let trackerCategoryCoreData = try? context.fetch(fetchRequest).first else {
            let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
            trackerCategoryCoreData.categoryName = categoryName
            return trackerCategoryCoreData
        }
        return trackerCategoryCoreData
    }
    
    /// Метод удаления категории из CoreData
    func deleteTrackerFromCoreData(trackerID: UUID) throws {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", trackerID.uuidString)
        
        do {
            let trackers = try context.fetch(fetchRequest)
            for tracker in trackers {
                context.delete(tracker)
            }
            try context.save()
            print("ЗАПИСЬ О ТРЕКЕРЕ \(trackerID) УСПЕШНО УДАЛЕНА ИЗ CORE DATA.")
        } catch {
            print("ОШИБКА УДАЛЕНИЯ ЗАПИСИ О ТРЕКЕРА \(trackerID) ИЗ CORE DATA: \(error.localizedDescription)")
        }
    }
    
    func pinTracker(trackerID: UUID) {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", trackerID as CVarArg)
        
        do {
            let trackers = try context.fetch(fetchRequest)
            guard let tracker = trackers.first else {
                print("ТРЕКЕР С НОМЕРОМ \(trackerID) НЕ НАЙДЕН В CORE DATA")
                return
            }
            
            tracker.pinned = true
            try context.save()
            print("ТРЕКЕР №\(trackerID) УСПЕШНО ЗАКРЕПЛЕН В CORE DATA.")
        } catch {
            print("ОШИБКА ЗАКРЕПЛЕНИЯ ТРЕКЕРА №\(trackerID) В CORE DATA: \(error.localizedDescription)")
        }
    }
    
    func unPinTracker(trackerID: UUID) {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", trackerID as CVarArg)
        
        do {
            let trackers = try context.fetch(fetchRequest)
            guard let tracker = trackers.first else {
                print("ТРЕКЕР С НОМЕРОМ \(trackerID) НЕ НАЙДЕН В CORE DATA")
                return
            }
            
            tracker.pinned = false
            try context.save()
            print("ТРЕКЕР №\(trackerID) УСПЕШНО ЗАКРЕПЛЕН В CORE DATA.")
        } catch {
            print("ОШИБКА ЗАКРЕПЛЕНИЯ ТРЕКЕРА №\(trackerID) В CORE DATA: \(error.localizedDescription)")
        }
    }
}
