//
//  ScheduleCell.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 12.05.2026.
//

import UIKit

final class ScheduleCell: UITableViewCell {

    static let reuseIdentifier = "ScheduleCell"

    var onSwitchChanged: ((Bool) -> Void)?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = UIColor(resource: .textColorIOS)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var daySwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = UIColor(resource: .backgroundDayIOS)
        selectionStyle = .none

        contentView.addSubview(titleLabel)
        contentView.addSubview(daySwitch)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            daySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            daySwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }

    func configure(title: String, isOn: Bool) {
        titleLabel.text = title
        daySwitch.isOn = isOn
    }

    @objc private func switchChanged() {
        onSwitchChanged?(daySwitch.isOn)
    }
}
