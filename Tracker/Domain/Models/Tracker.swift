//
//  Tracker.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 09.05.2026.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: Set<Weekday>
}
