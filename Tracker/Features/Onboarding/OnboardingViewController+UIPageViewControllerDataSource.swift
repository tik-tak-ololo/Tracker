//
//  OnboardingViewController+UIPageViewControllerDataSource.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 06.06.2026.
//

import UIKit

extension OnboardingViewController: UIPageViewControllerDataSource {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard
            let pageVC = viewController as? OnboardingPageViewController,
            pageVC.pageIndex > 0
        else {
            return nil
        }

        return makePageViewController(index: pageVC.pageIndex - 1)
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard
            let pageVC = viewController as? OnboardingPageViewController,
            pageVC.pageIndex < pages.count - 1
        else {
            return nil
        }

        return makePageViewController(index: pageVC.pageIndex + 1)
    }
}
