//
//  HabitScreenMode.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 20.06.2026.
//

enum HabitScreenMode {
    case create
    case edit(tracker: Tracker, categoryTitle: String, completedDays: Int)
}
