//
//  TrackerEmojiCell.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 18.05.2026.
//

import UIKit

final class TrackerEmojiCell: UICollectionViewCell {

    static let reuseIdentifier = "TrackerEmojiCell"

    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .lightGrayIOS : .clear
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.cornerRadius = 16
        contentView.addSubview(emojiLabel)

        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }

    func configure(with emoji: String) {
        emojiLabel.text = emoji
    }
}
