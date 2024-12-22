//
//  TrackerStructuresFile.swift
//  Tracker
//
//  Created by Олег Кор on 11.11.2024.
//

import UIKit

///  Структура трекера
class Tracker {
    let id: UUID
    let trackerName: String
    let trackerColor: UIColor
    let trackerEmoji: String
    let trackerShedule: [Days]
    let trackerType: String
    
    init(id: UUID, trackerName: String, trackerColor: UIColor, trackerEmoji: String, trackerShedule: [Days], trackerType: String) {
        self.id = id
        self.trackerName = trackerName
        self.trackerColor = trackerColor
        self.trackerEmoji = trackerEmoji
        self.trackerShedule = trackerShedule
        self.trackerType = trackerType
    }
    
    convenience init(from trackersFromCoreData: TrackerCoreData) {
        let stringColor = trackersFromCoreData.trackerColor ?? "#AEAFB4"
        let trackerUIColor = UIColor(hex: stringColor) ?? .ypGray
        let trackerCoreDataSchedule = CoreDataScheduleTransformer.shared.stringToDays(stringDays: trackersFromCoreData.trackerShedule ?? "")
        
        self.init(
            id: trackersFromCoreData.id ?? UUID(),
            trackerName: trackersFromCoreData.trackerName ?? "",
            trackerColor: trackerUIColor,
            trackerEmoji: trackersFromCoreData.trackerEmoji ?? "",
            trackerShedule: trackerCoreDataSchedule,
            trackerType: trackersFromCoreData.trackerType ?? ""
        )
    }
}

/// Структура категорий трекеров
struct TrackerCategory {
    let categoryName: String
    let categoryTrackers: [Tracker]
}

/// Структура выполненных трекеров
struct TrackerRecord {
    let id: UUID
    let trackerDate: Date
}


/// Дни для расписания трекера
import Foundation

/// Дни для расписания трекера
enum Days: String, CaseIterable {
    case monday = "monday"
    case tuesday = "tuesday"
    case wednesday = "wednesday"
    case thursday = "thursday"
    case friday = "friday"
    case saturday = "saturday"
    case sunday = "sunday"
    
    // Локализованное полное название дня недели
    var localizedName: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    // Локализованное сокращенное название дня недели
    var shortDay: String {
        switch self {
        case .monday: return NSLocalizedString("mon", comment: "")
        case .tuesday: return NSLocalizedString("tue", comment: "")
        case .wednesday: return NSLocalizedString("wed", comment: "")
        case .thursday: return NSLocalizedString("thu", comment: "")
        case .friday: return NSLocalizedString("fri", comment: "")
        case .saturday: return NSLocalizedString("sat", comment: "")
        case .sunday: return NSLocalizedString("sun", comment: "")
        }
    }
}

