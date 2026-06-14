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
            let store = TrackerCategoryStore()

            let viewModel = CategoryViewModel(
                store: store,
                selectedCategoryTitle: selectedCategoryTitle
            )

            let categoryViewController = CategoryViewController(viewModel: viewModel)

            viewModel.onCategorySelected = { [weak self] title in
                guard !title.isEmpty else { return }

                self?.selectedCategoryTitle = title
                self?.optionsTableView.reloadRows(
                    at: [IndexPath(row: 0, section: 0)],
                    with: .automatic
                )
            }

            navigationController?.pushViewController(categoryViewController, animated: true)
        }

        if indexPath.row == 1 {
            let scheduleVC = ScheduleViewController(selectedDays: selectedSchedule)
            scheduleVC.delegate = self
            navigationController?.pushViewController(scheduleVC, animated: true)
        }
    }
}
