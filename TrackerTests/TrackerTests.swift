//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Сергей Хмелёв on 17.06.2026.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testViewController() {

        let trackerStore = MockTrackerStore()

        let categoryStore = MockTrackerCategoryStore(
            categories: [
                TrackerCategory(
                    title: "Важное",
                    trackers: [
                        TrackerTestData.tracker1,
                        TrackerTestData.tracker2
                    ]
                )
            ]
        )

        let recordStore = MockTrackerRecordStore()

        let vc = TrackersViewController(
            trackerStore: trackerStore,
            trackerCategoryStore: categoryStore,
            trackerRecordStore: recordStore
        )

        assertSnapshot(
            of: vc,
            as: .image
        )
    }
}
