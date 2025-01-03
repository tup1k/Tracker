//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Олег Кор on 23.12.2024.
//

import Foundation
import YandexMobileMetrica

enum AppScreen: String {
    case main = "Main"
    case statistics = "Statistics"
    case typeOfTracker = "TypeOfTracker"
    case habitCreation = "HabitCreation"
    case eventCreation = "EventCreation"
}

struct AnalyticsService {
    private enum AppEvent: String {
        case open
        case close
        case click
    }
    
    private static let parameters: [[AnyHashable: String]] = [
        ["screen": "Main", "item": "add_track"],
        ["screen": "Main", "item": "track"],
        ["screen": "Main", "item": "filter"],
        ["screen": "Main", "item": "edit"],
        ["screen": "Main", "item": "delete"],
        ["screen": "TypeOfTracker", "item": "add_tracker"],
        ["screen": "TypeOfTracker", "item": "add_event"],
        ["screen": "HabitCreation", "item": "create_habit"],
        ["screen": "EventCreation", "item": "create_event"]
    ]

    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "2cdafe9f-4994-4f93-89ed-2a0364cabe13") else { return }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    
    private static func report(event: String, params : [AnyHashable : Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    static func openScreenReport(screen: AppScreen) {
        report(event: AppEvent.open.rawValue, params: ["screen": "\(screen)"])
    }
    
    static func closeScreenReport(screen: AppScreen) {
        report(event: AppEvent.close.rawValue, params: ["screen": "\(screen)"])
    }
    
    static func addTrackReport() {
        report(event: AppEvent.click.rawValue, params: parameters[0])
    }
    
    static func trackIsDoneReport() {
        report(event: AppEvent.click.rawValue, params: parameters[1])
    }
    
    static func filterTrackReport() {
        report(event: AppEvent.click.rawValue, params: parameters[2])
    }
    
    static func contextEditTrackerReport() {
        report(event: AppEvent.click.rawValue, params: parameters[3])
    }
    
    static func contextDeleteTrackerReport() {
        report(event: AppEvent.click.rawValue, params: parameters[4])
    }
    
    static func addHabitReport() {
        report(event: AppEvent.click.rawValue, params: parameters[5])
    }
    
    static func addEventReport() {
        report(event: AppEvent.click.rawValue, params: parameters[6])
    }
    
    static func createHabitReport() {
        report(event: AppEvent.click.rawValue, params: parameters[7])
    }
    
    static func createEventReport() {
        report(event: AppEvent.click.rawValue, params: parameters[8])
    }
    
}
