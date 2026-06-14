//
//  CategoryViewController+UITableViewDataSource.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 07.06.2026.
//

import UIKit

extension CategoryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryCell.reuseIdentifier,
            for: indexPath
        ) as? CategoryCell else {
            return UITableViewCell()
        }

        cell.configure(
            title: viewModel.categoryTitle(at: indexPath),
            isSelected: viewModel.isSelected(at: indexPath),
            isLast: viewModel.isLastCell(at: indexPath)
        )

        return cell
    }
}
