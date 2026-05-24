//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 24.05.2026.
//

import CoreData

protocol TrackerRecordStoreDelegate: AnyObject {
    func trackerRecordStoreDidUpdate(_ store: TrackerRecordStore)
}

final class TrackerRecordStore: NSObject {

    weak var delegate: TrackerRecordStoreDelegate?

    private let context: NSManagedObjectContext
    private let calendar = Calendar.current

    private lazy var fetchedResultsController: NSFetchedResultsController<NSManagedObject> = {
        let request = NSFetchRequest<NSManagedObject>(entityName: "TrackerRecordCoreData")
        request.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: true),
            NSSortDescriptor(key: "id", ascending: true)
        ]

        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        controller.delegate = self
        return controller
    }()

    var records: Set<TrackerRecord> {
        Set(fetchedResultsController.fetchedObjects?.compactMap { makeRecord(from: $0) } ?? [])
    }

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
        super.init()

        do {
            try fetchedResultsController.performFetch()
        } catch {
            assertionFailure("Failed to fetch tracker records: \(error)")
        }
    }

    func addRecord(_ record: TrackerRecord) throws {
        guard !records.contains(where: {
            $0.trackerId == record.trackerId &&
            calendar.isDate($0.date, inSameDayAs: record.date)
        }) else {
            return
        }

        let object = NSEntityDescription.insertNewObject(
            forEntityName: "TrackerRecordCoreData",
            into: context
        )

        object.setValue(record.trackerId, forKey: "id")
        object.setValue(calendar.startOfDay(for: record.date), forKey: "date")

        try save()
    }

    func deleteRecord(_ record: TrackerRecord) throws {
        let request = NSFetchRequest<NSManagedObject>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(
            format: "id == %@ AND date == %@",
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

    func isTrackerCompleted(_ trackerId: UUID, on date: Date) -> Bool {
        records.contains {
            $0.trackerId == trackerId &&
            calendar.isDate($0.date, inSameDayAs: date)
        }
    }

    func completedDaysCount(for trackerId: UUID) -> Int {
        records.filter { $0.trackerId == trackerId }.count
    }

    private func makeRecord(from object: NSManagedObject) -> TrackerRecord? {
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

    private func save() throws {
        guard context.hasChanges else { return }
        try context.save()
    }
}

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.trackerRecordStoreDidUpdate(self)
    }
}
