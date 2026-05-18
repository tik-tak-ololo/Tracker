//
//  TrackerOptionCell.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 12.05.2026.
//

import UIKit

final class TrackerOptionCell: UITableViewCell {

    static let reuseIdentifier = "TrackerOptionCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = UIColor(resource: .textColorIOS)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = UIColor(resource: .grayIOS)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .chevronImageIOS)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .grayIOS
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(resource: .backgroundDayIOS)
        selectionStyle = .none
        setupLayout()
    }

    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }

    private func setupLayout() {
        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(subtitleLabel)

        contentView.addSubview(labelsStackView)
        contentView.addSubview(chevronImageView)
        contentView.addSubview(separatorView)

        NSLayoutConstraint.activate([
            chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            labelsStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelsStackView.trailingAnchor.constraint(lessThanOrEqualTo: chevronImageView.leadingAnchor, constant: -8),

            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

    func configure(
        title: String,
        subtitle: String?,
        showsSeparator: Bool
    ) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = subtitle == nil || subtitle?.isEmpty == true
        separatorView.isHidden = !showsSeparator
    }
}
