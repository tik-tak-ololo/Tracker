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
        let title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return }

        if try findCategoryObject(title: title) != nil {
            return
        }

        let category = NSEntityDescription.insertNewObject(
            forEntityName: "TrackerCategoryCoreData",
            into: context
        )

            //category.setValue(UUID(), forKey: "id")
        TrackerCategoryCoreDataMapper.update(category, title: title)

        try save()
    }

    func updateCategory(oldTitle: String, newTitle: String) throws {
        let newTitle = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !newTitle.isEmpty else { return }

        guard let category = try findCategoryObject(title: oldTitle) else {
            return
        }

        if oldTitle != newTitle,
           try findCategoryObject(title: newTitle) != nil {
            return
        }

        TrackerCategoryCoreDataMapper.update(category, title: newTitle)
        try save()
    }

    func deleteCategory(title: String) throws {
        guard let category = try findCategoryObject(title: title) else {
            return
        }

        context.delete(category)
        try save()
    }

    private func findCategoryObject(title: String) throws -> NSManagedObject? {
        let request = NSFetchRequest<NSManagedObject>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(format: "title == %@", title)
        request.fetchLimit = 1

        return try context.fetch(request).first
    }

    private func save() throws {
        guard context.hasChanges else { return }
        try context.save()
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        delegate?.trackerCategoryStoreDidUpdate(self)
    }
}
