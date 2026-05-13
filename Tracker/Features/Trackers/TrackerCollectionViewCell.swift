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
    private let emojiContainerView = UIView()
    private let emojiLabel = UILabel()
    private let titleLabel = UILabel()
    private let daysLabel = UILabel()
    private let completeButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
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
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor(resource: .cardBorderColorIOS).cgColor
        emojiLabel.text = tracker.emoji
        titleLabel.text = tracker.name
        daysLabel.text = "\(completedDays) дней"

        let image = isCompleted
            ? UIImage(resource: .compleatButtonCheckmarkIOS)
            : UIImage(resource: .compleatButtonPlusIOS)
        
        completeButton.setImage(image, for: .normal)
        completeButton.backgroundColor = .whiteIOS
        completeButton.tintColor = tracker.color
    }

    private func setupUI() {
        contentView.addSubview(cardView)
        contentView.addSubview(daysLabel)
        contentView.addSubview(completeButton)

        cardView.addSubview(emojiContainerView)
        cardView.addSubview(titleLabel)
        emojiContainerView.addSubview(emojiLabel)

        [cardView, emojiLabel, titleLabel, emojiContainerView, daysLabel, completeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        cardView.layer.cornerRadius = 16
        cardView.clipsToBounds = true
        
        // emojiContainerView
        emojiContainerView.backgroundColor = .emojiContainerViewColorIOS
        emojiContainerView.layer.cornerRadius = 12
        emojiContainerView.clipsToBounds = true

        // emojiLabel
        emojiLabel.font = .systemFont(ofSize: 16)
        emojiLabel.textAlignment = .center

        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2

        daysLabel.font = .systemFont(ofSize: 12, weight: .medium)
        daysLabel.textColor = .label

        completeButton.layer.cornerRadius = 17
        completeButton.clipsToBounds = true
        completeButton.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)

    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),
            
            // emojiContainerView
            emojiContainerView.topAnchor.constraint(
                equalTo: cardView.topAnchor,
                constant: 12
            ),
            emojiContainerView.leadingAnchor.constraint(
                equalTo: cardView.leadingAnchor,
                constant: 12
            ),

            emojiContainerView.widthAnchor.constraint(equalToConstant: 24),
            emojiContainerView.heightAnchor.constraint(equalToConstant: 24),
            
            // emojiLabel
            emojiLabel.centerXAnchor.constraint(
                equalTo: emojiContainerView.centerXAnchor
            ),
            emojiLabel.centerYAnchor.constraint(
                equalTo: emojiContainerView.centerYAnchor
            ),

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
            completeButton.heightAnchor.constraint(equalToConstant: 34)
        ])
        
    }

    @objc private func didTapCompleteButton() {
        guard let trackerId else { return }
        onToggle?(trackerId)
    }
}
