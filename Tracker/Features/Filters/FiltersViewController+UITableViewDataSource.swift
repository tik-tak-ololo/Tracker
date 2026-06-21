//
//  FiltersViewController+UITableViewDataSource.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 21.06.2026.
//

import UIKit

extension FiltersViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        TrackerFilter.allCases.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let filter = TrackerFilter.allCases[indexPath.row]

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "FilterCell",
            for: indexPath
        )

        cell.backgroundColor = .secondarySystemBackground
        cell.textLabel?.text = filter.title
        cell.textLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        cell.textLabel?.textColor = .label

        if filter == selectedFilter && filter.shouldShowCheckmark {
            cell.accessoryType = .checkmark
            cell.tintColor = UIColor(red: 55/255, green: 114/255, blue: 231/255, alpha: 1)
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
}
