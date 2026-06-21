//
//  TabBarController.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 24.04.2026.
//

import UIKit
 
final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    private func setupTabs() {

        let trackersViewController = TrackersViewController()
        let trackersNavigationController = UINavigationController(
            rootViewController: trackersViewController
        )
        
        let trackersTabTitle = NSLocalizedString(
            "trackers.tab",
            comment: ""
        )

        let statisticsTabTitle = NSLocalizedString(
            "statistics.tab",
            comment: ""
        )

        trackersNavigationController.tabBarItem = UITabBarItem(
            title: trackersTabTitle,
            image: UIImage(systemName: "record.circle.fill"),
            selectedImage: nil
        )
        
        let statisticsViewController = StatisticsViewController()
        
        statisticsViewController.tabBarItem = UITabBarItem(
            title: statisticsTabTitle,
            image: UIImage(resource: .statisticsTabBar),
            selectedImage: nil
        )

        self.viewControllers = [trackersNavigationController, statisticsViewController]
    }

}
