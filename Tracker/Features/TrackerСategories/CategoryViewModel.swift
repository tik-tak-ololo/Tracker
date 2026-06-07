//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 07.06.2026.
//

import Foundation
import UIKit

final class CategoryViewModel {

    var onCategoriesChanged: (() -> Void)?
    var onCategorySelected: ((String) -> Void)?
    var onError: ((String) -> Void)?

    private let store: TrackerCategoryStore
    private(set) var selectedCategoryTitle: String?

    private var categories: [TrackerCategory] = [] {
        didSet {
            onCategoriesChanged?()
        }
    }

    var numberOfRows: Int {
        categories.count
    }

    init(
        store: TrackerCategoryStore,
        selectedCategoryTitle: String?
    ) {
        self.store = store
        self.selectedCategoryTitle = selectedCategoryTitle
        self.store.delegate = self
    }

    func viewDidLoad() {
        reloadCategories()
    }

    func categoryTitle(at indexPath: IndexPath) -> String {
        categories[indexPath.row].title
    }

    func isSelected(at indexPath: IndexPath) -> Bool {
        categories[indexPath.row].title == selectedCategoryTitle
    }

    func isLastCell(at indexPath: IndexPath) -> Bool {
        indexPath.row == categories.count - 1
    }

    func didSelectCategory(at indexPath: IndexPath) {
        let title = categories[indexPath.row].title
        selectedCategoryTitle = title
        onCategorySelected?(title)
        onCategoriesChanged?()
    }

    func addCategory(title: String) {
        do {
            try store.addCategory(title: title)
        } catch {
            onError?("Не удалось добавить категорию")
        }
    }

    func updateCategory(oldTitle: String, newTitle: String) {
        do {
            try store.updateCategory(oldTitle: oldTitle, newTitle: newTitle)

            if selectedCategoryTitle == oldTitle {
                selectedCategoryTitle = newTitle
                onCategorySelected?(newTitle)
            }
        } catch {
            onError?("Не удалось изменить категорию")
        }
    }

    func deleteCategory(at indexPath: IndexPath) {
        let title = categories[indexPath.row].title

        do {
            try store.deleteCategory(title: title)

            if selectedCategoryTitle == title {
                selectedCategoryTitle = nil
                onCategorySelected?("")
            }
        } catch {
            onError?("Не удалось удалить категорию")
        }
    }

    private func reloadCategories() {
        categories = store.categories
    }
}

extension CategoryViewModel: TrackerCategoryStoreDelegate {
    func trackerCategoryStoreDidUpdate(_ store: TrackerCategoryStore) {
        reloadCategories()
    }
}
