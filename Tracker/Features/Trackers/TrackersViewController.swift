//
//  TrackersViewController2.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 07.05.2026.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Stores
    
    private let trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()

    // MARK: - Data

    var categories: [TrackerCategory] = [] {
        didSet {
            reloadVisibleTrackers()
        }
    }

    var completedTrackers: [TrackerRecord] = []

    var visibleCategories: [TrackerCategory] = []

    var selectedDate = Date() {
        didSet {
            reloadVisibleTrackers()
        }
    }
    
    private var selectedFilter: TrackerFilter = .all {
        didSet {
            reloadVisibleTrackers()
            updateFiltersButtonAppearance()
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
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
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

    private let searchContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .searchFieldBackgroundColorIOS
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let searchIcon: UIImageView = {
        let image = UIImage(resource: .searchFieldIcon)
                .withRenderingMode(.alwaysTemplate)
        let iv = UIImageView(image: image)
        iv.tintColor = UIColor(resource: .searchFieldTextColorIOS)
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
            .foregroundColor: UIColor(resource: .searchFieldTextColorIOS),
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
    
    private let filtersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.backgroundColor = UIColor(red: 55/255, green: 114/255, blue: 231/255, alpha: 1)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter
    }()
    
    private var isSelectedDateInFuture: Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let selectedDay = calendar.startOfDay(for: selectedDate)
        return selectedDay > today
    }

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
        setupStores()
        reloadVisibleTrackers()
        
        searchTextField.delegate = self
        setupHideKeyboardOnTap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        AnalyticsService.shared.report(
            event: .open,
            screen: .main
        )
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        AnalyticsService.shared.report(
            event: .close,
            screen: .main
        )
    }

    // MARK: - Setup

    private func setupView() {
        view.backgroundColor = .backgroundColorIOS
    }
    
    private func setupNavigationBar() {

        let leftItem = makeAddBarButtonItem()
        let rightItem = UIBarButtonItem(customView: datePicker)

        if #available(iOS 26.0, *) {
            leftItem.hidesSharedBackground = true
            rightItem.hidesSharedBackground = true
        }

        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightItem
    }
    
    private func makeAddBarButtonItem() -> UIBarButtonItem {

        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(addTrackerButton)

        NSLayoutConstraint.activate([
            container.widthAnchor.constraint(equalToConstant: 44),
            container.heightAnchor.constraint(equalToConstant: 44),

            // ➕ Кнопка "+"
            addTrackerButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: -16),
            addTrackerButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            addTrackerButton.widthAnchor.constraint(equalToConstant: 44),
            addTrackerButton.heightAnchor.constraint(equalToConstant: 44)
        ])

        return UIBarButtonItem(customView: container)
    }
    
    private func setupSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(searchContainer)
        searchContainer.addSubview(searchIcon)
        searchContainer.addSubview(searchTextField)
        view.addSubview(collectionView)
        view.addSubview(filtersButton)
        view.addSubview(placeholderView)
        placeholderView.addSubview(placeholderImageView)
        placeholderView.addSubview(placeholderLabel)
    }
    
    private func setupHideKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapView)
        )

        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupContent() {
        titleLabel.attributedText = NSAttributedString(
            string: String(localized: "trackers.title"),
            attributes: titleAttributes
        )

        searchTextField.attributedPlaceholder = NSAttributedString(
            string: String(localized: "trackers.search.placeholder"),
            attributes: searchTextFieldAttributes
        )
        
        filtersButton.setTitle(NSLocalizedString("filters.button", comment: ""), for: .normal)
    }

    private func setupConstraints() {
        
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([

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
            
            filtersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filtersButton.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -16),
            filtersButton.widthAnchor.constraint(equalToConstant: 114),
            filtersButton.heightAnchor.constraint(equalToConstant: 50),

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
        
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset.bottom = 82
        collectionView.verticalScrollIndicatorInsets.bottom = 82
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
        
        filtersButton.addTarget(
            self,
            action: #selector(didTapFiltersButton),
            for: .touchUpInside
        )
    }

    private func setupStores() {
        trackerStore.delegate = self
        trackerCategoryStore.delegate = self
        trackerRecordStore.delegate = self

        categories = trackerCategoryStore.categories
        completedTrackers = Array(trackerRecordStore.records)
    }
    
    // MARK: - Actions

    @objc private func didTapAddTrackerButton() {
        
        AnalyticsService.shared.report(
            event: .click(item: .addTrack),
            screen: .main
        )
        
        let newHabitVC = NewHabitViewController()
        newHabitVC.delegate = self
        
        let navigationController = UINavigationController(rootViewController: newHabitVC)
        navigationController.modalPresentationStyle = .pageSheet
        
        present(navigationController, animated: true)
    }

    @objc private func didChangeSearchText(_ sender: UISearchTextField) {
        searchText = sender.text ?? ""
    }
    
    @objc private func didChangeDate(_ sender: UIDatePicker) {
        selectedDate = sender.date
    }
    
    @objc private func didTapView() {
        view.endEditing(true)
    }
    
    @objc private func didTapFiltersButton() {
        AnalyticsService.shared.report(
            event: .click(item: .filter),
            screen: .main
        )

        let filtersVC = FiltersViewController(selectedFilter: selectedFilter)

        filtersVC.onFilterSelected = { [weak self] filter in
            self?.applyFilter(filter)
        }

        let navigationController = UINavigationController(rootViewController: filtersVC)
        navigationController.modalPresentationStyle = .pageSheet

        present(navigationController, animated: true)
    }

    // MARK: - Logic

    func reloadVisibleTrackers() {
        let selectedDayOfWeek = dayOfWeek(from: selectedDate)

        let categoriesForSelectedDate = categories
            .map { category in
                let trackers = category.trackers.filter { tracker in
                    tracker.schedule.contains(selectedDayOfWeek)
                }

                return TrackerCategory(
                    title: category.title,
                    trackers: trackers
                )
            }
            .filter { !$0.trackers.isEmpty }

        let hasTrackersForSelectedDate = !categoriesForSelectedDate.isEmpty

        visibleCategories = categoriesForSelectedDate
            .map { category in
                let trackers = category.trackers.filter { tracker in
                    let matchesSearch = searchText.isEmpty ||
                        tracker.name.localizedCaseInsensitiveContains(searchText)

                    let matchesFilter: Bool

                    switch selectedFilter {
                    case .all, .today:
                        matchesFilter = true

                    case .completed:
                        matchesFilter = isTrackerCompleted(
                            id: tracker.id,
                            on: selectedDate
                        )

                    case .uncompleted:
                        matchesFilter = !isTrackerCompleted(
                            id: tracker.id,
                            on: selectedDate
                        )
                    }

                    return matchesSearch && matchesFilter
                }

                return TrackerCategory(
                    title: category.title,
                    trackers: trackers
                )
            }
            .filter { !$0.trackers.isEmpty }

        if visibleCategories.isEmpty {
            placeholderLabel.text = hasTrackersForSelectedDate
                ? "Ничего не найдено"
                : "Что будем отслеживать?"
        }

        placeholderView.isHidden = !visibleCategories.isEmpty
        collectionView.isHidden = visibleCategories.isEmpty
        filtersButton.isHidden = !hasTrackersForSelectedDate

        collectionView.reloadData()
    }

    func toggleTrackerCompletion(id: UUID) {
        guard !isSelectedDateInFuture else { return }
        
        AnalyticsService.shared.report(
            event: .click(item: .track),
            screen: .main
        )

        let record = TrackerRecord(
            trackerId: id,
            date: selectedDate
        )

        do {
            if trackerRecordStore.isTrackerCompleted(id, on: selectedDate) {
                try trackerRecordStore.deleteRecord(record)
            } else {
                try trackerRecordStore.addRecord(record)
            }
        } catch {
            assertionFailure("Failed to toggle tracker record: \(error)")
        }
    }

    func isTrackerCompleted(id: UUID, on date: Date) -> Bool {
        completedTrackers.contains {
            $0.trackerId == id &&
            Calendar.current.isDate($0.date, inSameDayAs: date)
        }
    }

    func completedDaysCount(for trackerId: UUID) -> Int {
        completedTrackers.filter {
            $0.trackerId == trackerId
        }.count
    }

    func addTracker(_ tracker: Tracker, toCategoryWithTitle title: String) {
        do {
            try trackerStore.addTracker(tracker, to: title)
        } catch {
            assertionFailure("Failed to add tracker: \(error)")
        }
    }
    
    func updateTracker(_ tracker: Tracker, toCategoryWithTitle title: String) {
        do {
            try trackerStore.updateTracker(tracker, to: title)
        } catch {
            assertionFailure("Failed to add tracker: \(error)")
        }
    }

    func deleteTracker(id: UUID) {
        do {
            try trackerStore.deleteTracker(id: id)
            reloadVisibleTrackers()
        } catch {
            assertionFailure("Failed to delete tracker: \(error)")
        }
    }
    
    func confirmDeleteTracker(at indexPath: IndexPath) {
        let category = visibleCategories[indexPath.section]
        let tracker = category.trackers[indexPath.item]

        let alert = UIAlertController(
            title: nil,
            message: "Уверены что хотите удалить трекер?",
            preferredStyle: .actionSheet
        )

        let deleteAction = UIAlertAction(
            title: "Удалить",
            style: .destructive
        ) { [weak self] _ in
            self?.deleteTracker(id: tracker.id)
        }

        let cancelAction = UIAlertAction(
            title: "Отменить",
            style: .cancel
        )

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    private func dayOfWeek(from date: Date) -> DayOfWeek {
        let dayOfWeekNumber = Calendar.current.component(.weekday, from: date)

        switch dayOfWeekNumber {
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
    
    func editTracker(at indexPath: IndexPath) {
        let category = visibleCategories[indexPath.section]
        let tracker = category.trackers[indexPath.item]

        let editVC = NewHabitViewController(
            mode: .edit(
                tracker: tracker,
                categoryTitle: category.title,
                completedDays: completedDaysCount(for: tracker.id)
            )
        )

        editVC.delegate = self

        let navigationController = UINavigationController(rootViewController: editVC)
        navigationController.modalPresentationStyle = .pageSheet

        present(navigationController, animated: true)
    }
    
    private func applyFilter(_ filter: TrackerFilter) {
        switch filter {
        case .all:
            selectedFilter = .all

        case .today:
            selectedDate = Date()
            datePicker.date = Date()
            selectedFilter = .all

        case .completed:
            selectedFilter = .completed

        case .uncompleted:
            selectedFilter = .uncompleted
        }
    }

    private func updateFiltersButtonAppearance() {
        let isActive = selectedFilter.isActiveFilter

        filtersButton.setTitleColor(
            isActive ? .systemRed : .white,
            for: .normal
        )
    }
}

extension TrackersViewController: TrackerStoreDelegate {
    func trackerStoreDidUpdate(_ store: TrackerStore) {
        categories = trackerCategoryStore.categories
    }
}

extension TrackersViewController: TrackerCategoryStoreDelegate {
    func trackerCategoryStoreDidUpdate(_ store: TrackerCategoryStore) {
        categories = store.categories
    }
}

extension TrackersViewController: TrackerRecordStoreDelegate {
    func trackerRecordStoreDidUpdate(_ store: TrackerRecordStore) {
        completedTrackers = Array(store.records)
        reloadVisibleTrackers()
    }
}
