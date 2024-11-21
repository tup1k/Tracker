//
//  TrackerStructuresFile.swift
//  Tracker
//
//  Created by Олег Кор on 11.11.2024.
//

import UIKit

///  Структура трекера
struct Tracker {
    let id: UUID
    let trackerName: String
    let trackerColor: UIColor
    let trackerEmoji: String
    let trackerShedule: [Days]
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
enum Days: String, CaseIterable {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case sutarday = "Суббота"
    case sunday = "Воскресение"
    
    var shortDay: String {
        switch self {
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .sutarday: return "Сб"
        case .sunday: return "Вс"
        }
    }
}

