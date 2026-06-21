//
//  FiltersViewController+UITableViewDelegate.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 21.06.2026.
//

import UIKit

extension FiltersViewController: UITableViewDelegate {

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
        tableView.deselectRow(at: indexPath, animated: true)

        let filter = TrackerFilter.allCases[indexPath.row]
        onFilterSelected?(filter)

        dismiss(animated: true)
    }
}
