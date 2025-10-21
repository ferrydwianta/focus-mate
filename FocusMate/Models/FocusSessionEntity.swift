import Foundation
import SwiftData

@Model
final class FocusSessionEntity {
    @Attribute(.unique) var id: UUID
    var startTime: Date
    var endTime: Date
    var duration: TimeInterval
    var keyboardCount: Int
    var mouseClickCount: Int

    @Relationship var activations: [AppActivationEntity] = []

    init(
        id: UUID = UUID(),
        startTime: Date,
        endTime: Date,
        duration: TimeInterval,
        keyboardCount: Int = 0,
        mouseClickCount: Int = 0
    ) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
        self.keyboardCount = keyboardCount
        self.mouseClickCount = mouseClickCount
    }
}
