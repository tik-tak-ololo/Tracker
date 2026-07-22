//
//  TrackerRecordStoreProtocol.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 22.06.2026.
//

import Foundation

protocol TrackerRecordStoreProtocol: AnyObject {
    var delegate: TrackerRecordStoreDelegate? { get set }
    var records: Set<TrackerRecord> { get }

    func addRecord(_ record: TrackerRecord) throws
    func deleteRecord(_ record: TrackerRecord) throws
    func isTrackerCompleted(_ trackerId: UUID, on date: Date) -> Bool
    func completedDaysCount(for trackerId: UUID) -> Int
}
