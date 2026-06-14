//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 06.06.2026.
//

import UIKit

final class OnboardingViewController: UIViewController {

    let pages: [OnboardingPage] = [
        OnboardingPage(
            imageName: "onboarding_blue",
            title: "Отслеживайте только\nто, что хотите",
            subtitle: nil
        ),
        OnboardingPage(
            imageName: "onboarding_red",
            title: "Даже если это\nне литры воды и йога",
            subtitle: nil
        )
    ]

    var currentIndex = 0

    private lazy var pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )

    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPage = 0
        control.numberOfPages = 2
        control.currentPageIndicatorTintColor = .black
        control.pageIndicatorTintColor = .black.withAlphaComponent(0.3)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Вот это технологии!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor(named: "YP Black") ?? .black
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPageViewController()
        setupControls()
    }

    private func setupPageViewController() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)

        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        pageViewController.didMove(toParent: self)

        pageViewController.dataSource = self
        pageViewController.delegate = self

        let firstVC = makePageViewController(index: 0)
        pageViewController.setViewControllers(
            [firstVC],
            direction: .forward,
            animated: false
        )
    }

    private func setupControls() {
        view.addSubview(pageControl)
        view.addSubview(actionButton)

        NSLayoutConstraint.activate([
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            actionButton.heightAnchor.constraint(equalToConstant: 60),

            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -24)
        ])
    }

    func makePageViewController(index: Int) -> OnboardingPageViewController {
        let viewController = OnboardingPageViewController()
        viewController.page = pages[index]
        viewController.pageIndex = index
        return viewController
    }

    @objc private func didTapActionButton() {
        UserDefaultsService.shared.hasSeenOnboarding = true

        let mainViewController = TrackersViewController()

        let navigationController = UINavigationController(
            rootViewController: mainViewController
        )

        guard let window = view.window else { return }

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func setPageControl(currentPage: Int) {
        pageControl.currentPage = currentPage
    }
}




