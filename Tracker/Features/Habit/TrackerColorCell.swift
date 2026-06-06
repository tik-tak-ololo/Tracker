//
//  TrackerColorCell.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 18.05.2026.
//

import UIKit

final class TrackerColorCell: UICollectionViewCell {

    static let reuseIdentifier = "TrackerColorCell"

    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override var isSelected: Bool {
        didSet {
            contentView.layer.borderWidth = isSelected ? 3 : 0
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.cornerRadius = 8

        contentView.addSubview(colorView)

        NSLayoutConstraint.activate([
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }

    func configure(with color: UIColor) {
        colorView.backgroundColor = color
        contentView.layer.borderColor = color.cgColor
    }
}
