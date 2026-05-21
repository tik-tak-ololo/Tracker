//
//  NewHabbitCollectionHeaderView.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 18.05.2026.
//

import UIKit

final class NewHabbitCollectionHeaderView: UICollectionReusableView {

    static let reuseIdentifier = "NewHabbitCollectionHeaderView"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 27),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }

    func configure(with title: String) {
        titleLabel.text = title
    }
}
