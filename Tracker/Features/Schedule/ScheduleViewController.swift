//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 12.05.2026.
//

import UIKit

final class ScheduleViewController: UIViewController {

    weak var delegate: ScheduleViewControllerDelegate?

    var selectedDays: Set<DayOfWeek>

    private let tableView = UITableView(frame: .zero, style: .plain)

    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor(resource: .blackDayIOS)
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
        
        setupView()
        setupContent()
        setupTableView()
        setupDoneButton()
    }
    
    private func setupView() {
        view.backgroundColor = .backgroundColorIOS
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    private func setupContent() {
        title = "Расписание"
    }

    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
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
