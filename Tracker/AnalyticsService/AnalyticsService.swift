//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Олег Кор on 23.12.2024.
//

import Foundation
import YandexMobileMetrica

struct AnalyticsService {
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "2cdafe9f-4994-4f93-89ed-2a0364cabe13") else { return }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func report(event: String, params : [AnyHashable : Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
}
