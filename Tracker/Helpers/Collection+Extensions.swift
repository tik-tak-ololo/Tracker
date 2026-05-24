//
//  Collection+Extensions.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 24.05.2026.
//

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
