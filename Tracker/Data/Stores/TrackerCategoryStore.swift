//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 24.05.2026.
//

import UIKit
import CoreData

protocol TrackerCategoryStoreDelegate: AnyObject {
    func trackerCategoryStoreDidUpdate(_ store: TrackerCategoryStore)
}

final class TrackerCategoryStore: NSObject {

    weak var delegate: TrackerCategoryStoreDelegate?

    private let context: NSManagedObjectContext

    private lazy var fetchedResultsController: NSFetchedResultsController<NSManagedObject> = {
        let request = NSFetchRequest<NSManagedObject>(entityName: "TrackerCategoryCoreData")
        request.sortDescriptors = [
            NSSortDescriptor(key: "title", ascending: true)
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

    var categories: [TrackerCategory] {
        fetchedResultsController.fetchedObjects?.compactMap { TrackerCategoryCoreDataMapper.makeCategory(from: $0) } ?? []
    }

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
        super.init()

        do {
            try fetchedResultsController.performFetch()
        } catch {
            assertionFailure("Failed to fetch categories: \(error)")
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

        TrackerCategoryCoreDataMapper.update(category, title: title)

        try save()
    }

    private func save() throws {
        guard context.hasChanges else { return }
        try context.save()
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.trackerCategoryStoreDidUpdate(self)
    }
}
