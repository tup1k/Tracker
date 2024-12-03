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
    func saveTrackerToCoreData(id: UUID, trackerName: String, trackerColor: UIColor, trackerEmoji: String, trackerShedule: [Days]) {
        let trackerCoreDataEntity = TrackerCoreData(context: context)
        let stringTrackerSchedule = CoreDataScheduleTransformer.shared.daysToString(days: trackerShedule)
        
        trackerCoreDataEntity.id = id
        trackerCoreDataEntity.trackerName = trackerName
        trackerCoreDataEntity.trackerColor = trackerColor.toHexString()
        trackerCoreDataEntity.trackerEmoji = trackerEmoji
        trackerCoreDataEntity.trackerShedule = stringTrackerSchedule
        
        do {
            try context.save()
            print("ТРЕКЕР С НОМЕРОМ \(id) И ИМЕНЕМ \(trackerName) ЗАГРУЖЕН В CORE DATA.")
        } catch {
            print("ОШИБКА СОХРАНЕНИЯ ТРЕКЕРА С НОМЕРОМ \(id) И ИМЕНЕМ \(trackerName) В CORE DATA: \(error.localizedDescription)")
        }
        
    }
    
    /// Функция выгрузки параметров сохраненного в CoreData трекера
    func importCoreDataTracker() -> [TrackerCoreData] {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                             managedObjectContext: context,
                                                             sectionNameKeyPath: nil,
                                                             cacheName: nil)
        fetchedResultController?.delegate = self
        
        do {
            try fetchedResultController?.performFetch()
        } catch {
            print("ОШИБКА ВЫЗОВА fetchedResultController: \(error.localizedDescription)")
        }
        
       return fetchedResultController?.fetchedObjects ?? []
    }
}
