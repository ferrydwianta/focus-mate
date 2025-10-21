import Foundation
import SwiftData

final class StorageService {
    let container: ModelContainer
    
    init() {
        do {
            let schema = Schema([FocusSessionEntity.self, AppActivationEntity.self])
            let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            container = try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
    func saveSession(
        start: Date,
        end: Date,
        duration: TimeInterval,
        keyboardCount: Int,
        mouseClickCount: Int,
        activations: [AppActivation]
    ) {
        let context = ModelContext(container)
        
        let session = FocusSessionEntity(
            startTime: start,
            endTime: end,
            duration: duration,
            keyboardCount: keyboardCount,
            mouseClickCount: mouseClickCount
        )
        context.insert(session)
        
        for a in activations {
            let e = AppActivationEntity(
                bundleID: a.bundleID,
                appName: a.appName,
                timestamp: a.timestamp
            )
            e.session = session
            context.insert(e)
        }
        
        do {
            try context.save()
            AppLogger.debug("Saved FocusSession \(session.id) with \(activations.count) activation(s)", category: .storage)
        } catch {
            AppLogger.error("Failed to save FocusSession: \(error.localizedDescription)", category: .storage)
        }
    }
    
    func fetchSessions() -> [FocusSessionEntity] {
        let context = ModelContext(container)
        let descriptor = FetchDescriptor<FocusSessionEntity>(
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
