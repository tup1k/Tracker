//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Олег Кор on 01.12.2024.
//

import UIKit
import CoreData

final class TrackerRecordStore: NSObject {
    static let shared = TrackerRecordStore()
    private override init() {}
    
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /// Функция записи выполнения трекера в CoreData
    func saveRecordToCoreData(id: UUID, trackerDate: Date) {
        let trackerRecordCoreDataEntity = TrackerRecordCoreData(context: context)
        trackerRecordCoreDataEntity.id = id
        trackerRecordCoreDataEntity.trackerDate = trackerDate
     
        do {
            try context.save()
            print("УСПЕШНО ВЫПОЛНЕННЫЙ ТРЕКЕР \(id) ВЫПОЛНЕН \(trackerDate) И ЗАГРУЖЕН В CORE DATA.")
        } catch {
            print("УСПЕШНО ВЫПОЛНЕННЫЙ ТРЕКЕР \(id) ВЫПОЛНЕН \(trackerDate) НО НЕ ЗАГРУЖЕН В CORE DATA: \(error.localizedDescription)")
        }
    }
    
    /// Функция удаления записи о выполнении трекера из CoreData
    func deleteRecordFromCoreData(id: UUID, trackerDate: Date) {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        let calendar = Calendar.current
        let startDay = calendar.startOfDay(for: trackerDate)
        guard let endDay = calendar.date(byAdding: .day, value: 1, to: startDay) else { return }
        
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND date < %@ AND date >= %@", id as CVarArg, startDay as NSDate, endDay as NSDate)
       
        do {
            let trackerRecord = try context.fetch(fetchRequest)
            for record in trackerRecord {
                context.delete(record)
            }
            try context.save()
            print("ЗАПИСЬ О ВЫПОЛНЕНИИ ТРЕКЕРА \(id) ОТ \(trackerDate) УСПЕШНО УДАЛЕНА ИЗ CORE DATA.")
        } catch {
            print("ОШИБКА УДАЛЕНИЯ ЗАПИСИ О ВЫПОЛНЕНИИ ТРЕКЕРА \(id) ОТ \(trackerDate) ИЗ CORE DATA: \(error.localizedDescription)")
        }
    }
    
    /// Функция определяет был ли выполнен выбранный трекер
    func countCoreDataRecordComplete(id: UUID) -> Int {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "id == %@" , id as CVarArg)
        
        do {
            let trackerRecord = try context.fetch(fetchRequest)
            return trackerRecord.count
        } catch {
            print("ОШИБКА ПОДСЧЕТА КОЛИЧЕСТВА ВЫПОЛНЕННЫХ ТРЕКЕРОВ ДЛЯ ТРЕКЕРА С НОМЕРОМ \(id): \(error.localizedDescription)")
            return 0
        }
    }
    
    /// Функция подсчета числа выполненных трекеров
    func importCoreDataRecordComplete(id: UUID, trackerDate: Date) -> Bool {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        let calendar = Calendar.current
        let startDay = calendar.startOfDay(for: trackerDate)
        let endDay = calendar.date(byAdding: .day, value: 1, to: startDay) ?? startDay
        
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND date < %@ AND date >= %@", id as CVarArg, startDay as NSDate, endDay as NSDate)
        
        do {
            let trackerRecord = try context.fetch(fetchRequest)
            let countTrackerRecord = trackerRecord.isEmpty
            return !countTrackerRecord
        } catch {
            print("ОШИБКА ПОИСКА КОЛИЧЕСТВА ВЫПОЛНЕННЫХ ТРЕКЕРОВ: \(error.localizedDescription)")
            return false
        }
    }
    
}

