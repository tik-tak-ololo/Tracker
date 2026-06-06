//
//  OnboardingViewController+UIPageViewControllerDelegate.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 06.06.2026.
//

import UIKit

extension OnboardingViewController: UIPageViewControllerDelegate {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard
            completed,
            let currentVC = pageViewController.viewControllers?.first as? OnboardingPageViewController
        else {
            return
        }

        currentIndex = currentVC.pageIndex
        setPageControl(currentPage: currentIndex)
    }
}
