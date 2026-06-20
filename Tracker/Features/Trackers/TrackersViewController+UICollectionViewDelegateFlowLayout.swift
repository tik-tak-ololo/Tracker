//
//  TrackersViewController+UICollectionViewDelegateFlowLayout.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 13.05.2026.
//

import UIKit

extension TrackersViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let horizontalInsets: CGFloat = 32
        let spacing: CGFloat = 9

        let width = (
            collectionView.bounds.width
            - horizontalInsets
            - spacing
        ) / 2

        return CGSize(width: width, height: 132)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 18)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil
        ) { _ in
            let editAction = UIAction(title: "Редактировать") { _ in
                AnalyticsService.shared.report(
                    event: .click(item: .edit),
                    screen: .main
                )

                // self?.editTracker(at: indexPath)
            }

            let deleteAction = UIAction(
                title: "Удалить",
                attributes: .destructive
            ) { _ in
                AnalyticsService.shared.report(
                    event: .click(item: .delete),
                    screen: .main
                )

                // self?.deleteTracker(at: indexPath)
            }

            return UIMenu(children: [editAction, deleteAction])
        }
    }
    
}
