//
//  StatisticsCell.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 22.06.2026.
//

import UIKit

final class StatisticsCell: UIView {

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .textColorIOS
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .textColorIOS
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let gradientLayer = CAGradientLayer()
    private let borderMaskLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = 16

        let path = UIBezierPath(
            roundedRect: bounds.insetBy(dx: 0.5, dy: 0.5),
            cornerRadius: 16
        )

        borderMaskLayer.path = path.cgPath
        borderMaskLayer.fillColor = UIColor.clear.cgColor
        borderMaskLayer.strokeColor = UIColor.black.cgColor
        borderMaskLayer.lineWidth = 1

        gradientLayer.mask = borderMaskLayer
    }

    func configure(with item: StatisticsItem) {
        valueLabel.text = "\(item.value)"
        titleLabel.text = item.title
    }

    private func setupView() {
        backgroundColor = .clear

        gradientLayer.colors = [
            UIColor.systemRed.cgColor,
            UIColor.systemGreen.cgColor,
            UIColor.systemBlue.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)

        layer.addSublayer(gradientLayer)

        addSubview(valueLabel)
        addSubview(titleLabel)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 90),

            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
}
