//
//  TrackerFilter.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 21.06.2026.
//

import Foundation

enum TrackerFilter: Int, CaseIterable {
    case all
    case today
    case completed
    case uncompleted

    var title: String {
        switch self {
        case .all:
            return "Все трекеры"
        case .today:
            return "Трекеры на сегодня"
        case .completed:
            return "Завершённые"
        case .uncompleted:
            return "Не завершённые"
        }
    }

    var isActiveFilter: Bool {
        switch self {
        case .completed, .uncompleted:
            return true
        case .all, .today:
            return false
        }
    }

    var shouldShowCheckmark: Bool {
        isActiveFilter
    }
}
