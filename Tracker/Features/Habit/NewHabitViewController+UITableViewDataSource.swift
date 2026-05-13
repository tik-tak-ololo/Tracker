//
//  NewHabitViewController+UITableViewDataSource.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 13.05.2026.
//

import UIKit

extension NewHabitViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TrackerOptionCell.reuseIdentifier,
            for: indexPath
        ) as? TrackerOptionCell else {
            return UITableViewCell()
        }

        let subtitle: String?

        switch indexPath.row {
        case 0:
            subtitle = selectedCategoryTitle
        case 1:
            subtitle = scheduleTitle
        default:
            subtitle = nil
        }

        cell.configure(
            title: options[indexPath.row],
            subtitle: subtitle,
            showsSeparator: indexPath.row != options.count - 1
        )

        return cell
    }
}
