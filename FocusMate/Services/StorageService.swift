import Foundation
import SwiftData

final class StorageService {
    
    let container: ModelContainer

    init() {
        do {
            let schema = Schema([FocusSession.self])
            let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            container = try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }

    func saveSession(start: Date, end: Date, duration: TimeInterval) {
        let context = ModelContext(container)
        let session = FocusSession(startTime: start, endTime: end, duration: duration)
        context.insert(session)
        do {
            try context.save()
            AppLogger.debug("Saved FocusSession: \(session.id.uuidString)", category: .storage)
        } catch {
            AppLogger.error("Failed to save FocusSession: \(error.localizedDescription)", category: .storage)
        }
    }

    func fetchSessions() -> [FocusSession] {
        let context = ModelContext(container)
        let descriptor = FetchDescriptor<FocusSession>(
            sortBy: [SortDescriptor(\.startTime, order: .reverse)]
        )
        do {
            let sessions = try context.fetch(descriptor)
            AppLogger.debug("Fetched \(sessions.count) FocusSession(s)", category: .storage)
            return sessions
        } catch {
            AppLogger.error("Failed to fetch FocusSession(s): \(error.localizedDescription)", category: .storage)
            return []
        }
    }
}
