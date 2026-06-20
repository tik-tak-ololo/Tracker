//
//  NewHabitViewControllerDelegate.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 12.05.2026.
//

import Foundation

protocol NewHabitViewControllerDelegate: AnyObject {
    func newHabitViewControllerDidCancel(_ controller: NewHabitViewController)

    func newHabitViewController(
        _ controller: NewHabitViewController,
        didCreateTracker tracker: Tracker,
        categoryTitle: String
    )

    func newHabitViewController(
        _ controller: NewHabitViewController,
        didUpdateTracker tracker: Tracker,
        oldTrackerId: UUID,
        categoryTitle: String
    )
}
