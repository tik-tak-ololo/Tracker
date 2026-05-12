//
//  TrackersViewController2.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 07.05.2026.
//

import UIKit

final class TrackersViewController: UIViewController {

    // MARK: - Data

    var categories: [TrackerCategory] = [] {
        didSet {
            reloadVisibleTrackers()
        }
    }

    var completedTrackers: [TrackerRecord] = []

    private var visibleCategories: [TrackerCategory] = []

    private var selectedDate = Date() {
        didSet {
            reloadVisibleTrackers()
        }
    }

    private var searchText = "" {
        didSet {
            reloadVisibleTrackers()
        }
    }

    // MARK: - UI

    private let addTrackerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(resource: .addTrackerButton), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

//    private let dateLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .textColorIOS
//        label.backgroundColor = .datePickerBackgroundIOS
//        label.layer.cornerRadius = 8
//        label.clipsToBounds = true
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private let dateAttributes: [NSAttributedString.Key: Any] = {
//
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.minimumLineHeight = 22
//        paragraphStyle.maximumLineHeight = 22
//        paragraphStyle.alignment = .center
//
//        return [
//            .font: UIFont.systemFont(ofSize: 17, weight: .regular),
//            .paragraphStyle: paragraphStyle
//        ]
//
//    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale(identifier: "ru_RU")
        picker.calendar = .current
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textColorIOS
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleAttributes: [NSAttributedString.Key: Any] = {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 40.8
        paragraphStyle.maximumLineHeight = 40.8

        return [
            .font: UIFont.systemFont(ofSize: 34, weight: .bold),
            .paragraphStyle: paragraphStyle
        ]

    }()
    
    // MARK: - Search

    private let searchContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .searchFieldBackgroundColorIOS
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let searchIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(resource: .searchFieldIcon))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let searchTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let searchTextFieldAttributes: [NSAttributedString.Key: Any] = {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 22
        paragraphStyle.maximumLineHeight = 22

        return [
            .font: UIFont.systemFont(ofSize: 17, weight: .regular),
            .foregroundColor: UIColor(
                red: 174/255,
                green: 175/255,
                blue: 180/255,
                alpha: 1
            ),
            .paragraphStyle: paragraphStyle
        ]

    }()

    private let placeholderView: UIView = {
        let pv = UIView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        return pv
    }()

    private let placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .stubNoTrackers)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 12, left: 16, bottom: 24, right: 16)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 9

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .backgroundColorIOS
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupNavigationBar()
        setupSubviews()
        setupContent()
        setupConstraints()
        setupCollectionView()
        setupActions()
        setupInitialData()
        reloadVisibleTrackers()
    }

    // MARK: - Setup

    private func setupView() {
        view.backgroundColor = .backgroundColorIOS
    }
    
    private func setupNavigationBar() {
        let addButton = UIButton(type: .system)
        addButton.setImage(UIImage(resource: .addTrackerButton), for: .normal)
        addButton.tintColor = .label
        addButton.frame = CGRect(x: 0, y: 0, width: 42, height: 42)

        addButton.addTarget(
            self,
            action: #selector(didTapAddTrackerButton),
            for: .touchUpInside
        )

        let leftItem = UIBarButtonItem(customView: addButton)
        let rightItem = UIBarButtonItem(customView: datePicker)

        if #available(iOS 26.0, *) {
            leftItem.hidesSharedBackground = true
            rightItem.hidesSharedBackground = true
        }

        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightItem
    }
    
    private func setupSubviews() {
//        view.addSubview(addTrackerButton)
//        view.addSubview(dateLabel)
        view.addSubview(titleLabel)
        view.addSubview(searchContainer)
        searchContainer.addSubview(searchIcon)
        searchContainer.addSubview(searchTextField)
        view.addSubview(collectionView)
        view.addSubview(placeholderView)
        placeholderView.addSubview(placeholderImageView)
        placeholderView.addSubview(placeholderLabel)
    }
    
    private func setupContent() {
        
//        // dateLabel
//        let text = dateFormatter.string(from: selectedDate)
//        dateLabel.attributedText = NSAttributedString(
//            string: text,
//            attributes: dateAttributes
//        )
        
        // titleLabel
        titleLabel.attributedText = NSAttributedString(
            string: "Трекеры",
            attributes: titleAttributes
        )
        
        // searchTextField
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Поиск",
            attributes: searchTextFieldAttributes
        )
        
    }

    private func setupConstraints() {
        
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
//            // ➕ Кнопка "+"
//            addTrackerButton.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 6),
//            addTrackerButton.topAnchor.constraint(equalTo: safe.topAnchor, constant: 1),
//            addTrackerButton.widthAnchor.constraint(equalToConstant: 42),
//            addTrackerButton.heightAnchor.constraint(equalToConstant: 42),

//            // 📅 Дата
//            dateLabel.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),
//            dateLabel.centerYAnchor.constraint(equalTo: addTrackerButton.centerYAnchor),
//            dateLabel.widthAnchor.constraint(equalToConstant: 77),
//            dateLabel.heightAnchor.constraint(equalToConstant: 34),

            // 🏷 Заголовок
            titleLabel.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: safe.topAnchor, constant: 1),
            titleLabel.widthAnchor.constraint(equalToConstant: 254),
            titleLabel.heightAnchor.constraint(equalToConstant: 41),

            // 🔍 Поиск
            searchContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchContainer.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            searchContainer.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),
            searchContainer.heightAnchor.constraint(equalToConstant: 36),

            searchIcon.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor, constant: 12),
            searchIcon.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),
            searchIcon.widthAnchor.constraint(equalToConstant: 15.63),
            searchIcon.heightAnchor.constraint(equalToConstant: 15.78),
 
            searchTextField.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: 8),
            searchTextField.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor, constant: -12),
            searchTextField.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),

            // 🎛️ Коллекция
            collectionView.topAnchor.constraint(equalTo: searchContainer.bottomAnchor, constant: 34),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // ⭐ Empty state (центр, но чуть ниже)
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            placeholderImageView.topAnchor.constraint(equalTo: placeholderView.topAnchor),
            placeholderImageView.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor),
            placeholderImageView.widthAnchor.constraint(equalToConstant: 80),
            placeholderImageView.heightAnchor.constraint(equalToConstant: 80),

            placeholderLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: placeholderView.leadingAnchor),
            placeholderLabel.trailingAnchor.constraint(equalTo: placeholderView.trailingAnchor),
            placeholderLabel.bottomAnchor.constraint(equalTo: placeholderView.bottomAnchor)
        ])
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(
            TrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier
        )

        collectionView.register(
            TrackerSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerSectionHeaderView.reuseIdentifier
        )
    }

    private func setupActions() {
        addTrackerButton.addTarget(
            self,
            action: #selector(didTapAddTrackerButton),
            for: .touchUpInside
        )

        searchTextField.addTarget(
            self,
            action: #selector(didChangeSearchText),
            for: .editingChanged
        )
        
        datePicker.addTarget(
            self,
            action: #selector(didChangeDate),
            for: .valueChanged
        )
    }

    private func setupInitialData() {
        categories = [
            TrackerCategory(
                title: "Домашний уют",
                trackers: [
                    Tracker(
                        id: UUID(),
                        name: "Поливать растения",
                        color: .systemGreen,
                        emoji: "😪",
                        schedule: [
                            .monday,
                            .tuesday,
                            .wednesday,
                            .thursday,
                            .friday,
                            .saturday,
                            .sunday
                        ]
                    )
                ]
            )
        ]
    }

    // MARK: - Actions

    @objc private func didTapAddTrackerButton() {
        let tracker = Tracker(
            id: UUID(),
            name: "Новый трекер",
            color: .systemBlue,
            emoji: "🔥",
            schedule: [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
        )

        addTracker(tracker, toCategoryWithTitle: "Домашний уют")
    }

    @objc private func didChangeSearchText(_ sender: UISearchTextField) {
        searchText = sender.text ?? ""
    }
    
    @objc private func didChangeDate(_ sender: UIDatePicker) {
        selectedDate = sender.date
    }

    // MARK: - Logic

    private func reloadVisibleTrackers() {
        let selectedWeekday = weekday(from: selectedDate)

        visibleCategories = categories
            .map { category in
                let trackers = category.trackers.filter { tracker in
                    let matchesDate = tracker.schedule.contains(selectedWeekday)

                    let matchesSearch = searchText.isEmpty ||
                    tracker.name.localizedCaseInsensitiveContains(searchText)

                    return matchesDate && matchesSearch
                }

                return TrackerCategory(
                    title: category.title,
                    trackers: trackers
                )
            }
            .filter { !$0.trackers.isEmpty }

        placeholderView.isHidden = !visibleCategories.isEmpty
        collectionView.isHidden = visibleCategories.isEmpty

        collectionView.reloadData()
    }

    private func toggleTrackerCompletion(id: UUID) {
        if isTrackerCompleted(id: id, on: selectedDate) {
            completedTrackers.removeAll {
                $0.trackerId == id &&
                Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
            }
        } else {
            completedTrackers.append(
                TrackerRecord(
                    trackerId: id,
                    date: selectedDate
                )
            )
        }

        collectionView.reloadData()
    }

    private func isTrackerCompleted(id: UUID, on date: Date) -> Bool {
        completedTrackers.contains {
            $0.trackerId == id &&
            Calendar.current.isDate($0.date, inSameDayAs: date)
        }
    }

    private func completedDaysCount(for trackerId: UUID) -> Int {
        completedTrackers.filter {
            $0.trackerId == trackerId
        }.count
    }

    private func addTracker(_ tracker: Tracker, toCategoryWithTitle title: String) {
        let categoryExists = categories.contains {
            $0.title == title
        }

        if categoryExists {
            categories = categories.map { category in
                guard category.title == title else {
                    return category
                }

                return TrackerCategory(
                    title: category.title,
                    trackers: category.trackers + [tracker]
                )
            }
        } else {
            categories = categories + [
                TrackerCategory(
                    title: title,
                    trackers: [tracker]
                )
            ]
        }
    }

    private func weekday(from date: Date) -> Weekday {
        let weekdayNumber = Calendar.current.component(.weekday, from: date)

        switch weekdayNumber {
        case 1:
            return .sunday
        case 2:
            return .monday
        case 3:
            return .tuesday
        case 4:
            return .wednesday
        case 5:
            return .thursday
        case 6:
            return .friday
        default:
            return .saturday
        }
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        visibleCategories[section].trackers.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }

        let tracker = visibleCategories[indexPath.section].trackers[indexPath.item]

        cell.configure(
            with: tracker,
            completedDays: completedDaysCount(for: tracker.id),
            isCompleted: isTrackerCompleted(id: tracker.id, on: selectedDate)
        ) { [weak self] trackerId in
            self?.toggleTrackerCompletion(id: trackerId)
        }

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackerSectionHeaderView.reuseIdentifier,
            for: indexPath
        ) as? TrackerSectionHeaderView else {
            return UICollectionReusableView()
        }

        header.configure(title: visibleCategories[indexPath.section].title)
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let horizontalInsets: CGFloat = 32
        let spacing: CGFloat = 9

        let width = (
            collectionView.bounds.width
            - horizontalInsets
            - spacing
        ) / 2

        return CGSize(width: width, height: 132)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 18)
    }
}
