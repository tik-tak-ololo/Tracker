//
//  MockTrackerCategoryStore.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 22.06.2026.
//

@testable import Tracker

final class MockTrackerCategoryStore: TrackerCategoryStoreProtocol {
    weak var delegate: TrackerCategoryStoreDelegate?

    var categories: [TrackerCategory] = []
    
    init(categories: [TrackerCategory] = []) {
        self.categories = categories
    }

    func addCategory(title: String) throws {}
    func updateCategory(oldTitle: String, newTitle: String) throws {}
    func deleteCategory(title: String) throws {}
}
