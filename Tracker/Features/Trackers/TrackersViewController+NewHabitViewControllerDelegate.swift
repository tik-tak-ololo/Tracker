//
//  TrackersViewController+NewHabitViewControllerDelegate.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 13.05.2026.
//

import UIKit

extension TrackersViewController: NewHabitViewControllerDelegate {

    func newHabitViewControllerDidCancel(_ controller: NewHabitViewController) {
        dismiss(animated: true)
    }

    func newHabitViewController(
        _ controller: NewHabitViewController,
        didCreateTracker tracker: Tracker,
        categoryTitle: String
    ) {
        addTracker(tracker, toCategoryWithTitle: categoryTitle)
        reloadVisibleTrackers()
    }
}
