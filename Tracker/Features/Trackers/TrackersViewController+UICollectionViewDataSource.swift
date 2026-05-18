//
//  TrackersViewController+UICollectionViewDataSource.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 13.05.2026.
//

import UIKit

extension TrackersViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        visibleCategories[section].trackers.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }

        let tracker = visibleCategories[indexPath.section].trackers[indexPath.item]

        cell.configure(
            with: tracker,
            completedDays: completedDaysCount(for: tracker.id),
            isCompleted: isTrackerCompleted(id: tracker.id, on: selectedDate)
        ) { [weak self] trackerId in
            self?.toggleTrackerCompletion(id: trackerId)
        }

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackerSectionHeaderView.reuseIdentifier,
            for: indexPath
        ) as? TrackerSectionHeaderView else {
            return UICollectionReusableView()
        }

        header.configure(title: visibleCategories[indexPath.section].title)
        return header
    }
}
