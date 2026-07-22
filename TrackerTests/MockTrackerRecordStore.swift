//
//  MockTrackerRecordStore.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 22.06.2026.
//

import Foundation
@testable import Tracker

final class MockTrackerRecordStore: TrackerRecordStoreProtocol {
    weak var delegate: TrackerRecordStoreDelegate?

    var records: Set<TrackerRecord> = []

    func addRecord(_ record: TrackerRecord) throws {}
    func deleteRecord(_ record: TrackerRecord) throws {}

    func isTrackerCompleted(_ trackerId: UUID, on date: Date) -> Bool {
        records.contains {
            $0.trackerId == trackerId &&
            Calendar.current.isDate($0.date, inSameDayAs: date)
        }
    }

    func completedDaysCount(for trackerId: UUID) -> Int {
        records.filter { $0.trackerId == trackerId }.count
    }
}
