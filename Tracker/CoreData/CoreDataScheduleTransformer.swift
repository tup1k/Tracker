//
//  CoreDataScheduleTransformer.swift
//  Tracker
//
//  Created by Олег Кор on 02.12.2024.
//

import UIKit

// Компромисный метод обхода использования типа Transformable в CoreData
final class CoreDataScheduleTransformer {
    static let shared = CoreDataScheduleTransformer()
    
    /// Метод превращения массива [Days] в тип String для сохранения в CoreData
    func daysToString(days: [Days]) -> String {
        let stringDays = days.map {$0.rawValue}.joined(separator: ",")
        return stringDays
    }
    
    /// Метод превращения типа String в массив [Days] для импорта из CoreData
    func stringToDays(stringDays: String) -> [Days] {
        let days = stringDays.split(separator: ",").map {String($0)}
        let arrayDays = days.compactMap {Days(rawValue: $0)}
        return arrayDays
    }
    
}
