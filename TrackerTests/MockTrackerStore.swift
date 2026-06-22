//
//  MockTrackerStore.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 22.06.2026.
//

import Foundation
@testable import Tracker

final class MockTrackerStore: TrackerStoreProtocol {
    weak var delegate: TrackerStoreDelegate?

    var trackers: [Tracker] = []

    func addTracker(_ tracker: Tracker, to categoryTitle: String) throws {}
    func updateTracker(_ tracker: Tracker, to categoryTitle: String) throws {}
    func deleteTracker(id: UUID) throws {}
}
