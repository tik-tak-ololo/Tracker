//
//  ScheduleViewController+UITableViewDataSource.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 13.05.2026.
//

import UIKit

extension ScheduleViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DayOfWeek.allCases.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ScheduleCell.reuseIdentifier,
            for: indexPath
        ) as? ScheduleCell else {
            return UITableViewCell()
        }

        let day = DayOfWeek.allCases[indexPath.row]

        cell.configure(
            title: day.title,
            isOn: selectedDays.contains(day),
            showsSeparator: indexPath.row != 6
        )

        cell.onSwitchChanged = { [weak self] isOn in
            guard let self else { return }

            if isOn {
                self.selectedDays.insert(day)
            } else {
                self.selectedDays.remove(day)
            }
        }

        return cell
    }
}
