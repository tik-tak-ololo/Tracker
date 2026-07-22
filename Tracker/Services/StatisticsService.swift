//
//  StatisticsService.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 22.06.2026.
//

import Foundation

final class StatisticsService {

    private let trackerStore: TrackerStore
    private let recordStore: TrackerRecordStore

    init(
        trackerStore: TrackerStore,
        recordStore: TrackerRecordStore
    ) {
        self.trackerStore = trackerStore
        self.recordStore = recordStore
    }

    func makeStatistics() -> [StatisticsItem] {
        let trackers = trackerStore.trackers
        let records = Array(recordStore.records)

        let bestPeriod = calculateBestPeriod(records: records)
        let idealDays = calculateIdealDays(
            trackers: trackers,
            records: records
        )
        let completedTrackers = records.count
        let averageValue = calculateAverageValue(records: records)

        return [
            StatisticsItem(value: bestPeriod, title: "Лучший период"),
            StatisticsItem(value: idealDays, title: "Идеальные дни"),
            StatisticsItem(value: completedTrackers, title: "Трекеров завершено"),
            StatisticsItem(value: averageValue, title: "Среднее значение")
        ]
    }

    func hasStatistics() -> Bool {
        recordStore.records.isEmpty == false
    }

    private func calculateBestPeriod(records: [TrackerRecord]) -> Int {
        let calendar = Calendar.current

        let dates = Set(
            records.map {
                calendar.startOfDay(for: $0.date)
            }
        )

        let sortedDates = dates.sorted()

        var bestPeriod = 0
        var currentPeriod = 0
        var previousDate: Date?

        for date in sortedDates {
            if let previousDate,
               let nextDate = calendar.date(byAdding: .day, value: 1, to: previousDate),
               calendar.isDate(date, inSameDayAs: nextDate) {
                currentPeriod += 1
            } else {
                currentPeriod = 1
            }

            bestPeriod = max(bestPeriod, currentPeriod)
            previousDate = date
        }

        return bestPeriod
    }

    private func calculateIdealDays(
        trackers: [Tracker],
        records: [TrackerRecord]
    ) -> Int {
        let calendar = Calendar.current

        let recordsByDate = Dictionary(grouping: records) {
            calendar.startOfDay(for: $0.date)
        }

        var idealDays = 0

        for (date, dayRecords) in recordsByDate {
            let dayOfWeek = DayOfWeek.fromCalendarWeekday(
                Calendar.current.component(.weekday, from: date)
            )

            let plannedTrackers = trackers.filter {
                $0.schedule.contains(dayOfWeek)
            }

            guard plannedTrackers.isEmpty == false else { continue }

            let completedIds = Set(dayRecords.map { $0.trackerId })
            let plannedIds = Set(plannedTrackers.map { $0.id })

            if plannedIds.isSubset(of: completedIds) {
                idealDays += 1
            }
        }

        return idealDays
    }

    private func calculateAverageValue(records: [TrackerRecord]) -> Int {
        let calendar = Calendar.current

        let dates = Set(
            records.map {
                calendar.startOfDay(for: $0.date)
            }
        )

        guard dates.isEmpty == false else {
            return 0
        }

        return records.count / dates.count
    }
}
