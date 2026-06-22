//
//  TrackerTestData.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 22.06.2026.
//

import UIKit
@testable import Tracker

enum TrackerTestData {

    static let tracker1 = Tracker(
        id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
        name: "Пить воду",
        color: .systemBlue,
        emoji: "💧",
        schedule: Set(DayOfWeek.allCases)
    )

    static let tracker2 = Tracker(
        id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!,
        name: "Тренировка",
        color: .systemRed,
        emoji: "🏃",
        schedule: Set(DayOfWeek.allCases)
    )

    static let category = TrackerCategory(
        title: "Важное",
        trackers: [tracker1, tracker2]
    )

    static let record = TrackerRecord(
        trackerId: tracker1.id,
        date: Date()
    )
}
