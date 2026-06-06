//
//  DayOfWeekTransformer.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 24.05.2026.
//

import Foundation

@objc(DayOfWeekTransformer)
final class DayOfWeekTransformer: NSSecureUnarchiveFromDataTransformer {

    override static var allowedTopLevelClasses: [AnyClass] {
        [
            NSArray.self,
            NSNumber.self
        ]
    }

    static let name = NSValueTransformerName(rawValue: "DayOfWeekTransformer")

    static func register() {
        let transformer = DayOfWeekTransformer()
        ValueTransformer.setValueTransformer(
            transformer,
            forName: name
        )
    }
}
