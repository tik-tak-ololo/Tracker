//
//  TrackerStoreProtocol.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 22.06.2026.
//

import Foundation

protocol TrackerStoreProtocol: AnyObject {
    var delegate: TrackerStoreDelegate? { get set }
    var trackers: [Tracker] { get }

    func addTracker(_ tracker: Tracker, to categoryTitle: String) throws
    func updateTracker(_ tracker: Tracker, to categoryTitle: String) throws
    func deleteTracker(id: UUID) throws
}
