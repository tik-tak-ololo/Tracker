//
//  ScheduleViewControllerDelegate.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 13.05.2026.
//

protocol ScheduleViewControllerDelegate: AnyObject {
    func scheduleViewController(
        _ controller: ScheduleViewController,
        didSelect schedule: Set<DayOfWeek>
    )
}
