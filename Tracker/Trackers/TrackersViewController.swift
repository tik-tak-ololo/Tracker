//
//  ViewController.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 24.04.2026.
//

import UIKit

class TrackersViewController: UIViewController {
    
    // MARK: - UI

    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "14.12.22"
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textAlignment = .center
        label.backgroundColor = UIColor.systemGray5
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Search

    private let searchContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let searchIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iv.tintColor = .systemGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let searchTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Поиск"
        tf.font = .systemFont(ofSize: 17)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    // MARK: - Empty State

    private let emptyImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(resource: .stubNoTrackers) // asset из Figma
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var emptyStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emptyImageView, emptyLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupView() {
        view.backgroundColor = .ypWhiteIOS
    }
    
    private func setupSubviews() {
        
        view.addSubview(addButton)
        view.addSubview(dateLabel)
        view.addSubview(titleLabel)
        view.addSubview(searchContainer)
        view.addSubview(emptyStack)

        searchContainer.addSubview(searchIcon)
        searchContainer.addSubview(searchTextField)
        
    }
    
    private func setupConstraints() {
        
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([

            // ➕ Кнопка "+"
            addButton.topAnchor.constraint(equalTo: safe.topAnchor, constant: 8),
            addButton.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            addButton.widthAnchor.constraint(equalToConstant: 24),
            addButton.heightAnchor.constraint(equalToConstant: 24),

            // 📅 Дата
            dateLabel.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),
            dateLabel.heightAnchor.constraint(equalToConstant: 28),
            dateLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 70),

            // 🏷 Заголовок
            titleLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),

            // 🔍 Search
            searchContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            searchContainer.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            searchContainer.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),
            searchContainer.heightAnchor.constraint(equalToConstant: 36),

            searchIcon.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor, constant: 12),
            searchIcon.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),

            searchTextField.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: 8),
            searchTextField.trailingAnchor.constraint(lessThanOrEqualTo: searchContainer.trailingAnchor, constant: -12),
            searchTextField.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),

            // ⭐ Empty state (центр, но чуть ниже)
            emptyStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40),

            emptyImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyImageView.heightAnchor.constraint(equalToConstant: 80)
        ])

    }


}

