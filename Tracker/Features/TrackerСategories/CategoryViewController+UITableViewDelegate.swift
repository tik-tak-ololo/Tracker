//
//  CategoryViewController+UITableViewDelegate.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 07.06.2026.
//

import UIKit

extension CategoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectCategory(at: indexPath)
        navigationController?.popViewController(animated: true)
    }

    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            let edit = UIAction(title: "Редактировать") { _ in
                guard let self else { return }

                let oldTitle = self.viewModel.categoryTitle(at: indexPath)
                let viewController = CategoryEditViewController(mode: .edit(title: oldTitle))

                viewController.onSave = { [weak self] newTitle in
                    self?.viewModel.updateCategory(oldTitle: oldTitle, newTitle: newTitle)
                }

                self.navigationController?.pushViewController(viewController, animated: true)
            }

            let delete = UIAction(
                title: "Удалить",
                attributes: .destructive
            ) { [weak self] _ in
                self?.showDeleteAlert(indexPath: indexPath)
            }

            return UIMenu(children: [edit, delete])
        }
    }
}
