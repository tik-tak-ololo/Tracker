//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 12.05.2026.
//

import UIKit

final class NewHabitViewController: UIViewController {

    weak var delegate: NewHabitViewControllerDelegate?

    private var selectedSchedule: Set<DayOfWeek> = []

    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.font = .systemFont(ofSize: 17)
        textField.backgroundColor = .backgroundDayIOS
        textField.layer.cornerRadius = 16
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let optionsTableView = UITableView(frame: .zero, style: .plain)

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .grayIOS
        button.layer.cornerRadius = 16
        button.isEnabled = false
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let options = ["Категория", "Расписание"]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .backgroundColorIOS
        title = "Новая привычка"

        setupTextField()
        setupOptionsTableView()
        setupButtons()

        titleTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }

    private func setupTextField() {
        view.addSubview(titleTextField)

        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }

    private func setupOptionsTableView() {
        optionsTableView.backgroundColor = .clear
        optionsTableView.layer.cornerRadius = 16
        optionsTableView.clipsToBounds = true
        optionsTableView.isScrollEnabled = false
        optionsTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        optionsTableView.separatorStyle = .none
        optionsTableView.separatorColor = .systemGray4
        optionsTableView.dataSource = self
        optionsTableView.delegate = self
        //optionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "OptionCell")
        optionsTableView.register(TrackerOptionCell.self, forCellReuseIdentifier: TrackerOptionCell.reuseIdentifier)
        optionsTableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(optionsTableView)

        NSLayoutConstraint.activate([
            optionsTableView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 24),
            optionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            optionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            optionsTableView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

    private func setupButtons() {
        view.addSubview(cancelButton)
        view.addSubview(createButton)

        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),

            createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            createButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),

            cancelButton.widthAnchor.constraint(equalTo: createButton.widthAnchor)
        ])
    }

    @objc private func textFieldChanged() {
        updateCreateButtonState()
    }

    private func updateCreateButtonState() {
        let hasTitle = !(titleTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty

        createButton.isEnabled = hasTitle
        createButton.backgroundColor = hasTitle
            ? .blackDayIOS
            : .grayIOS
    }

    @objc private func cancelButtonTapped() {
        delegate?.newHabitViewControllerDidCancel(self)
        dismiss(animated: true)
    }

    @objc private func createButtonTapped() {
        guard let title = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !title.isEmpty
        else { return }

        let tracker = Tracker(
            id: UUID(),
            name: title,
            color: .systemBlue,
            emoji: "🙂",
            schedule: selectedSchedule
        )

        delegate?.newHabitViewController(
            self,
            didCreateTracker: tracker,
            categoryTitle: "Важное"
        )

        dismiss(animated: true)
    }
}

extension NewHabitViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TrackerOptionCell.reuseIdentifier,
            for: indexPath
        ) as? TrackerOptionCell else {
            return UITableViewCell()
        }
        
        cell.textLabel?.font = .systemFont(ofSize: 17)
        cell.textLabel?.textColor = .textColorIOS
        cell.backgroundColor = .backgroundDayIOS
        cell.selectionStyle = .none
        
        cell.configure(
            title: options[indexPath.row],
            showsSeparator: indexPath.row != options.count - 1
        )

        return cell
    }
}

extension NewHabitViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        75
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        if indexPath.row == 0 {
            // Пока не функционирует
            return
        }

        if indexPath.row == 1 {
            let scheduleVC = ScheduleViewController(selectedDays: selectedSchedule)
            scheduleVC.delegate = self
            navigationController?.pushViewController(scheduleVC, animated: true)
        }
    }
}

extension NewHabitViewController: ScheduleViewControllerDelegate {

    func scheduleViewController(
        _ controller: ScheduleViewController,
        didSelect schedule: Set<DayOfWeek>
    ) {
        selectedSchedule = schedule
        optionsTableView.reloadData()
    }
}
