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
            withReuseIdentifier: NewHabbitCollectionHeaderView.reuseIdentifier,
            for: indexPath
        ) as? NewHabbitCollectionHeaderView else {
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
        CGSize(width: 52, height: 52)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 34)
    }
}
