//
//  TrackerStore.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 24.05.2026.
//

import UIKit
import CoreData

// MARK: - TrackerStore

final class TrackerStore {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    func fetchTrackers() throws -> [Tracker] {
        let request = NSFetchRequest<NSManagedObject>(entityName: "TrackerCoreData")
        let objects = try context.fetch(request)
        return objects.compactMap { makeTracker(from: $0) }
    }

    func addTracker(_ tracker: Tracker, to categoryTitle: String) throws {
        let trackerObject = NSEntityDescription.insertNewObject(
            forEntityName: "TrackerCoreData",
            into: context
        )

        trackerObject.setValue(tracker.id, forKey: "id")
        trackerObject.setValue(tracker.name, forKey: "name")
        trackerObject.setValue(tracker.emoji, forKey: "emoji")
        trackerObject.setValue(tracker.color.hexString, forKey: "colorHex")
        trackerObject.setValue(
            tracker.schedule.map { NSNumber(value: $0.rawValue) },
            forKey: "schedule"
        )

        let categoryObject = try fetchOrCreateCategory(title: categoryTitle)
        trackerObject.setValue(categoryObject, forKey: "category")

        try save()
    }

    func deleteTracker(id: UUID) throws {
        let request = NSFetchRequest<NSManagedObject>(entityName: "TrackerCoreData")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1

        guard let object = try context.fetch(request).first else {
            throw StoreError.objectNotFound
        }

        context.delete(object)
        try save()
    }

    private func fetchOrCreateCategory(title: String) throws -> NSManagedObject {
        let request = NSFetchRequest<NSManagedObject>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(format: "title == %@", title)
        request.fetchLimit = 1

        if let category = try context.fetch(request).first {
            return category
        }

        let category = NSEntityDescription.insertNewObject(
            forEntityName: "TrackerCategoryCoreData",
            into: context
        )
        category.setValue(title, forKey: "title")
        return category
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
