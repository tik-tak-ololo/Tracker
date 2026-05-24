//
//  TrackerCategoryCoreDataMapper.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 25.05.2026.
//

import CoreData

enum TrackerCategoryCoreDataMapper {

    static func makeCategory(from object: NSManagedObject) -> TrackerCategory? {
        guard let title = object.value(forKey: "title") as? String else {
            return nil
        }

        let trackerObjects = object.value(forKey: "trackers") as? Set<NSManagedObject> ?? []

        let trackers = trackerObjects
            .compactMap { TrackerCoreDataMapper.makeTracker(from: $0) }
            .sorted { $0.name < $1.name }

        return TrackerCategory(
            title: title,
            trackers: trackers
        )
    }

    static func update(_ object: NSManagedObject, title: String) {
        object.setValue(title, forKey: "title")
    }
}
