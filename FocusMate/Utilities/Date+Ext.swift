//
//  Date+Ext.swift
//  FocusMate
//
//  Created by Ferry Dwianta P on 18/10/25.
//

import Foundation

extension Date {
    func dateRange(to end: Date) -> String {
        let cal = Calendar.current
        let sameDay = cal.isDate(self, inSameDayAs: end)

        if sameDay {
            return formatted(.dateTime.year().month().day())  // e.g. "Oct 18, 2025"
        } else {
            let s = formatted(.dateTime.month(.abbreviated).day())
            let e = end.formatted(.dateTime.month(.abbreviated).day().year())
            return "\(s) → \(e)" // e.g. "Oct 18 → Oct 19, 2025"
        }
    }

    func timeRange(to end: Date) -> String {
        let cal = Calendar.current
        let sameDay = cal.isDate(self, inSameDayAs: end)

        if sameDay {
            let s = formatted(.dateTime.hour().minute())
            let e = end.formatted(.dateTime.hour().minute())
            return "\(s) – \(e)" // e.g. "09:00 – 11:15"
        } else {
            let s = formatted(.dateTime.month(.abbreviated).day().hour().minute())
            let e = end.formatted(.dateTime.month(.abbreviated).day().hour().minute())
            return "\(s) → \(e)" // e.g. "Oct 18, 21:30 → Oct 19, 07:10"
        }
    }
}
