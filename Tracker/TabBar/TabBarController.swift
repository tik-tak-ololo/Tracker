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
        trackersViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(resource: .trackersTabBar),
            selectedImage: nil
        )
        
        let statisticsViewController = StatisticsViewController()
        
        statisticsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(resource: .statisticsTabBar),
            selectedImage: nil
        )

        self.viewControllers = [trackersViewController, statisticsViewController]
    }

}
