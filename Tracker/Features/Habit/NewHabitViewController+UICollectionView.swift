//
//  NewHabitViewController+UICollectionView.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 18.05.2026.
//

import UIKit

extension NewHabitViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if collectionView === emojiCollectionView {
            return emojis.count
        }

        return colors.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if collectionView === emojiCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrackerEmojiCell.reuseIdentifier,
                for: indexPath
            ) as? TrackerEmojiCell else {
                return UICollectionViewCell()
            }

            cell.configure(with: emojis[indexPath.item])
            return cell
        }

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerColorCell.reuseIdentifier,
            for: indexPath
        ) as? TrackerColorCell else {
            return UICollectionViewCell()
        }

        cell.configure(with: colors[indexPath.item])
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
            withReuseIdentifier: NewHabitCollectionHeaderView.reuseIdentifier,
            for: indexPath
        ) as? NewHabitCollectionHeaderView else {
            return UICollectionReusableView()
        }

        let title = collectionView === emojiCollectionView ? "Emoji" : "Цвет"
        header.configure(with: title)

        return header
    }
}

extension NewHabitViewController: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if collectionView === emojiCollectionView {
            selectedEmoji = emojis[indexPath.item]
        } else {
            selectedColor = colors[indexPath.item]
        }
    }
}

extension NewHabitViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: 58, height: 58)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 34)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {

        let headerHeight: CGFloat = 34

        let rows: CGFloat = 3
        let itemsPerRow: CGFloat = 6
        let itemHeight: CGFloat = 58
        let itemWidth: CGFloat = 58
        let lineSpacing: CGFloat = 0
        let spacing: CGFloat = 5

        let contentHeight =
            headerHeight +
            (rows * itemHeight) +
            ((rows - 1) * lineSpacing)

        let verticalInset = max(
            0,
            (collectionView.bounds.height - contentHeight) / 2
        )
        
        let totalItemsWidth = itemWidth * itemsPerRow
        let totalSpacingWidth = spacing * (itemsPerRow - 1)

        let totalContentWidth = totalItemsWidth + totalSpacingWidth

        let horizontalInset = max(
            0,
            (collectionView.bounds.width - totalContentWidth) / 2
        )

        return UIEdgeInsets(
            top: verticalInset,
            left: horizontalInset,
            bottom: 0,
            right: horizontalInset
        )
    }
}
