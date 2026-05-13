//
//  NewHabitViewController+ScheduleViewControllerDelegate.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 13.05.2026.
//

import UIKit

extension NewHabitViewController: ScheduleViewControllerDelegate {

    func scheduleViewController(
        _ controller: ScheduleViewController,
        didSelect schedule: Set<DayOfWeek>
    ) {
        selectedSchedule = schedule
        optionsTableView.reloadData()
    }
}
