//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 12.05.2026.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func scheduleViewController(
        _ controller: ScheduleViewController,
        didSelect schedule: Set<DayOfWeek>
    )
}

final class ScheduleViewController: UIViewController {

    weak var delegate: ScheduleViewControllerDelegate?

    private var selectedDays: Set<DayOfWeek>

    private let tableView = UITableView(frame: .zero, style: .plain)

    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor(named: "BlackIOS") ?? .black
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(selectedDays: Set<DayOfWeek>) {
        self.selectedDays = selectedDays
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Расписание"

        setupTableView()
        setupDoneButton()
    }

    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .systemGray4
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 525)
        ])
    }

    private func setupDoneButton() {
        view.addSubview(doneButton)

        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc private func doneButtonTapped() {
        delegate?.scheduleViewController(self, didSelect: selectedDays)
        navigationController?.popViewController(animated: true)
    }
}

extension ScheduleViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DayOfWeek.allCases.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ScheduleCell.reuseIdentifier,
            for: indexPath
        ) as? ScheduleCell else {
            return UITableViewCell()
        }

        let day = DayOfWeek.allCases[indexPath.row]

        cell.configure(
            title: day.title,
            isOn: selectedDays.contains(day)
        )

        cell.onSwitchChanged = { [weak self] isOn in
            guard let self else { return }

            if isOn {
                self.selectedDays.insert(day)
            } else {
                self.selectedDays.remove(day)
            }
        }

        return cell
    }
}

extension ScheduleViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        75
    }
}
