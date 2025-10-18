import Foundation
import SwiftData

@Model
final class FocusSession {
    @Attribute(.unique) var id: UUID
    var startTime: Date
    var endTime: Date
    var duration: TimeInterval

    init(id: UUID = UUID(), startTime: Date, endTime: Date, duration: TimeInterval) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
    }
}
