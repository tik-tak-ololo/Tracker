//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 20.06.2026.
//

import Foundation
import AppMetricaCore

enum AnalyticsEvent {
    case open
    case close
    case click(item: AnalyticsItem)

    var name: String {
        switch self {
        case .open:
            return "open"
        case .close:
            return "close"
        case .click:
            return "click"
        }
    }
}

enum AnalyticsItem: String {
    case addTrack = "add_track"
    case track
    case filter
    case edit
    case delete
}

enum AnalyticsScreen: String {
    case main = "Main"
}

final class AnalyticsService {

    static let shared = AnalyticsService()

    private init() {}
    
    func activate() {
        guard let configuration = AppMetricaConfiguration(apiKey: "f4711463-d5c9-41df-ad22-4d367e40ff5d") else { return }
        AppMetrica.activate(with: configuration)
    }

    func report(
        event: AnalyticsEvent,
        screen: AnalyticsScreen
    ) {
        var parameters: [String: Any] = [
            "event": event.name,
            "screen": screen.rawValue
        ]

        if case let .click(item) = event {
            parameters["item"] = item.rawValue
        }

        #if DEBUG
        print("Analytics event:", parameters)
        #endif

        AppMetrica.reportEvent(
            name: event.name,
            parameters: parameters,
            onFailure: { error in
                assertionFailure("AppMetrica error: \(error.localizedDescription)")
            }
        )
    }
}
