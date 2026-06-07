//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 07.06.2026.
//

import UIKit

final class CategoryViewController: UIViewController {

    let viewModel: CategoryViewModel
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let tableView = UITableView(frame: .zero, style: .plain)
    private var tableHeightConstraint: NSLayoutConstraint?

    private lazy var addCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .blackDayIOS
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupScrollView()
        setupTableView()
        setupButton()
        setupContent()
        bindViewModel()
        viewModel.viewDidLoad()

    }

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
        title = "Категория"
    }

    private func setupTableView() {
        tableView.backgroundColor = .backgroundDayIOS
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.separatorStyle = .none
        tableView.rowHeight = 75
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(tableView)
        
        let heightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableHeightConstraint = heightConstraint

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            heightConstraint
        ])
    }

    private func setupButton() {
        view.addSubview(addCategoryButton)

        NSLayoutConstraint.activate([
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func bindViewModel() {
        viewModel.onCategoriesChanged = { [weak self] in
            self?.tableView.reloadData()
            self?.updateTableHeight()
        }

        viewModel.onError = { [weak self] message in
            self?.showError(message)
        }
    }

    private func updateTableHeight() {
        tableHeightConstraint?.constant = CGFloat(viewModel.numberOfRows) * tableView.rowHeight
        view.layoutIfNeeded()
    }

    @objc private func addCategoryButtonTapped() {
        let viewController = CategoryEditViewController(mode: .create)

        viewController.onSave = { [weak self] title in
            self?.viewModel.addCategory(title: title)
        }

        navigationController?.pushViewController(viewController, animated: true)
    }

    func showDeleteAlert(indexPath: IndexPath) {
        let alert = UIAlertController(
            title: nil,
            message: "Эта категория точно не нужна?",
            preferredStyle: .actionSheet
        )

        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteCategory(at: indexPath)
        })

        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel))

        present(alert, animated: true)
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
}
