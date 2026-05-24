//
//  TrackerRecordCoreDataMapper.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 25.05.2026.
//

import Foundation
import CoreData

enum TrackerRecordCoreDataMapper {

    static func makeRecord(
        from object: NSManagedObject,
        calendar: Calendar = .current
    ) -> TrackerRecord? {
        guard
            let trackerId = object.value(forKey: "id") as? UUID,
            let date = object.value(forKey: "date") as? Date
        else {
            return nil
        }

        return TrackerRecord(
            trackerId: trackerId,
            date: calendar.startOfDay(for: date)
        )
    }

    static func update(
        _ object: NSManagedObject,
        with record: TrackerRecord,
        calendar: Calendar = .current
    ) {
        object.setValue(record.trackerId, forKey: "id")
        object.setValue(calendar.startOfDay(for: record.date), forKey: "date")
    }
}
