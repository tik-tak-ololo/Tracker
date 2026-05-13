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
        
        // ON
        switchControl.onTintColor = .switcherBackgroundOnIOS
        
        // Thumb
        switchControl.thumbTintColor = .white
        
        // OFF
        switchControl.tintColor = .switcherBackgroundOffIOS
        switchControl.backgroundColor = .switcherBackgroundOffIOS
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
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

        contentView.addSubview(titleLabel)
        contentView.addSubview(daySwitch)
        contentView.addSubview(separatorView)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            daySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            daySwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        daySwitch.layer.cornerRadius = daySwitch.bounds.height / 2
    }

    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }

    func configure(title: String, isOn: Bool, showsSeparator: Bool) {
        titleLabel.text = title
        daySwitch.isOn = isOn
        separatorView.isHidden = !showsSeparator
    }

    @objc private func switchChanged() {
        onSwitchChanged?(daySwitch.isOn)
    }
}
