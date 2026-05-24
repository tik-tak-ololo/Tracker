//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 24.05.2026.
//

import UIKit
import CoreData

final class TrackerCategoryStore {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    func fetchCategories() throws -> [TrackerCategory] {
        let request = NSFetchRequest<NSManagedObject>(entityName: "TrackerCategoryCoreData")
        request.sortDescriptors = [
            NSSortDescriptor(key: "title", ascending: true)
        ]

        let objects = try context.fetch(request)

        return objects.compactMap { categoryObject in
            guard let title = categoryObject.value(forKey: "title") as? String else {
                return nil
            }

            let trackerObjects = categoryObject.value(forKey: "trackers") as? Set<NSManagedObject> ?? []

            let trackers = trackerObjects.compactMap {
                makeTracker(from: $0)
            }

            return TrackerCategory(title: title, trackers: trackers)
        }
    }

    func addCategory(title: String) throws {
        let request = NSFetchRequest<NSManagedObject>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(format: "title == %@", title)
        request.fetchLimit = 1

        if try context.fetch(request).first != nil {
            return
        }

        let category = NSEntityDescription.insertNewObject(
            forEntityName: "TrackerCategoryCoreData",
            into: context
        )

        category.setValue(title, forKey: "title")

        try save()
    }

    private func makeTracker(from object: NSManagedObject) -> Tracker? {
        guard
            let id = object.value(forKey: "id") as? UUID,
            let name = object.value(forKey: "name") as? String,
            let emoji = object.value(forKey: "emoji") as? String,
            let colorHex = object.value(forKey: "colorHex") as? String
        else {
            return nil
        }

        let scheduleNumbers = object.value(forKey: "schedule") as? [NSNumber] ?? []
        let schedule = Set(
            scheduleNumbers.compactMap {
                DayOfWeek(rawValue: $0.intValue)
            }
        )

        return Tracker(
            id: id,
            name: name,
            color: UIColor(hex: colorHex),
            emoji: emoji,
            schedule: schedule
        )
    }

    private func save() throws {
        guard context.hasChanges else { return }
        try context.save()
    }
}
