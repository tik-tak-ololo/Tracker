//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 24.04.2026.
//

import UIKit

final class StatisticsViewController: UIViewController {

    private let statisticsService: StatisticsService

    private var statistics: [StatisticsItem] = []

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Статистика"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .textColorIOS
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .statisticsEmpty)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Анализировать пока нечего"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .textColorIOS
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(statisticsService: StatisticsService) {
        self.statisticsService = statisticsService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        reloadStatistics()
    }

    private func setupView() {
        view.backgroundColor = .backgroundColorIOS

        view.addSubview(titleLabel)
        view.addSubview(stackView)
        view.addSubview(emptyImageView)
        view.addSubview(emptyLabel)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),

            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 77),

            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            emptyImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyImageView.heightAnchor.constraint(equalToConstant: 80),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 8)
        ])
    }

    private func reloadStatistics() {
        statistics = statisticsService.makeStatistics()

        let hasStatistics = statisticsService.hasStatistics()

        stackView.isHidden = !hasStatistics
        emptyImageView.isHidden = hasStatistics
        emptyLabel.isHidden = hasStatistics

        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        guard hasStatistics else { return }

        statistics.forEach { item in
            let view = StatisticsCell()
            view.configure(with: item)
            stackView.addArrangedSubview(view)
        }
    }
}
