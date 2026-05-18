//
//  NewHabitViewController+UITableViewDelegate.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 13.05.2026.
//

import UIKit

extension NewHabitViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        75
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        if indexPath.row == 0 {
            selectedCategoryTitle = "Важное"
            optionsTableView.reloadRows(
                at: [indexPath],
                with: .automatic
            )
            return
        }

        if indexPath.row == 1 {
            let scheduleVC = ScheduleViewController(selectedDays: selectedSchedule)
            scheduleVC.delegate = self
            navigationController?.pushViewController(scheduleVC, animated: true)
        }
    }
}
