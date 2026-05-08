//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 09.05.2026.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "TrackerCollectionViewCell"

    private var trackerId: UUID?
    private var onToggle: ((UUID) -> Void)?

    private let cardView = UIView()
    private let emojiLabel = UILabel()
    private let titleLabel = UILabel()
    private let daysLabel = UILabel()
    private let completeButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(
        with tracker: Tracker,
        completedDays: Int,
        isCompleted: Bool,
        onToggle: @escaping (UUID) -> Void
    ) {
        self.trackerId = tracker.id
        self.onToggle = onToggle

        cardView.backgroundColor = tracker.color
        emojiLabel.text = tracker.emoji
        titleLabel.text = tracker.name
        daysLabel.text = "\(completedDays) дней"

        let image = isCompleted
            ? UIImage(systemName: "checkmark")
            : UIImage(systemName: "plus")

        completeButton.setImage(image, for: .normal)
        completeButton.backgroundColor = tracker.color
        completeButton.alpha = isCompleted ? 0.3 : 1
    }

    private func setupUI() {
        contentView.addSubview(cardView)
        contentView.addSubview(daysLabel)
        contentView.addSubview(completeButton)

        cardView.addSubview(emojiLabel)
        cardView.addSubview(titleLabel)

        [cardView, emojiLabel, titleLabel, daysLabel, completeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        cardView.layer.cornerRadius = 16
        cardView.clipsToBounds = true

        emojiLabel.font = .systemFont(ofSize: 16)

        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2

        daysLabel.font = .systemFont(ofSize: 12, weight: .medium)
        daysLabel.textColor = .label

        completeButton.tintColor = .white
        completeButton.layer.cornerRadius = 17
        completeButton.clipsToBounds = true
        completeButton.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),

            emojiLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),

            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),

            daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            daysLabel.centerYAnchor.constraint(equalTo: completeButton.centerYAnchor),
            daysLabel.widthAnchor.constraint(equalToConstant: 101),
            daysLabel.heightAnchor.constraint(equalToConstant: 18),

            completeButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 8),
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            completeButton.widthAnchor.constraint(equalToConstant: 34),
            completeButton.heightAnchor.constraint(equalToConstant: 34),
            completeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    @objc private func didTapCompleteButton() {
        guard let trackerId else { return }
        onToggle?(trackerId)
    }
}
