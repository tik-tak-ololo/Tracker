//
//  TrackerCoreDataMapper.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 25.05.2026.
//

import UIKit
import CoreData

enum TrackerCoreDataMapper {

    static func makeTracker(from object: NSManagedObject) -> Tracker? {
        guard
            let id = object.value(forKey: "id") as? UUID,
            let name = object.value(forKey: "title") as? String,
            let emoji = object.value(forKey: "emoji") as? String,
            let colorHex = object.value(forKey: "colorHex") as? String
        else {
            return nil
        }

        let scheduleNumbers = object.value(forKey: "schedule") as? [NSNumber] ?? []
        let schedule = Set(scheduleNumbers.compactMap {
            DayOfWeek(rawValue: $0.intValue)
        })

        return Tracker(
            id: id,
            name: name,
            color: UIColor(hex: colorHex),
            emoji: emoji,
            schedule: schedule
        )
    }

    static func update(_ object: NSManagedObject, with tracker: Tracker) {
        object.setValue(tracker.id, forKey: "id")
        object.setValue(tracker.name, forKey: "title")
        object.setValue(tracker.emoji, forKey: "emoji")
        object.setValue(tracker.color.hexString, forKey: "colorHex")
        object.setValue(
            tracker.schedule.map { NSNumber(value: $0.rawValue) },
            forKey: "schedule"
        )
    }
}
