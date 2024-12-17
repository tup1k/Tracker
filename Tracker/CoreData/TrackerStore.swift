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
//    func saveTrackerToCoreData(id: UUID, trackerName: String, trackerColor: UIColor, trackerEmoji: String, trackerShedule: [Days], trackerType: String) {
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
        
        trackerCoreDataEntity.categoryLink = trackerCategoryCoreData
        trackerCategoryCoreData?.addToTrackersInCategory(trackerCoreDataEntity)
//        trackerCategoryCoreData?.trackersInCategory = trackerCoreDataEntity
        
        do {
            try context.save()
            print("ТРЕКЕР С НОМЕРОМ \(tracker.id), ИМЕНЕМ \(tracker.trackerName), КАТЕГОРИЕЙ \(categoryName) ЗАГРУЖЕН В CORE DATA.")
        } catch {
            print("ОШИБКА СОХРАНЕНИЯ ТРЕКЕРА С НОМЕРОМ \(tracker.id), ИМЕНЕМ \(tracker.trackerName), КАТЕГОРИЕЙ \(categoryName) В CORE DATA: \(error.localizedDescription)")
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
}
