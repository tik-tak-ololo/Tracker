//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 24.05.2026.
//

import CoreData

final class TrackerRecordStore {

    private let context: NSManagedObjectContext
    private let calendar = Calendar.current

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    func fetchRecords() throws -> Set<TrackerRecord> {
        let request = NSFetchRequest<NSManagedObject>(entityName: "TrackerRecordCoreData")
        let objects = try context.fetch(request)

        return Set(
            objects.compactMap { object in
                guard
                    let trackerId = object.value(forKey: "trackerId") as? UUID,
                    let date = object.value(forKey: "date") as? Date
                else {
                    return nil
                }

                return TrackerRecord(
                    trackerId: trackerId,
                    date: calendar.startOfDay(for: date)
                )
            }
        )
    }

    func addRecord(_ record: TrackerRecord) throws {
        guard try !isTrackerCompleted(record.trackerId, on: record.date) else {
            return
        }

        let object = NSEntityDescription.insertNewObject(
            forEntityName: "TrackerRecordCoreData",
            into: context
        )

        object.setValue(record.trackerId, forKey: "trackerId")
        object.setValue(calendar.startOfDay(for: record.date), forKey: "date")

        try save()
    }

    func deleteRecord(_ record: TrackerRecord) throws {
        let request = NSFetchRequest<NSManagedObject>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(
            format: "trackerId == %@ AND date == %@",
            record.trackerId as CVarArg,
            calendar.startOfDay(for: record.date) as CVarArg
        )
        request.fetchLimit = 1

        guard let object = try context.fetch(request).first else {
            return
        }

        context.delete(object)
        try save()
    }

    func isTrackerCompleted(_ trackerId: UUID, on date: Date) throws -> Bool {
        let request = NSFetchRequest<NSManagedObject>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(
            format: "trackerId == %@ AND date == %@",
            trackerId as CVarArg,
            calendar.startOfDay(for: date) as CVarArg
        )
        request.fetchLimit = 1

        return try context.count(for: request) > 0
    }

    func completedDaysCount(for trackerId: UUID) throws -> Int {
        let request = NSFetchRequest<NSManagedObject>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: "trackerId == %@", trackerId as CVarArg)

        return try context.count(for: request)
    }

    private func save() throws {
        guard context.hasChanges else { return }
        try context.save()
    }
}
