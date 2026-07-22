//
//  TrackerCategoryStoreProtocol.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 22.06.2026.
//

import Foundation

protocol TrackerCategoryStoreProtocol: AnyObject {
    var delegate: TrackerCategoryStoreDelegate? { get set }
    var categories: [TrackerCategory] { get }

    func addCategory(title: String) throws
    func updateCategory(oldTitle: String, newTitle: String) throws
    func deleteCategory(title: String) throws
}
