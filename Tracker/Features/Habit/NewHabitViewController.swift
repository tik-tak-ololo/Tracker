//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 12.05.2026.
//

import UIKit

final class NewHabitViewController: UIViewController {
    
    // MARK: - Data

    weak var delegate: NewHabitViewControllerDelegate?
    
    private let mode: HabitScreenMode
    private var editingTrackerId: UUID?

    var selectedCategoryTitle: String? = ""
    var selectedSchedule: Set<DayOfWeek> = []
    private let maxTitleLength = 38

    var scheduleTitle: String? {
        guard !selectedSchedule.isEmpty else { return nil }

        if selectedSchedule.count == DayOfWeek.allCases.count {
            return "Каждый день"
        }

        return DayOfWeek.allCases
            .filter { selectedSchedule.contains($0) }
            .map { $0.shortTitle }
            .joined(separator: ", ")
    }
    
    let options = ["Категория", "Расписание"]
    
    let emojis = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                  "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                  "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]

    let colors: [UIColor] = [
        .cardColor1IOS, .cardColor2IOS, .cardColor3IOS, .cardColor4IOS, .cardColor5IOS, .cardColor6IOS,
            .cardColor7IOS, .cardColor8IOS, .cardColor9IOS, .cardColor10IOS, .cardColor11IOS, .cardColor12IOS,
            .cardColor13IOS, .cardColor14IOS, .cardColor15IOS, .cardColor16IOS, .cardColor17IOS, .cardColor18IOS,
    ]

    var selectedEmoji: String = "🙂"
    var selectedColor: UIColor = .cardColor1IOS
    
    // MARK: - UI
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
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

    let optionsTableView = UITableView(frame: .zero, style: .plain)
    
    lazy var emojiCollectionView = makeCollectionView()
    lazy var colorCollectionView = makeCollectionView()

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
        button.backgroundColor = .backgroundColorButtonIsNotReadyToBeTappedIOS
        button.layer.cornerRadius = 16
        button.isEnabled = false
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.textColorButtonIsReadyToBeTappedIOS, for: .normal)
        button.setTitleColor(.textColorButtonIsNotReadyToBeTappedIOS, for: .disabled)
        return button
    }()
    
    private let titleLimitLabel: UILabel = {
        let label = UILabel()

        label.text = "Ограничение 38 символов"
        label.font = .systemFont(ofSize: 17)
        label.textColor = .warningTextColorIOS
        label.textAlignment = .center
        label.isHidden = true

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let completedDaysLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private var titleTopToSafeAreaConstraint: NSLayoutConstraint?
    private var titleTopToDaysLabelConstraint: NSLayoutConstraint?
    
    private lazy var optionsTableTopConstraint = optionsTableView.topAnchor.constraint(
        equalTo: titleTextField.bottomAnchor,
        constant: 24
    )
    
    init(mode: HabitScreenMode = .create) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupScrollView()
        setupTextField()
        setupOptionsTableView()
        setupCollections()
        setupButtons()
        setupContent()

        titleTextField.delegate = self
        setupHideKeyboardOnTap()
        titleTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(
                ofSize: 16,
                weight: .medium
            ),
            .foregroundColor: UIColor.textColorIOS
        ]
    }
    
    // MARK: - Setup
    
    private func setupView() {
        view.backgroundColor = .backgroundColorIOS
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            // оставляем место под нижние кнопки
            scrollView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -92
            ),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }
    
    private func setupContent() {
        switch mode {
        case .create:
            title = "Новая привычка"
            createButton.setTitle("Создать", for: .normal)

            configureTitlePositionForCreateMode()

            selectedEmoji = emojis[0]
            selectedColor = colors[0]
            
            selectCurrentEmojiAndColor()

        case let .edit(tracker, categoryTitle, completedDays):
            title = "Редактирование привычки"
            createButton.setTitle("Сохранить", for: .normal)

            editingTrackerId = tracker.id
            titleTextField.text = tracker.name
            selectedCategoryTitle = categoryTitle
            selectedSchedule = tracker.schedule
            selectedEmoji = tracker.emoji
            selectedColor = tracker.color
            
            selectCurrentEmojiAndColor()

            configureTitlePositionForEditMode(completedDays: completedDays)

            createButton.isEnabled = true
        }
        
        emojiCollectionView.reloadData()
        colorCollectionView.reloadData()
        selectCurrentEmojiAndColor()
    }
    
    private func configureTitlePositionForCreateMode() {
        completedDaysLabel.isHidden = true

        titleTopToDaysLabelConstraint?.isActive = false
        titleTopToSafeAreaConstraint?.isActive = true
    }

    private func configureTitlePositionForEditMode(completedDays: Int) {
        completedDaysLabel.text = "\(completedDays) \(daysWord(completedDays))"
        completedDaysLabel.isHidden = false

        titleTopToSafeAreaConstraint?.isActive = false
        titleTopToDaysLabelConstraint?.isActive = true
    }

    private func setupTextField() {
        contentView.addSubview(completedDaysLabel)
        contentView.addSubview(titleTextField)
        contentView.addSubview(titleLimitLabel)

        let titleTopToSafeAreaConstraint = titleTextField.topAnchor.constraint(
            equalTo: contentView.safeAreaLayoutGuide.topAnchor,
            constant: 24
        )

        let titleTopToDaysLabelConstraint = titleTextField.topAnchor.constraint(
            equalTo: completedDaysLabel.bottomAnchor,
            constant: 40
        )

        self.titleTopToSafeAreaConstraint = titleTopToSafeAreaConstraint
        self.titleTopToDaysLabelConstraint = titleTopToDaysLabelConstraint

        NSLayoutConstraint.activate([
            completedDaysLabel.topAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.topAnchor,
                constant: 24
            ),
            completedDaysLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            completedDaysLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            completedDaysLabel.heightAnchor.constraint(equalToConstant: 38),

            titleTopToSafeAreaConstraint,

            titleTextField.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            titleTextField.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            titleTextField.heightAnchor.constraint(equalToConstant: 75),

            titleLimitLabel.topAnchor.constraint(
                equalTo: titleTextField.bottomAnchor,
                constant: 8
            ),
            titleLimitLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            titleLimitLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            titleLimitLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    
    private func setupHideKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapView)
        )

        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    private func setupOptionsTableView() {
        optionsTableView.backgroundColor = .clear
        optionsTableView.layer.cornerRadius = 16
        optionsTableView.clipsToBounds = true
        optionsTableView.isScrollEnabled = false
        optionsTableView.separatorStyle = .none
        optionsTableView.dataSource = self
        optionsTableView.delegate = self
        optionsTableView.register(TrackerOptionCell.self, forCellReuseIdentifier: TrackerOptionCell.reuseIdentifier)
        optionsTableView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(optionsTableView)
        
        optionsTableTopConstraint = optionsTableView.topAnchor.constraint(
            equalTo: titleTextField.bottomAnchor,
            constant: 24
        )

        optionsTableTopConstraint.isActive = true

        NSLayoutConstraint.activate([
            optionsTableTopConstraint,
            optionsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            optionsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            optionsTableView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func setupCollections() {
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        emojiCollectionView.register(
            TrackerEmojiCell.self,
            forCellWithReuseIdentifier: TrackerEmojiCell.reuseIdentifier
        )
        emojiCollectionView.register(
            NewHabitCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: NewHabitCollectionHeaderView.reuseIdentifier
        )

        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        colorCollectionView.register(
            TrackerColorCell.self,
            forCellWithReuseIdentifier: TrackerColorCell.reuseIdentifier
        )
        colorCollectionView.register(
            NewHabitCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: NewHabitCollectionHeaderView.reuseIdentifier
        )

        contentView.addSubview(emojiCollectionView)
        contentView.addSubview(colorCollectionView)

        NSLayoutConstraint.activate([
            emojiCollectionView.topAnchor.constraint(equalTo: optionsTableView.bottomAnchor, constant: 32),
            emojiCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1),
            emojiCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 220),

            colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 16),
            colorCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1),
            colorCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 220),

            // это задаёт высоту contentView для scrollView
            colorCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    private func updateTitleLimitState(isExceeded: Bool) {
        titleLimitLabel.isHidden = !isExceeded
        optionsTableTopConstraint.constant = isExceeded ? 54 : 24

        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func selectCurrentEmojiAndColor() {
        if let emojiIndex = emojis.firstIndex(of: selectedEmoji) {
            emojiCollectionView.selectItem(
                at: IndexPath(item: emojiIndex, section: 0),
                animated: false,
                scrollPosition: []
            )
        }

        let selectedHex = selectedColor.resolvedColor(
            with: traitCollection
        ).hexString

        if let colorIndex = colors.firstIndex(where: {
            $0.resolvedColor(with: traitCollection).hexString == selectedHex
        }) {
            colorCollectionView.selectItem(
                at: IndexPath(item: colorIndex, section: 0),
                animated: false,
                scrollPosition: []
            )
        }
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
    
    private func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 5

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }
    
    private func daysWord(_ count: Int) -> String {
        let lastTwo = count % 100
        let last = count % 10

        if lastTwo >= 11 && lastTwo <= 14 {
            return "дней"
        }

        switch last {
        case 1:
            return "день"
        case 2...4:
            return "дня"
        default:
            return "дней"
        }
    }

    @objc private func textFieldChanged() {
        updateCreateButtonState()
    }

    private func updateCreateButtonState() {
        let hasTitle = !(titleTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty

        createButton.isEnabled = hasTitle
        createButton.backgroundColor = hasTitle ? .backgroundColorButtonIsReadyToBeTappedIOS : .backgroundColorButtonIsNotReadyToBeTappedIOS
        
    }

    @objc private func cancelButtonTapped() {
        delegate?.newHabitViewControllerDidCancel(self)
        dismiss(animated: true)
    }

    @objc private func createButtonTapped() {
        guard let title = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !title.isEmpty
        else { return }

        switch mode {
        case .create:
            let tracker = Tracker(
                id: UUID(),
                name: title,
                color: selectedColor,
                emoji: selectedEmoji,
                schedule: selectedSchedule
            )

            delegate?.newHabitViewController(
                self,
                didCreateTracker: tracker,
                categoryTitle: selectedCategoryTitle ?? ""
            )

        case .edit:
            guard let oldTrackerId = editingTrackerId else { return }

            let tracker = Tracker(
                id: oldTrackerId,
                name: title,
                color: selectedColor,
                emoji: selectedEmoji,
                schedule: selectedSchedule
            )

            delegate?.newHabitViewController(
                self,
                didUpdateTracker: tracker,
                oldTrackerId: oldTrackerId,
                categoryTitle: selectedCategoryTitle ?? ""
            )
        }

        dismiss(animated: true)
    }
    
    @objc private func didTapView() {
        view.endEditing(true)
    }
}

extension NewHabitViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let currentText = textField.text,
              let textRange = Range(range, in: currentText)
        else {
            return false
        }

        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        let isLimitExceeded = updatedText.count > maxTitleLength

        updateTitleLimitState(isExceeded: isLimitExceeded)

        return !isLimitExceeded
    }
}
